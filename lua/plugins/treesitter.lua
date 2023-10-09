return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = "VeryLazy",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"windwp/nvim-ts-autotag",
		"andymass/vim-matchup",
	},
	opts = {
		highlight = {
			enable = true,
			disable = { "fzf" },
			additional_vim_regex_highlighting = { "python" },
		},
		ensure_installed = {
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
			"svelte",
			"toml",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-Space>",
				node_incremental = "<C-Space>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
		autotag = {
			enable = true,
		},
		matchup = {
			enable = true,
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
		require("treesitter-context").setup({
			enable = true,
		})
	end,
}
