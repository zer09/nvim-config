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

mason_lsp_config.setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({})
	end,
	["jsonls"] = function()
		lspconfig.jsonls.setup({
			settings = {
				json = require("schemastore").json.schemas(),
			},
		})
	end,
	["sumneko_lua"] = function()
		lspconfig.sumneko_lua.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
	end,
})
