-- resources
-- https://github.com/shaeinst/roshnivim/blob/main/lua/packer_nvim.lua
-- https://github.com/martinsione/dotfiles
-- https://github.com/folke/dot
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://oroques.dev/notes/neovim-init/

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	-- bootstrap lazy.nvim
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
vim.g.mapleader = " "

require("lazy").setup("plugins", {
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- require("impatient") -- comment this during install
require("cmds")
require("options")
require("handlers")

local mappings = require("mappings")
mappings.standard()
mappings.telescope()
mappings.neogit()
mappings.choosewin()
mappings.theme()
mappings.trouble()

vim.cmd.colorscheme("kanagawa")
