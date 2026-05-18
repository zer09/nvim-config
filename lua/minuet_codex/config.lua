local M = {}

local function default_command()
	if vim.fn.executable("codex-acp") == 1 then
		return { "codex-acp" }, 20000
	end

	local manifest = vim.fn.expand("~/development/codex-acp/Cargo.toml")
	if vim.uv.fs_stat(manifest) and vim.fn.executable("cargo") == 1 then
		return { "cargo", "run", "--quiet", "--manifest-path", manifest, "--" }, 120000
	end

	return { "codex-acp" }, 20000
end

local command, startup_timeout_ms = default_command()

local defaults = {
	command = command,
	auth_method = "chatgpt",
	model = "gpt-5.3-codex-spark",
	set_model = true,
	cwd = nil,
	mcp_servers = {},
	startup_timeout_ms = startup_timeout_ms,
	request_timeout_ms = 12000,
	cancel_delay_ms = 150,
	completion_separator = "<endCompletion>",
	max_completions = 3,
	debug = false,
	log_enabled = true,
	log_level = "info",
	log_file = vim.fs.joinpath(vim.fn.stdpath("state"), "minuet-codex.log"),
}

local config = vim.deepcopy(defaults)

function M.setup(opts)
	config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
	if type(config.command) == "string" then
		config.command = { config.command }
	end
	if type(config.mcp_servers) ~= "table" then
		config.mcp_servers = {}
	end
	return config
end

function M.get()
	return config
end

function M.defaults()
	return vim.deepcopy(defaults)
end

return M
