require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local mason_lsp_config = require("mason-lspconfig")
local lspconfig = require("lspconfig")

vim.diagnostic.config({
	virtual_text = false,
})

mason_lsp_config.setup({
	ensure_installed = {
		"angularls",
		"bashls",
		"cssls",
		"eslint",
		"html",
		"jsonls",
		"rust_analyzer",
		"sumneko_lua",
		"svelte",
		"tailwindcss",
		"tsserver",
		"yamlls",
	},
	automatic_installation = true,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
	["sumneko_lua"] = function(_)
		lspconfig.sumneko_lua.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
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
					print(vim.fn.findfile("angular.json", ".;"))
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
