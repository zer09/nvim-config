local plugins = {
	{
		"lewis6991/impatient.nvim",
		"nathom/filetype.nvim",
		"nvim-lua/plenary.nvim",
		"ggandor/lightspeed.nvim",
		"kyazdani42/nvim-web-devicons",
		"b0o/schemastore.nvim",
		"lewis6991/gitsigns.nvim",
		"stevearc/aerial.nvim",
		"lambdalisue/suda.vim",
		"folke/lsp-colors.nvim",
		"nvim-lualine/lualine.nvim",
		"jose-elias-alvarez/null-ls.nvim",
		"windwp/nvim-autopairs",
		"t9md/vim-choosewin",
		"TimUntersberger/neogit",
		"p00f/nvim-ts-rainbow",
	},
	{
		"folke/tokyonight.nvim",
		"marko-cerovac/material.nvim",
		"mhartington/oceanic-next",
		"RRethy/nvim-base16",
		"EdenEast/nightfox.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/nvim-lsp-installer",
			"jose-elias-alvarez/nvim-lsp-ts-utils",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"onsails/lspkind-nvim", -- Enables icons on completions
			{ -- Snippets
				"L3MON4D3/LuaSnip",
				requires = {
					"saadparwaiz1/cmp_luasnip",
					"zer09/friendly-snippets",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-textsubjects",
			"romgrk/nvim-treesitter-context",
			"theHamsta/nvim-treesitter-pairs",
			"windwp/nvim-ts-autotag",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-telescope/telescope-file-browser.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
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
}

local packer = require("packer")

packer.init({
	-- Move to lua dir so impatient.nvim can cache it
	-- compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

packer.startup(function(use)
	use("wbthomason/packer.nvim")
	for _, plugin in ipairs(plugins) do
		use(plugin)
	end
end)
