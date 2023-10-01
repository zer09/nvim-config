vim.diagnostic.config({
	virtual_text = false,
})

return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = {
			{
				"<Leader>cm",
				"<cmd>Mason<cr>",
				desc = "Mason",
			},
		},
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
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"angularls",
				"bashls",
				"bufls",
				"cssls",
				"eslint",
				"gopls",
				"html",
				"jsonls",
				"lua_ls",
				"rust_analyzer",
				"svelte",
				"tailwindcss",
				"tsserver",
				"yamlls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lsp_config = require("mason-lspconfig")

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local on_attach = function(client, bufnr)
				-- Disabled lsp formatting
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false

				require("mappings").lsp_on_attach(bufnr)
			end

			mason_lsp_config.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["jsonls"] = function(_)
					lspconfig.jsonls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						on_init = function(client)
							local path = client.workspace_folders[1].name
							if
								not vim.loop.fs_stat(path .. "/.luarc.json")
								and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
							then
								client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
									Lua = {
										runtime = {
											-- Tell the language server which version of Lua you're using
											-- (most likely LuaJIT in the case of Neovim)
											version = "LuaJIT",
										},
										-- Make the server aware of Neovim runtime files
										workspace = {
											checkThirdParty = false,
											library = {
												vim.env.VIMRUNTIME,
												-- "${3rd}/luv/library"
												-- "${3rd}/busted/library",
											},
											-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
											-- library = vim.api.nvim_get_runtime_file("", true)
										},
									},
								})

								client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
							end

							return true
						end,
					})
				end,
				["tsserver"] = function(_)
					require("typescript").setup({
						server = {
							on_attach = function(client, bufnr)
								on_attach(client, bufnr)

								if vim.fn.findfile("angular.json", ".;") ~= "" then
									client.server_capabilities.renameProvider = false
								end

								require("mappings").typescript(bufnr)
							end,
							capabilities = capabilities,
						},
					})
				end,
			})
		end,
	},
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local on_attach = function(client, bufnr)
				-- Disabled lsp formatting
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false

				require("mappings").lsp_on_attach(bufnr)
			end

			require("flutter-tools").setup({
				lsp = {
					on_attach = on_attach,
					capabilities = capabilities,
				},
			})
		end,
	},
}
