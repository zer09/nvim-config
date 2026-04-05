local comaug = vim.api.nvim_create_augroup("comaug", { clear = true })

-- Prevent add new comment when creating new line
vim.api.nvim_create_autocmd("FileType", {
	group = comaug,
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = comaug,
	-- callback = vim.highlight.on_yank,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- remove the cursorline if the buffer is not in focus
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	group = comaug,
	callback = function()
		vim.opt.cursorline = true
	end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	group = comaug,
	callback = function()
		vim.opt.cursorline = false
	end,
})

-- TurnOffCaps on InsertLeave
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	group = comaug,
-- 	callback = function()
-- 		local _, _, caps_state = vim.fn.system("xset -q"):find("00: Caps Lock:%s+(%a+)")
-- 		if caps_state == "on" then
-- 			vim.fn.system("xdotool key Caps_Lock")
-- 		end
-- 	end,
-- })

vim.api.nvim_create_autocmd("VimEnter", {
	group = comaug,
	command = ":clearjumps",
})

vim.api.nvim_create_autocmd("TabEnter", {
	group = comaug,
	command = "checktime",
})

local keyaug = vim.api.nvim_create_augroup("keyaug", { clear = true })

-- use q to close quickfix/help window
vim.api.nvim_create_autocmd("FileType", {
	group = keyaug,
	pattern = { "qf", "help" },
	callback = function(ev)
		local cmd = ev.match == "qf" and "<CMD>cclose<CR>" or "<CMD>close<CR>"
		vim.keymap.set("n", "q", cmd, { buffer = true, noremap = true })
	end,
})

-- enable spell check for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = comaug,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

--terminal
-- reference: https://stackoverflow.com/a/63909865/3387602
local termaug = vim.api.nvim_create_augroup("termaug", { clear = true })
-- start insert when the terminal is open
vim.api.nvim_create_autocmd("TermOpen", {
	group = termaug,
	command = "startinsert",
})

-- disable number line on terminal
vim.api.nvim_create_autocmd("TermOpen", {
	group = termaug,
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})
