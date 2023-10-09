return {
	{
		"lambdalisue/suda.vim",
		lazy = true,
		init = function()
			vim.g.suda_smart_edit = 1
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		event = "VeryLazy",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		version = false,
		event = "VeryLazy",
		opts = {},
	},
}
