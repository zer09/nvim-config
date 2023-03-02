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
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"angularls",
					"bashls",
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
			})
		end,
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
							json = require("schemastore").json.schemas(),
						},
					})
				end,
				["lua_ls"] = function(_)
					lspconfig.lua_ls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
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
}
