local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup("plugins", {
	change_detection = {
		enabled = true,
		notify = false,
	},
	checker = {
		enabled = true,
		notify = false,
	},
	install = {
		missing = true,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"rplugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		border = "rounded",
	},
})

require("options")
require("cmd")
require("map")
require("goto")

vim.cmd.colorscheme("kanagawa")
