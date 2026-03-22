-- https://github.com/sergiornelas/nvim
-- for debugging
-- https://github.com/StevanFreeborn/nvim-config/blob/63bf20565b67d3a6c31839edf1ad2453ecd3bf84/lua/plugins/debugging.lua

-- https://github.com/vuejs/language-tools/wiki/Neovim
-- https://github.com/microsoft/TypeScript/wiki/Writing-a-Language-Service-Plugin
-- https://github.com/vuejs/language-tools/discussions/5931
-- https://www.reddit.com/r/neovim/comments/1kwjip4/how_to_properly_set_up_vue_3_typescript_in_neovim/
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local styled_plugin_path = vim.fn.system("npm root -g"):gsub("\n", "") .. "/@styled/typescript-styled-plugin"

vim.lsp.config.ts_ls = {
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			},
			{
				name = "@styled/typescript-styled-plugin",
				location = styled_plugin_path,
				languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
			},
		},
		hostInfo = "neovim",
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

require("plugins.lsp.handlers")

return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		dependencies = {
			"Bilal2453/luvit-meta",
			"DrKJeff16/wezterm-types",
		},
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- Only load the lazyvim library when the `LazyVim` global is found
				{ path = "LazyVim", words = { "LazyVim" } },
				-- Load the wezterm types when the `wezterm` module is required
				-- Needs `DrKJeff16/wezterm-types` to be installed
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
			enabled = function(root_dir)
				return not vim.uv.fs_stat(root_dir .. "/.init.lua")
			end,
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"angularls",
				"basedpyright",
				"bashls",
				"cssls",
				"djls",
				"djlsp",
				"eslint",
				"gopls",
				"html",
				"jsonls",
				"lua_ls",
				"pbls",
				"ruff",
				"rust_analyzer",
				"svelte",
				"tailwindcss",
				"ts_ls",
				"vue_ls",
				"yamlls",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			{
				"neovim/nvim-lspconfig",
				pin = true,
			},
			{
				"b0o/SchemaStore.nvim",
				version = false,
				lazy = true,
			},
		},
	},
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("flutter-tools").setup({
				dev_log = {
					notify_errors = true, -- if there is an error whilst running then notify the user
					open_cmd = "tabedit", -- command to use to open the log buffer
				},
				widget_guides = {
					enabled = true,
				},
				lsp = {
					color = { -- show the derived colours for dart variables
						enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
						background = true, -- highlight the background
					},
				},
			})

			require("telescope").load_extension("flutter")
			require("helper").nnoremap("<Leader>tf", "<CMD>Telescope flutter commands<CR>")
		end,
	},
}
