return {
	{
		"lambdalisue/suda.vim",
		lazy = false,
		config = function()
			vim.g.suda_smart_edit = 1
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "sua", -- Add surrounding in Normal and Visual modes
				delete = "sud", -- Delete surrounding
				find = "suf", -- Find surrounding (to the right)
				find_left = "suF", -- Find surrounding (to the left)
				highlight = "suh", -- Highlight surrounding
				replace = "sur", -- Replace surrounding
				update_n_lines = "sun", -- Update `n_lines`
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		version = false,
		event = "VeryLazy",
		opts = {},
	},
}
