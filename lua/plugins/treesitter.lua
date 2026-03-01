-- https://github.com/mezdelex/neovim/blob/main/lua/plugins/treesitter.lua
---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"windwp/nvim-ts-autotag",
		{
			"andymass/vim-matchup",
			opts = {
				matchparen = {
					offscreen = {},
					deferred = 1,
				},
				motion = {
					override_Npercent = 0,
				},
			},
		},
	},
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"angular",
				"bash",
				"comment",
				"css",
				"dart",
				"go",
				"hjson",
				"html",
				"htmldjango",
				"javascript",
				"jsonc",
				"jsdoc",
				"lua",
				"markdown",
				"markdown_inline",
				"ninja",
				"proto",
				"python",
				"query",
				"regex",
				"rst",
				"rust",
				"scss",
				"sql",
				"styled",
				"svelte",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"yaml",
			},
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false, -- required by catppuccin/nvim
				disable = { "fzf" },
			},
			indent = { enable = true },
		})

		require("nvim-ts-autotag").setup()
		require("treesitter-context").setup({
			enable = true,
			multiline_threshold = 3,
		})
	end,
}
