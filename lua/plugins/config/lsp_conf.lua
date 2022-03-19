local root_pattern = require("lspconfig.util").root_pattern
local lsp_installer = require("nvim-lsp-installer")

vim.diagnostic.config({
	virtual_text = false,
})

local servers = {
	angularls = {
		root_dir = root_pattern("angular.json"),
	},
	bashls = {},
	cssls = {},
	-- cssmodules_ls = {},
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

local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if result[1].uri ~= ctx.params.textDocument.uri and #vim.api.nvim_list_wins() < 3 then
			vim.cmd(split_cmd)
		end

		util.jump_to_location(result[1], "utf-8")

		if #result > 1 then
			util.set_qflist(util.locations_to_items(result))
			api.nvim_command("copen")
			api.nvim_command("wincmd p")
		end
	end

	return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
