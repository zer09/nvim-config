local helper = require("helper")
local nmap = helper.nmap
local nnoremap = helper.nnoremap
local inoremap = helper.inoremap

vim.g.mapleader = " "

local M = {}

M.standard = function()
	-- escape sequence
	inoremap(",.", "<Esc>")

	-- Disabled mappings
	nnoremap("<Space>", "<NOP>")
	nnoremap("q", "<NOP>")
	nnoremap("q:", "<NOP>")
	nnoremap("Q", "<NOP>")
	nnoremap("Qa", ":qa")
	nnoremap("QA", ":qa")

	-- clear search highlight
	nnoremap("<Leader>sc", ":noh<CR>")

	-- Windows and Buffers
	nnoremap("<Leader>wv", ":vsplit<CR>")
	nnoremap("<Leader>ws", ":split<CR>")

	-- Close the windown but keep the buffer
	nnoremap("<Leader>wd", "<C-w>c")
	nnoremap("<Leader>bd", ":b#<Bar>bd#<CR>")

	-- terminal
	nnoremap("<Leader>tw", ":tabnew terminal<Bar>:term<CR>")

	-- Files
	nnoremap("<Leader>fs", ":w<CR>")
	nnoremap("<Leader>fS", ":wa<CR>")
	-- copy file name
	nnoremap("<Leader>fy", ":let @+ = expand('%:p')<CR>")
	-- show pwd
	nnoremap("<Leader>fyy", ":echo expand('%:p:h')<CR>")

	-- Move forward on insert mode
	inoremap("<C-f>", "<Right>")
end

M.telescope = function()
	-- Telescope mappings
	nnoremap("<Leader>tp", ":Telescope fd<CR>")
	nnoremap("<Leader>tt", ":Telescope file_browser<CR>")
	nnoremap("<Leader>bb", ":Telescope buffers<CR>")
	nnoremap("<Leader>fg", ":Telescope live_grep<CR>")
	nnoremap("<Leader>fh", ":Telescope help_tags<CR>")
	nnoremap("<Leader>fm", ":Telescope keymaps<CR>")
end

M.neogit = function()
	-- neogit mappings
	nnoremap("<Leader>gg", ":Neogit<CR>")
end

M.choosewin = function()
	-- Keymap to activate the choosewin.
	nmap("-", "<Plug>(choosewin)")
end

-- will be used for lsp lsp_on_attach
M.lsp_on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { buffer = bufnr }

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- bnnoremap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	nnoremap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	nnoremap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	nnoremap("<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	nnoremap("<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	nnoremap("<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	nnoremap("<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	nnoremap("<Leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	nnoremap("<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	nnoremap("<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	nnoremap("gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	nnoremap("<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
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

local telescope_actions = require("telescope.actions")
M.telescope_edfault_mappings = {
	i = {
		["<esc>"] = telescope_actions.close,
		["<C-u>"] = false,
	},
}

return M
