vim.loader.enable()

local set = vim.opt

set.syntax = "on"
set.relativenumber = true
set.numberwidth = 3
set.mouse = "a"
set.cursorline = true
set.showmode = false
set.timeoutlen = 300
set.clipboard:prepend({ "unnamedplus" })
set.virtualedit = "block"
set.ignorecase = true
set.smartcase = true
-- set.updatetime = 250 -- the number of milliseconds vim to wait before writing it to swap file
set.completeopt = "menu,menuone,noselect"
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

-- already using the default python3.11
-- vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- if vim.fn.has("wsl") == 1 then
-- 	-- https://stackoverflow.com/a/76388417/3387602
-- 	vim.g.clipboard = {
-- 		name = "win32yank-wsl",
-- 		copy = {
-- 			["+"] = "win32yank.exe -i --crlf",
-- 			["*"] = "win32yank.exe -i --crlf",
-- 		},
-- 		paste = {
-- 			["+"] = "win32yank.exe -o --lf",
-- 			["*"] = "win32yank.exe -o --lf",
-- 		},
-- 		cache_enabled = true,
-- 	}
-- end

if vim.fn.has("wsl") == 1 then
	if vim.fn.executable("wl-copy") == 0 then
		print("wl-clipboard not found, clipboard integration won't work")
	else
		vim.g.clipboard = {
			name = "wl-clipboard (wsl)",
			copy = {
				["+"] = "wl-copy --foreground --type text/plain",
				["*"] = "wl-copy --foreground --primary --type text/plain",
			},
			paste = {
				["+"] = function()
					return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { "" }, 1) -- '1' keeps empty lines
				end,
				["*"] = function()
					return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { "" }, 1)
				end,
			},
			cache_enabled = true,
		}
	end
end
