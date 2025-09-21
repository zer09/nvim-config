return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
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
				"javascript",
				"jsonc",
				"jsdoc",
				"lua",
				"markdown",
				"markdown_inline",
				"proto",
				"query",
				"regex",
				"rust",
				"scss",
				"sql",
				"svelte",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			sync_install = false,
			highlight = { enable = true, disable = { "fzf" } },
			indent = { enable = true },
		})

		require("nvim-ts-autotag").setup()
	end,
}
