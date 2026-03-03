return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>ff",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			css = { "prettierd" },
			dart = { "dart_format" },
			go = { "goimports-reviser", prepend_args = { "-rm-unused", "-set-alias" } },
			html = { "prettierd" },
			javascript = { "prettierd" },
			json = { "prettierd" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			proto = { "clang-format" },
			python = {
				-- To fix auto-fixable lint errors.
				"ruff_fix",
				-- To run the Ruff formatter.
				"ruff_format",
				-- To organize the imports.
				"ruff_organize_imports",
			},
			rust = { "rustfmt" },
			scss = { "prettierd" },
			sh = { "shfmt" },
			svelte = { "prettierd" },
			typescript = { "prettierd" },
			vue = { "prettierd" },
			yaml = { "prettierd" },
			["*"] = { "trim_whitespace" },
			["_"] = { "trim_whitespace" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			dart_format = {
				args = { "format", "$FILENAME" },
				stdin = false,
			},
			shfmt = {
				append_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
