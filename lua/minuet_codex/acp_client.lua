local config_mod = require("minuet_codex.config")
local log = require("minuet_codex.log")
local parser = require("minuet_codex.parser")
local prompt = require("minuet_codex.prompt")

local M = {}

local METHODS = {
	INITIALIZE = "initialize",
	AUTHENTICATE = "authenticate",
	SESSION_CANCEL = "session/cancel",
	SESSION_NEW = "session/new",
	SESSION_PROMPT = "session/prompt",
	SESSION_REQUEST_PERMISSION = "session/request_permission",
	SESSION_SET_CONFIG_OPTION = "session/set_config_option",
	SESSION_UPDATE = "session/update",
	FS_READ_TEXT_FILE = "fs/read_text_file",
	FS_WRITE_TEXT_FILE = "fs/write_text_file",
}

local JSONRPC_INTERNAL_ERROR = -32603
local JSONRPC_INVALID_PARAMS = -32602

local Client = {}
Client.__index = Client

local function empty_dict()
	return vim.empty_dict and vim.empty_dict() or {}
end

local function redact(text)
	return log.redact(text)
end

local function notify(message, level)
	level = level or vim.log.levels.INFO
	local log_level = level >= vim.log.levels.ERROR and "error"
		or level >= vim.log.levels.WARN and "warn"
		or "info"
	log.write(log_level, message)
	vim.schedule(function()
		vim.notify("[minuet-codex] " .. message, level)
	end)
end

local function encode(message)
	local ok, encoded = pcall(vim.json.encode, message)
	if not ok then
		return nil, encoded
	end
	return encoded
end

local function decode(line)
	local ok, decoded = pcall(vim.json.decode, line)
	if not ok then
		return nil, decoded
	end
	return decoded
end

local function extract_text(block)
	if type(block) ~= "table" then
		return nil
	end
	if block.type == "text" and type(block.text) == "string" then
		return block.text
	end
	if block.type == "resource" and type(block.resource) == "table" then
		return block.resource.text
	end
	return nil
end

function Client.new()
	return setmetatable({
		id = 0,
		status = "stopped",
		handle = nil,
		ready = false,
		session_id = nil,
		agent_info = nil,
		config_options = nil,
		line_buffer = "",
		pending = {},
		start_callbacks = {},
		active = nil,
		request_seq = 0,
		last_error = nil,
		last_stderr = nil,
	}, Client)
end

function Client:_config()
	return config_mod.get()
end

function Client:_next_id()
	self.id = self.id + 1
	return self.id
end

function Client:_write(message)
	if not self.handle then
		return false, "codex-acp process is not running"
	end

	local encoded, err = encode(message)
	if not encoded then
		return false, err
	end

	local ok, write_err = pcall(function()
		self.handle:write(encoded .. "\n")
	end)
	if not ok then
		return false, write_err
	end

	return true
end

function Client:_request(method, params, timeout_ms, callback)
	local id = self:_next_id()
	local done = false
	local timer

	local function finish(result, err)
		if done then
			return
		end
		done = true
		if err then
			log.write("warn", "rpc request failed", { id = id, method = method, error = err.message or err })
		else
			log.write("debug", "rpc request completed", { id = id, method = method })
		end
		self.pending[id] = nil
		if timer and not timer:is_closing() then
			timer:stop()
			timer:close()
		end
		callback(result, err)
	end

	self.pending[id] = finish
	log.write("debug", "rpc request started", { id = id, method = method, timeout_ms = timeout_ms })

	if timeout_ms and timeout_ms > 0 then
		timer = vim.uv.new_timer()
		timer:start(timeout_ms, 0, function()
			vim.schedule(function()
				finish(nil, { message = method .. " timed out" })
			end)
		end)
	end

	local ok, err = self:_write({
		jsonrpc = "2.0",
		id = id,
		method = method,
		params = params or empty_dict(),
	})
	if not ok then
		finish(nil, { message = err })
	end

	return id
end

function Client:_notify(method, params)
	log.write("debug", "rpc notification sent", { method = method })
	return self:_write({
		jsonrpc = "2.0",
		method = method,
		params = params or empty_dict(),
	})
end

function Client:_send_result(id, result)
	log.write("debug", "rpc result sent", { id = id })
	self:_write({
		jsonrpc = "2.0",
		id = id,
		result = result or empty_dict(),
	})
end

function Client:_send_error(id, message, code)
	log.write("warn", "rpc error sent", { id = id, message = message, code = code or JSONRPC_INTERNAL_ERROR })
	self:_write({
		jsonrpc = "2.0",
		id = id,
		error = {
			code = code or JSONRPC_INTERNAL_ERROR,
			message = message,
		},
	})
end

function Client:_resolve_start(ok, err)
	self.ready = ok
	if ok then
		self.status = "session_ready"
	else
		self.status = "failed"
		self.last_error = err or self.last_error
	end

	local callbacks = self.start_callbacks
	self.start_callbacks = {}
	log.write(ok and "info" or "error", "startup resolved", { ok = ok, error = err, status = self.status })
	for _, cb in ipairs(callbacks) do
		cb(ok, err)
	end
end

function Client:_fail_start(message)
	self.last_error = message
	self:_resolve_start(false, message)
	if message then
		notify(message, vim.log.levels.ERROR)
	end
end

function Client:_handle_exit(obj)
	local message = obj and obj.code ~= 0 and ("codex-acp exited with code %s"):format(tostring(obj.code))
		or "codex-acp exited"
	log.write(obj and obj.code == 0 and "info" or "warn", "codex-acp process exited", {
		code = obj and obj.code,
		signal = obj and obj.signal,
	})

	self.handle = nil
	self.ready = false
	self.session_id = nil
	self.active = nil
	self.last_error = message

	for id, cb in pairs(self.pending) do
		self.pending[id] = nil
		cb(nil, { message = message })
	end

	if #self.start_callbacks > 0 then
		self:_resolve_start(false, message)
	else
		self.status = "stopped"
	end
end

function Client:start(callback)
	callback = callback or function() end
	if self.ready and self.handle then
		callback(true)
		return
	end
	if self.status == "starting" then
		table.insert(self.start_callbacks, callback)
		return
	end

	local cfg = self:_config()
	local command = cfg.command or { "codex-acp" }
	if type(command) == "string" then
		command = { command }
	end
	if not command[1] or vim.fn.executable(command[1]) ~= 1 then
		local message = command[1] and (command[1] .. " is not executable") or "codex-acp command is empty"
		log.write("error", message)
		callback(false, message)
		return
	end

	log.write("info", "starting codex-acp", { command = table.concat(command, " "), cwd = cfg.cwd or vim.fn.getcwd() })
	self.status = "starting"
	table.insert(self.start_callbacks, callback)
	self.line_buffer = ""
	self.pending = {}
	self.active = nil
	self.session_id = nil
	self.ready = false

	local ok, handle_or_err = pcall(vim.system, command, {
		stdin = true,
		cwd = cfg.cwd or vim.fn.getcwd(),
		stdout = vim.schedule_wrap(function(err, data)
			if err then
				self.last_error = redact(err)
				log.write("error", "stdout error", self.last_error)
				return
			end
			if data and data ~= "" then
				self:_on_stdout(data)
			end
		end),
		stderr = vim.schedule_wrap(function(err, data)
			if err then
				self.last_stderr = redact(err)
				log.write("warn", "stderr error", self.last_stderr)
			elseif data and data ~= "" then
				self.last_stderr = redact(data)
				log.write("debug", "stderr", self.last_stderr)
			end
		end),
	}, vim.schedule_wrap(function(obj)
		self:_handle_exit(obj)
	end))

	if not ok then
		self:_fail_start("failed to start codex-acp: " .. tostring(handle_or_err))
		return
	end

	self.handle = handle_or_err
	self:_initialize()
end

function Client:_initialize()
	local cfg = self:_config()
	self.status = "initializing"
	log.write("info", "initializing ACP")
	self:_request(METHODS.INITIALIZE, {
		protocolVersion = 1,
		clientCapabilities = {
			fs = {
				readTextFile = false,
				writeTextFile = false,
			},
		},
		clientInfo = {
			name = "minuet-codex.nvim",
			version = "0.1.0",
		},
	}, cfg.startup_timeout_ms, function(result, err)
		if err then
			self:_fail_start("initialize failed: " .. (err.message or tostring(err)))
			return
		end
		self.agent_info = result or {}
		log.write("info", "ACP initialized", {
			protocolVersion = self.agent_info.protocolVersion,
			authMethods = self.agent_info.authMethods,
		})
		self:_authenticate()
	end)
end

function Client:_authenticate()
	local cfg = self:_config()
	self.status = "authenticating"
	log.write("info", "authenticating ACP", { method = cfg.auth_method or "chatgpt" })
	self:_request(METHODS.AUTHENTICATE, { methodId = cfg.auth_method or "chatgpt" }, cfg.startup_timeout_ms, function(_, err)
		if err then
			self:_fail_start("authentication failed: " .. (err.message or tostring(err)))
			return
		end
		log.write("info", "ACP authenticated")
		self:_new_session()
	end)
end

function Client:_new_session()
	local cfg = self:_config()
	self.status = "creating_session"
	log.write("info", "creating ACP session", { cwd = cfg.cwd or vim.fn.getcwd() })
	self:_request(METHODS.SESSION_NEW, {
		cwd = cfg.cwd or vim.fn.getcwd(),
		mcpServers = cfg.mcp_servers or {},
	}, cfg.startup_timeout_ms, function(result, err)
		if err then
			self:_fail_start("session creation failed: " .. (err.message or tostring(err)))
			return
		end
		if not result or not result.sessionId then
			self:_fail_start("session creation failed: missing session id")
			return
		end
		self.session_id = result.sessionId
		self.config_options = result.configOptions or self.config_options
		log.write("info", "ACP session created", { session_id = self.session_id })
		self:_set_model(function()
			self:_resolve_start(true)
		end)
	end)
end

function Client:_set_model(done)
	local cfg = self:_config()
	if not cfg.set_model or not cfg.model or cfg.model == "" then
		done()
		return
	end

	self.status = "setting_model"
	log.write("info", "setting Codex model", { model = cfg.model })
	self:_request(METHODS.SESSION_SET_CONFIG_OPTION, {
		sessionId = self.session_id,
		configId = "model",
		value = cfg.model,
	}, cfg.startup_timeout_ms, function(result, err)
		if err then
			log.write("warn", "model selection failed", { model = cfg.model, error = err.message or err })
			notify("could not set Codex model to " .. cfg.model .. "; using Codex default", vim.log.levels.WARN)
		else
			self.config_options = result and result.configOptions or self.config_options
			log.write("info", "model selection request completed", { model = cfg.model })
		end
		done()
	end)
end

function Client:ensure_ready(callback)
	if self.ready and self.handle and self.session_id then
		callback(true)
		return
	end
	self:start(callback)
end

function Client:_on_stdout(data)
	self.line_buffer = self.line_buffer .. data
	while true do
		local newline = self.line_buffer:find("\n", 1, true)
		if not newline then
			break
		end
		local line = self.line_buffer:sub(1, newline - 1)
		self.line_buffer = self.line_buffer:sub(newline + 1)
		line = line:gsub("\r$", "")
		self:_handle_line(line)
	end
end

function Client:_handle_line(line)
	if line == "" or not line:match("^%s*{") then
		return
	end
	local message, err = decode(line)
	if not message then
		self.last_error = "invalid JSON-RPC message: " .. redact(err)
		log.write("warn", "invalid JSON-RPC message", { error = self.last_error })
		return
	end
	self:_handle_message(message)
end

function Client:_handle_message(message)
	if message.id and not message.method then
		local cb = self.pending[message.id]
		if cb then
			if message.error then
				cb(nil, message.error)
			else
				cb(message.result or empty_dict(), nil)
			end
		end
		return
	end

	if message.method == METHODS.SESSION_UPDATE then
		self:_handle_session_update(message.params or {})
	elseif message.method == METHODS.SESSION_REQUEST_PERMISSION then
		self:_send_result(message.id, { outcome = { outcome = "cancelled" } })
	elseif message.method == METHODS.FS_READ_TEXT_FILE then
		self:_send_error(message.id, "fs/read_text_file is disabled for completion", JSONRPC_INVALID_PARAMS)
	elseif message.method == METHODS.FS_WRITE_TEXT_FILE then
		self:_send_error(message.id, "fs/write_text_file is disabled for completion", JSONRPC_INVALID_PARAMS)
	end
end

function Client:_handle_session_update(params)
	local update = params.update or {}
	if update.sessionUpdate == "agent_message_chunk" then
		if self.active then
			local text = extract_text(update.content)
			if text and text ~= "" then
				table.insert(self.active.chunks, text)
				log.write("debug", "agent message chunk", { seq = self.active.seq, chars = #text })
			end
		end
	elseif update.sessionUpdate == "config_option_update" then
		self.config_options = update.configOptions or self.config_options
		log.write("info", "config options updated")
	else
		log.write("debug", "session update", { type = update.sessionUpdate })
	end
end

function Client:cancel_active()
	if not self.active or not self.session_id then
		return
	end
	log.write("info", "cancelling active completion", { seq = self.active.seq })
	self.active.cancelled = true
	self.active = nil
	self:_notify(METHODS.SESSION_CANCEL, { sessionId = self.session_id })
end

function Client:_send_completion_prompt(text, callback)
	local cfg = self:_config()
	self.request_seq = self.request_seq + 1
	local seq = self.request_seq
	self.active = {
		seq = seq,
		chunks = {},
		cancelled = false,
	}
	log.write("info", "completion request started", { seq = seq, prompt_chars = #text })

	self:_request(METHODS.SESSION_PROMPT, {
		sessionId = self.session_id,
		prompt = {
			{
				type = "text",
				text = text,
			},
		},
	}, cfg.request_timeout_ms, function(_, err)
		local active = self.active
		if not active or active.seq ~= seq then
			return
		end
		self.active = nil
		if err then
			self.last_error = err.message or tostring(err)
			log.write("warn", "completion request failed", { seq = seq, error = self.last_error })
			callback(nil, err)
			return
		end
		local raw = table.concat(active.chunks)
		log.write("info", "completion request finished", { seq = seq, chunks = #active.chunks, chars = #raw })
		callback(raw, nil)
	end)
end

function Client:complete(context, callback)
	callback = callback or function() end
	local cfg = self:_config()
	self:ensure_ready(function(ok, err)
		if not ok then
			callback({})
			if err then
				notify(err, vim.log.levels.ERROR)
			end
			return
		end

		local text = prompt.build(context, cfg)
		log.write("debug", "completion prompt built", { chars = #text })
		local function run()
			self:_send_completion_prompt(text, function(raw, request_err)
				if request_err then
					callback({})
					return
				end
				local items = parser.parse(raw, {
					separator = cfg.completion_separator,
					max_items = cfg.max_completions,
				})
				log.write("info", "completion parsed", { item_count = #items })
				callback(items)
			end)
		end

		if self.active then
			self:cancel_active()
			vim.defer_fn(run, cfg.cancel_delay_ms or 150)
		else
			run()
		end
	end)
end

function Client:stop()
	log.write("info", "stopping codex ACP client")
	self:cancel_active()
	for id, cb in pairs(self.pending) do
		self.pending[id] = nil
		cb(nil, { message = "client stopped" })
	end
	if self.handle then
		pcall(function()
			self.handle:kill(15)
		end)
	end
	self.handle = nil
	self.ready = false
	self.session_id = nil
	self.status = "stopped"
end

function Client:status_info()
	local cfg = self:_config()
	return {
		status = self.status,
		ready = self.ready,
		session_id = self.session_id,
		model = cfg.model,
		command = cfg.command,
		last_error = self.last_error,
		last_stderr = self.last_stderr,
		log_file = log.path(),
	}
end

local client

function M.get()
	if not client then
		client = Client.new()
	end
	return client
end

function M.reset()
	if client then
		client:stop()
	end
	client = Client.new()
	return client
end

return M
