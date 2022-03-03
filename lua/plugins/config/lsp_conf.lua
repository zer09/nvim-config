local lsp_installer = require("nvim-lsp-installer")
local servers = {
	angularls = {},
	bashls = {},
	cssls = {},
	cssmodules_ls = {},
	eslint = {},
	html = {},
	sqls = {},
	tsserver = {},
	yamlls = {},
	sumneko_lua = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "use", "require" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
			},
		},
	},
}

for name, _ in pairs(servers) do
	local server_is_found, server = lsp_installer.get_server(name)
	if server_is_found and not server:is_installed() then
		server:install()
	end
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local on_attach = require("mappings").lsp_on_attach
lsp_installer.on_server_ready(function(server)
	local config = servers[server.name] or {}
	config.capabilities = capabilities
	config.on_attach = function(client, bufnr)
		-- Disabled lsp formatting
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false

		on_attach(bufnr)
	end
	server:setup(config)
end)
