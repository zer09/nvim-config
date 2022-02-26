local set = vim.opt

set.relativenumber = true
set.numberwidth = 3
set.mouse = "a"
set.cursorline = true
set.showmode = false
set.timeoutlen = 300
set.clipboard:prepend({ "unnamed", "unnamedplus" })
set.virtualedit = "block"
set.ignorecase = true
set.smartcase = true
set.updatetime = 250
set.completeopt = "menuone,noselect"
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.smartindent = true
set.wrap = false

-- Keep 7 lines visible above and below cursor when scrolling
set.scrolloff = 7

-- Prevent add new comment when creating new line
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
