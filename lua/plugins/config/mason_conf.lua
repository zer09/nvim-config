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
})

mason_lsp_config.setup_handlers({})

require("mason-null-ls").setup({
	automatic_setup = true,
})
