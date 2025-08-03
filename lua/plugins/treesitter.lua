return {
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"andymass/vim-matchup",
		},
		opts = {
			highlight = {
				enable = true,
				disable = { "fzf" },
				additional_vim_regex_highlighting = { "python" },
			},
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
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-Space>",
					node_incremental = "<C-Space>",
					scope_incremental = false,
					node_decremental = "<BS>",
				},
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
	},
}
