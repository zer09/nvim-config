local helper = require("helper")
local nmap = helper.nmap
local nnoremap = helper.nnoremap
local inoremap = helper.inoremap
local vnoremap = helper.vnoremap

vim.g.mapleader = " "

local M = {}

function M.standard()
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

	-- on search dont lose the cursor
	nnoremap("n", "nzzzv")
	nnoremap("N", "Nzzzv")

	-- dont lose cursor on join lines
	nnoremap("J", "mzJ`z")

	-- visual move
	vnoremap("J", ":m '>+1<CR>gv=gv")
	vnoremap("K", ":m '<-2<CR>gv=gv")

	-- break undo sequence on every symbols
	local str = [[!@#$%^&*()+_-=}{[]|:;"/?.><,`~ ]]
	for i = 1, #str do
		local s = str:sub(i, i)
		inoremap(s, string.format("%s<C-g>u", s))
	end

	-- big jumps C-o C-i exact target
	vim.cmd([[
	nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
	nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
	]])
end

function M.telescope()
	-- Telescope mappings
	nnoremap("<Leader>tp", ":Telescope fd<CR>")
	nnoremap("<Leader>tt", ":Telescope file_browser<CR>")
	nnoremap("<Leader>bb", ":Telescope buffers<CR>")
	nnoremap("<Leader>ts", ":Telescope live_grep<CR>")
	nnoremap("<Leader>th", ":Telescope help_tags<CR>")
	nnoremap("<Leader>tm", ":Telescope keymaps<CR>")
end

function M.neogit()
	-- neogit mappings
	nnoremap("<Leader>gg", ":Neogit<CR>")
end

function M.choosewin()
	-- Keymap to activate the choosewin.
	nmap("-", "<Plug>(choosewin)")
end

function M.theme()
	nnoremap("<Leader>t1", "<cmd>lua vim.cmd('colorscheme base16-solarized-dark')<CR>")
	nnoremap("<Leader>t2", "<cmd>lua vim.cmd('colorscheme base16-monokai')<CR>")
	nnoremap("<Leader>t3", "<cmd>lua vim.cmd('colorscheme base16-tomorrow')<CR>")
end

-- will be used for lsp lsp_on_attach
function M.lsp_on_attach(bufnr)
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

M.telescope_edfault_mappings = {
	i = {
		["<esc>"] = require("telescope.actions").close,
		["<C-u>"] = false,
	},
}

return M
