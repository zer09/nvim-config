local helper = require("helper")
local nnoremap = helper.nnoremap
local inoremap = helper.inoremap
local vnoremap = helper.vnoremap

-- escape sequence
inoremap(",.", "<Esc>")

-- Disabled mappings
nnoremap("<Space>", "<NOP>")
nnoremap("q", "<NOP>")
nnoremap("q:", "<NOP>")
nnoremap("Q", "q")
nnoremap("Qa", "<CMD>qa<CR>")
nnoremap("QA", "<CMD>qa<CR>")
nnoremap("<Leader>qq", "<CMD>qa<CR>")
nnoremap("<Leader>cc", "<CMD>cclose<CR>")
nnoremap("<C-c><C-c>", "<CMD>cclose<CR>")

--replace without yank
-- xnoremap("p", "pgvy")
-- nnoremap P "0p
-- vnoremap P "0p
-- xnoremap("p", [[pgv"@=v:register.'y'<CR>]])
-- vnoremap("p", [[pgv"@=v:register.'y'<CR>]])
-- nnoremap("p", [[pgv"@=v:register.'y'<CR>]])
nnoremap("P", [["0p]])
vnoremap("P", [["0p]])

-- clear search highlight
nnoremap("<Leader>sc", "<CMD>noh<CR>")

-- Windows and Buffers
nnoremap("<Leader>wv", "<CMD>vsplit<CR>")
nnoremap("<Leader>ws", "<CMD>split<CR>")
nnoremap("<Leader>bt", "<CMD>bprevious<CR>")
nnoremap("<Leader>bn", "<CMD>bnext<CR>")

-- tabs
nnoremap("<Leader>tfi", "<CMD>tabfirst<CR>")
nnoremap("<Leader>tla", "<CMD>tablast<CR>")
nnoremap("<Leader>tre", "<CMD>tabprevious<CR>")
nnoremap("<Leader>tnn", "<CMD>tabnext<CR>")
nnoremap("<Leader>tne", "<CMD>tabnew<CR>")

-- Close the windown but keep the buffer
nnoremap("<Leader>wd", "<C-w>c")
nnoremap("<Leader>bd", "<CMD>b#<Bar>bd#<CR>")

-- terminal
nnoremap("<Leader>tw", "<CMD>tabnew terminal<Bar>:term<CR>")

-- Files
nnoremap("<Leader>fs", "<CMD>w<CR>")
nnoremap("<Leader>fS", "<CMD>wa<CR>")
-- copy file name
nnoremap("<Leader>fy", "<CMD>let @+ = expand('%:p')<CR>")
-- show pwd
nnoremap("<Leader>fyy", "<CMD>echo expand('%:p:h')<CR>")

-- Move forward on insert mode
inoremap("<C-f>", "<Right>")

-- on search dont lose the cursor
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")

-- dont lose cursor on join lines
nnoremap("J", "mzJ`z")

-- visual move
vnoremap("J", "<CMD>m '>+1<CR>gv=gv")
vnoremap("K", "<CMD>m '<-2<CR>gv=gv")

-- break undo sequence on every symbols
local str = [[!@#$%^&*()+_-=}{[]|:;"/?.><,`~ ]]
for i = 1, #str do
	local s = str:sub(i, i)
	inoremap(s, string.format("%s<C-g>u", s))
end
-- big jumps C-o C-i exact target
vim.cmd([[
	nnoremap <expr> k (v:count > 1 ? "m'" . v:count : "") . 'k'
	nnoremap <expr> j (v:count > 1 ? "m'" . v:count : "") . 'j'
	]])
