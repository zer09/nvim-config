local minuet_dir = vim.fn.expand("~/development/minuet-ai.nvim")
local codex_acp_manifest = vim.fn.expand("~/development/codex-acp/Cargo.toml")

local function codex_acp_command()
	if vim.fn.executable("codex-acp") == 1 then
		return { "codex-acp" }, 20000
	end

	if vim.uv.fs_stat(codex_acp_manifest) and vim.fn.executable("cargo") == 1 then
		return { "cargo", "run", "--quiet", "--manifest-path", codex_acp_manifest, "--" }, 120000
	end

	return { "codex-acp" }, 20000
end

local spec = {
	"milanglacier/minuet-ai.nvim",
	event = "InsertEnter",
	config = function()
		local command, startup_timeout_ms = codex_acp_command()

		require("minuet_codex").setup({
			command = command,
			auth_method = "chatgpt",
			model = "gpt-5.3-codex-spark",
			request_timeout_ms = 12000,
			startup_timeout_ms = startup_timeout_ms,
			completion_separator = "<endCompletion>",
			max_completions = 3,
		})

		require("minuet").setup({
			provider = "codex_acp",
			provider_options = {
				codex_acp = {
					name = "Codex Spark",
				},
			},
			blink = {
				enable_auto_complete = false,
			},
			throttle = 3000,
			debounce = 800,
			request_timeout = 12,
			n_completions = 3,
			notify = "warn",
		})
	end,
}

if vim.uv.fs_stat(minuet_dir) then
	spec.dir = minuet_dir
end

return { spec }
