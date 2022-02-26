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
set.completeopt = "menu,menuone,noselect"
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.smartindent = true
set.wrap = false

-- Keep 7 lines visible above and below cursor when scrolling
set.scrolloff = 7

-- Prevent add new comment when creating new line
-- vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
set.formatoptions = set.formatoptions + {
	c = false,
	o = false,
	r = false,
}

-- Set statusbar
-- require("lualine").setup({
-- 	options = {
-- 		theme = "powerline",
-- 		component_separators = "|",
-- 		section_separators = "",
-- 	},
-- 	sections = {
-- 		lualine_a = {
-- 			{
-- 				"mode",
-- 				fmt = function(mode)
-- 					return table.concat(vim.tbl_map(function(word)
-- 						return word:sub(1, 1)
-- 					end, vim.split(mode, "-")))
-- 				end,
-- 			},
-- 		},
-- 	},
-- })
