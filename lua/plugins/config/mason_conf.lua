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

local lsp_on_attach_mappings = require("mappings").lsp_on_attach
local on_attach = function(client, bufnr)
	-- Disabled lsp formatting
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false

	lsp_on_attach_mappings(bufnr)
end

-- local angularlsReady = false
mason_lsp_config.setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
			end,
			-- on_attach = function(client, bufnr)
			-- 	on_attach(client, bufnr)
			-- end,
			-- on_attach = function(client, bufnr)
			-- 	-- Disabled lsp formatting
			-- 	client.server_capabilities.document_formatting = false
			-- 	client.server_capabilities.document_range_formatting = false
			--
			-- 	lsp_on_attach_mappings(bufnr)
			--
			-- 	-- if server_name == "angularls" then
			-- 	-- 	angularlsReady = true
			-- 	-- end
			-- 	--
			-- 	-- if server_name == "tsserver" then
			-- 	-- 	if angularlsReady then
			-- 	-- 		client.server_capabilities.renameProvider = false
			-- 	-- 	end
			-- 	-- end
			-- 	--
			-- 	-- on_attach(client, bufnr)
			-- end,
		})
	end,
	["jsonls"] = function()
		lspconfig.jsonls.setup({
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
			end,
			settings = {
				json = require("schemastore").json.schemas(),
			},
		})
	end,
	["sumneko_lua"] = function()
		lspconfig.sumneko_lua.setup({
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
			end,
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
