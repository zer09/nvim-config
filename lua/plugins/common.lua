return {
	{
		"nvim-lua/plenary.nvim",
		"ggandor/lightspeed.nvim",
		"kyazdani42/nvim-web-devicons",
		"b0o/schemastore.nvim",
		"lambdalisue/suda.vim",
		"folke/lsp-colors.nvim",
		"p00f/nvim-ts-rainbow",
		"lukas-reineke/indent-blankline.nvim",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▌" },
					change = { text = "▌" },
					changedelete = { text = "▌" },
					delete = { text = "▁" },
					topdelete = { text = "▔" },
				},
				numhl = true,
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
		},
		opts = {
			auto_refresh = false,
			console_timeout = 10000,
			disable_context_highlighting = true,
			disable_commit_confirmation = false,
			disable_builtin_notifications = true,
			disable_insert_on_commit = false,
			signs = {
				-- { CLOSED, OPENED }
				section = { "", "" },
				item = { "", "" },
				hunk = { "", "" },
			},
		},
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
	},
	{
		-- https://www.youtube.com/watch?v=NJDu_53T_4M
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},
}
