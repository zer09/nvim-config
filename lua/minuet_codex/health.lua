local config = require("minuet_codex.config")
local client_mod = require("minuet_codex.acp_client")

local M = {}

local function shorten_path(text)
	return tostring(text or ""):gsub(vim.pesc(vim.fn.expand("~")), "~")
end

function M.is_available()
	local cfg = config.get()
	local command = cfg.command
	if type(command) == "string" then
		command = { command }
	end
	return command and command[1] and vim.fn.executable(command[1]) == 1
end

function M.lines()
	local cfg = config.get()
	local command = cfg.command
	if type(command) == "string" then
		command = { command }
	end
	local info = client_mod.get():status_info()
	local lines = {
		"Minuet Codex status:",
		("- codex-acp command: %s"):format(shorten_path(table.concat(command or {}, " "))),
		("- command executable: %s"):format(M.is_available() and "yes" or "no"),
		("- auth method: %s"):format(cfg.auth_method),
		("- requested model: %s"):format(cfg.model or "Codex default"),
		("- client status: %s"):format(info.status),
		("- session ready: %s"):format(info.ready and "yes" or "no"),
		("- log file: %s"):format(shorten_path(info.log_file)),
	}
	if info.last_error then
		table.insert(lines, "- last error: " .. info.last_error)
	end
	if info.last_stderr then
		table.insert(lines, "- last stderr: " .. info.last_stderr)
	end
	return lines
end

function M.notify()
	local level = M.is_available() and vim.log.levels.INFO or vim.log.levels.WARN
	vim.notify(table.concat(M.lines(), "\n"), level)
end

function M.check()
	local h = vim.health
	h.start("minuet_codex")

	if M.is_available() then
		h.ok("codex-acp command is executable")
	else
		h.error("codex-acp command is not executable")
	end

	local ok = pcall(require, "minuet")
	if ok then
		h.ok("minuet-ai.nvim is available")
	else
		h.warn("minuet-ai.nvim is not loaded yet")
	end

	local cfg = config.get()
	local info = client_mod.get():status_info()
	h.info("auth method: " .. tostring(cfg.auth_method))
	h.info("requested model: " .. tostring(cfg.model or "Codex default"))
	h.info("client status: " .. tostring(info.status))
	h.info("log file: " .. tostring(info.log_file))
	if info.last_error then
		h.warn("last error: " .. tostring(info.last_error))
	end
	if info.last_stderr then
		h.warn("last stderr: " .. tostring(info.last_stderr))
	end
end

return M
