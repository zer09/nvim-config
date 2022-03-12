local root_pattern = require("lspconfig.util").root_pattern
local lsp_installer = require("nvim-lsp-installer")

local servers = {
	angularls = {
		root_dir = root_pattern("angular.json"),
	},
	bashls = {},
	cssls = {},
	cssmodules_ls = {},
	eslint = {},
	html = {},
	-- sqlls = {},
	sqls = {
		cmd = { "sqls", "--config", vim.loop.cwd() .. "/sqls.yml" },
	},
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

local aerial = require("aerial")
local on_attach = require("mappings").lsp_on_attach
lsp_installer.on_server_ready(function(server)
	local config = servers[server.name] or {}
	config.capabilities = capabilities
	config.on_attach = function(client, bufnr)
		-- Disabled lsp formatting
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false

		on_attach(bufnr)
		aerial.on_attach(client, bufnr)
	end
	server:setup(config)
end)

-- Show diagnostics on floating window
local colaug = vim.api.nvim_create_augroup("colaug", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
	group = colaug,
	command = "highlight FloatBorder guifg=grey",
})

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.diagnostic.config({
	virtual_text = false,
})

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 500
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
