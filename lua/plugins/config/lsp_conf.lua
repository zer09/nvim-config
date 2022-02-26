local helper = require("helper")
local map = helper.map
local bmap = helper.bmap

map("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")

local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	bmap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	bmap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	bmap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	bmap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	bmap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	bmap(bufnr, "n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	bmap(bufnr, "n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	bmap(bufnr, "n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
	bmap(bufnr, "n", "<Leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	bmap(bufnr, "n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
	bmap(bufnr, "n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	bmap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	bmap(bufnr, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
end

local lsp_installer = require("nvim-lsp-installer")
local servers = {
	sumneko_lua = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "use", "require" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
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

lsp_installer.on_server_ready(function(server)
	local config = servers[server.name] or {}
	config.capabilities = capabilities
	config.on_attach = on_attach
	server:setup(config)
end)
