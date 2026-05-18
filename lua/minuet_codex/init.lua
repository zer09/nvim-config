local config = require("minuet_codex.config")
local client_mod = require("minuet_codex.acp_client")
local health = require("minuet_codex.health")
local log = require("minuet_codex.log")

local M = {}

function M.setup(opts)
	config.setup(opts or {})
	return M
end

function M.start(callback)
	client_mod.get():start(callback)
end

function M.stop()
	client_mod.get():stop()
end

function M.restart(callback)
	client_mod.reset():start(callback)
end

function M.status()
	return client_mod.get():status_info()
end

function M.health()
	health.notify()
end

function M.complete(context, callback)
	client_mod.get():complete(context, callback)
end

function M.show_completion()
	pcall(function()
		require("lazy").load({ plugins = { "blink.cmp", "minuet-ai.nvim" } })
	end)

	local ok, blink = pcall(require, "blink.cmp")
	if not ok then
		vim.notify("[minuet-codex] blink.cmp is not available", vim.log.levels.ERROR)
		return
	end

	local function show()
		blink.show({ providers = { "minuet" } })
	end

	local mode = vim.api.nvim_get_mode().mode
	if mode:sub(1, 1) == "i" then
		show()
	else
		vim.cmd.startinsert()
		vim.schedule(show)
	end
end

function M.create_commands()
	vim.api.nvim_create_user_command("MinuetCodexStart", function()
		M.start(function(ok, err)
			if ok then
				vim.notify("[minuet-codex] codex-acp session ready", vim.log.levels.INFO)
			elseif err then
				vim.notify("[minuet-codex] " .. err, vim.log.levels.ERROR)
			end
		end)
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexStop", function()
		M.stop()
		vim.notify("[minuet-codex] codex-acp stopped", vim.log.levels.INFO)
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexRestart", function()
		M.restart(function(ok, err)
			if ok then
				vim.notify("[minuet-codex] codex-acp session ready", vim.log.levels.INFO)
			elseif err then
				vim.notify("[minuet-codex] " .. err, vim.log.levels.ERROR)
			end
		end)
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexHealth", function()
		M.health()
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexComplete", function()
		M.show_completion()
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexLog", function()
		vim.notify("[minuet-codex] log file: " .. vim.fn.fnamemodify(log.path(), ":~"), vim.log.levels.INFO)
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexLogOpen", function()
		vim.cmd.edit(vim.fn.fnameescape(log.path()))
	end, {})

	vim.api.nvim_create_user_command("MinuetCodexLogClear", function()
		log.clear()
		vim.notify("[minuet-codex] log cleared: " .. vim.fn.fnamemodify(log.path(), ":~"), vim.log.levels.INFO)
	end, {})
end

return M
