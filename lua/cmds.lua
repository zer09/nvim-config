local comaug = vim.api.nvim_create_augroup("comaug", { clear = true })

-- Prevent add new comment when creating new line
vim.api.nvim_create_autocmd("FileType", {
	group = comaug,
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = comaug,
	callback = vim.highlight.on_yank,
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
vim.api.nvim_create_autocmd("InsertLeave", {
	group = comaug,
	callback = function()
		local _, _, caps_state = vim.fn.system("xset -q"):find("00: Caps Lock:%s+(%a+)")
		if caps_state == "on" then
			vim.fn.system("xdotool key Caps_Lock")
		end
	end,
})

-- remove trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
	group = comaug,
	callback = function()
		local save = vim.fn.winsaveview()
		vim.api.nvim_exec([[keepjumps keeppatterns silent! %s/\s\+$//e]], false)
		vim.fn.winrestview(save)
	end,
})

-- map cc to save commit
local gitaug = vim.api.nvim_create_augroup("gitaug", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "NeogitCommitMessage",
	group = gitaug,
	callback = function()
		require("helper").nmap("cc", ":wq<CR>", { buffer = 0 })
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
