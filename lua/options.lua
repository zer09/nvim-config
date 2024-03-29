local set = vim.opt

set.syntax = "on"
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
set.splitbelow = true
set.splitright = true
set.inccommand = "split"
set.scrolloff = 7
set.signcolumn = "yes"
set.colorcolumn = "80"
set.title = true
set.list = true
set.pumheight = 10

vim.g.python3_host_prog = "/usr/bin/python3"
