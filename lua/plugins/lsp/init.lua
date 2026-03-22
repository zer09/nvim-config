-- https://github.com/sergiornelas/nvim
-- for debugging
-- https://github.com/StevanFreeborn/nvim-config/blob/63bf20565b67d3a6c31839edf1ad2453ecd3bf84/lua/plugins/debugging.lua
local nnoremap = require("helper").nnoremap
-- local navbuddyexclude = { tailwindcss = true, eslint = true, angularls = true, ruff = true, djls = true }

-- local on_attach = function(client, bufnr)
-- 	client.server_capabilities.document_formatting = false
-- 	client.server_capabilities.document_range_formatting = false
--
-- 	local opts = { buffer = bufnr }
--
-- 	nnoremap("gp", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
-- 	nnoremap("gn", "<CMD>lua vim.diagnostic.goto_next()<CR>")
-- 	nnoremap("gd", "<CMD>lua vim.lsp.buf.definition()<CR>", opts)
-- 	nnoremap("gi", "<CMD>lua vim.lsp.buf.implementation()<CR>", opts)
--
-- 	-- this will override the onlist for find references
-- 	-- vim.keymap.set("n", "gr", function()
-- 	-- 	vim.lsp.buf.references(nil, { on_list = on_list })
-- 	-- end, { noremap = true })
--
-- 	nnoremap("<Leader>wl", "<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
--
-- 	if vim.fn.findfile("angular.json", ".;") ~= "" then
-- 		nnoremap("<Leader>rn", "<CMD>lua vim.lsp.buf.rename(nil, { name = 'angularls' })<CR>", opts)
-- 	else
-- 		nnoremap("<Leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>", opts)
-- 	end
--
-- 	nnoremap("<Leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>", opts)
--
-- 	-- disable diagnostic on current buffer
-- 	nnoremap("gq", "<CMD>lua vim.diagnostic.disable(0)<CR>", opts)
--
-- 	if navbuddyexclude[client.config.name] == nil then
-- 		local navBuddy = require("nvim-navbuddy")
-- 		navBuddy.attach(client, bufnr)
-- 	end
--
-- 	if client.config.name == "typescript-tools" then
-- 		nnoremap("gld", "<CMD>TSToolsGoToSourceDefinition<CR>", opts)
-- 		nnoremap("glf", "<CMD>TSToolsFixAll<CR>", opts)
-- 		nnoremap("gli", "<CMD>TSToolsAddMissingImports<CR>", opts)
-- 		nnoremap("glo", "<CMD>TSToolsOrganizeImports<CR>", opts)
-- 	end
--
-- 	-- Disable hover in favor of Pyright
-- 	if client.config.name == "ruff" then
-- 		client.server_capabilities.hoverProvider = false
-- 	end
-- end

-- vim.lsp.config("*", {
-- 	on_attach = on_attach,
-- })

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
-- require("plugins.lsp.find_reference")

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
				dependencies = {
					-- {
					-- 	"SmiteshP/nvim-navbuddy",
					-- 	dependencies = {
					-- 		"SmiteshP/nvim-navic",
					-- 		"MunifTanjim/nui.nvim",
					-- 		"numToStr/Comment.nvim",
					-- 		"nvim-telescope/telescope.nvim",
					-- 	},
					-- 	config = function()
					-- 		-- require("helper").nnoremap("<Leader>oo", "<CMD>Navbuddy<CR>")
					-- 	end,
					-- },
					{
						"b0o/SchemaStore.nvim",
						version = false,
						lazy = true,
						config = function()
							vim.lsp.jsonls = {}
						end,
					},
				},
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
			nnoremap("<Leader>tf", "<CMD>Telescope flutter commands<CR>")
		end,
	},
}
