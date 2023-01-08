return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-textsubjects",
			"romgrk/nvim-treesitter-context",
			"theHamsta/nvim-treesitter-pairs",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			local mappings = require("mappings")
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"comment",
					"css",
					"help",
					"html",
					"javascript",
					"jsdoc",
					"hjson",
					"lua",
					"markdown",
					"query",
					"regex",
					"rust",
					"scss",
					"svelte",
					"toml",
					"typescript",
					"vim",
					"yaml",
				},
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
				},
				indent = {
					enable = false,
				},
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = mappings.treesitter.textobjects.select,
					},
					lsp_interop = {
						enable = true,
						peek_definition_code = mappings.treesitter.textobjects.lsp_interop.peek_definition_code,
					},
				},
				textsubjects = {
					enable = true,
					prev_selection = ",", -- (Optional) keymap to select the previous selection
					keymaps = mappings.treesitter.textsubjects,
				},
				rainbow = {
					enable = true,
					extended_mode = true,
				},
				pairs = {
					enable = true,
					keymaps = mappings.treesitter.pairs,
				},
				autotag = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
				},
			})

			require("treesitter-context").setup({
				enable = true,
			})
		end,
	},
}
