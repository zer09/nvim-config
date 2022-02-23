local helper = require("helper")
local map = helper.map

vim.g.mapleader = " "

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
map("n", "<Leader>wh", ":split<CR>")

-- Close the windown but keep the buffer
map("n", "<Leader>wd", "<C-w>c")
map("n", "<Leader>bd", ":b#<Bar>bd#<CR>")

-- terminal
map("n", "<Leader>tw", ":tabnew terminal<Bar>:term<CR>")

-- Files
map("n", "<Leader>fs", ":w<CR>")
map("n", "<Leader>fS", ":wa<CR>")
-- copy file name
map("n", "<Leader>fy", ":let @+ = expand('%:p')<CR>", { silent = true })
-- show pwd
map("n", "<Leader>fyy", ":echo expand('%:p:h')<CR>", { silent = true })
