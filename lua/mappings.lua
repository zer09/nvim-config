local helper = require("helper")
local map = helper.map
local bmap = helper.bmap

vim.g.mapleader = " "

local M = {}

M.activateMappings = function()
	-- escape sequence
	map("i", ",.", "<Esc>")

	-- Disabled mappings
	map("n", "<Space>", "<NOP>")
	map("n", "q", "<NOP>")
	map("n", "q:", "<NOP>")
	map("n", "Q", "<NOP>")

	-- clear search highlight
	map("n", "<Leader>sc", ":noh<CR>")

	-- Windows and Buffers
	map("n", "<Leader>wv", ":vsplit<CR>")
	map("n", "<Leader>ws", ":split<CR>")

	-- Close the windown but keep the buffer
	map("n", "<Leader>wd", "<C-w>c")
	map("n", "<Leader>bd", ":b#<Bar>bd#<CR>")

	-- terminal
	map("n", "<Leader>tw", ":tabnew terminal<Bar>:term<CR>")

	-- Files
	map("n", "<Leader>fs", ":w<CR>")
	map("n", "<Leader>fS", ":wa<CR>")
	-- copy file name
	map("n", "<Leader>fy", ":let @+ = expand('%:p')<CR>")
	-- show pwd
	map("n", "<Leader>fyy", ":echo expand('%:p:h')<CR>")

	-- Move forward on insert mode
	map("i", "<C-f>", "<Right>")
end

M.activatePluginMappigs = function()
	-- Telescope mappings
	map("n", "<Leader>tp", ":Telescope fd<CR>")
	map("n", "<Leader>tt", ":Telescope file_browser<CR>")
	map("n", "<Leader>bb", ":Telescope buffers<CR>")
	map("n", "<Leader>fg", ":Telescope live_grep<CR>")
	map("n", "<Leader>fh", ":Telescope help_tags<CR>")
	map("n", "<Leader>fm", ":Telescope keymaps<CR>")

	-- neogit mappings
	map("n", "<Leader>gg", ":Neogit<CR>")
end

-- will be used for lsp lsp_on_attach
M.lsp_on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- bmap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
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

-- treesitter textobjects keymaps
M.treesitter = {
	textobjects = {
		select = {
			-- You can use the capture groups defined in textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
		lsp_interop = {
			peek_definition_code = {
				["gD"] = "@function.outer",
			},
		},
	},
	textsubjects = {
		["."] = "textsubjects-smart",
		[";"] = "textsubjects-container-outer",
		["i;"] = "textsubjects-container-inner",
	},
	pairs = {
		goto_partner = "%",
	},
}

return M
