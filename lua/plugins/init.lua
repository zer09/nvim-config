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
	},
	{
		"folke/tokyonight.nvim",
		"marko-cerovac/material.nvim",
		"mhartington/oceanic-next",
		"RRethy/nvim-base16",
	},
	{
		"nvim-lualine/lualine.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/nvim-lsp-installer",
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
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
					"rafamadriz/friendly-snippets",
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
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				requires = {
					"tpope/vim-commentary",
				},
			},
			"p00f/nvim-ts-rainbow",
		},
	},
	{
		"windwp/nvim-autopairs",
	},
	{
		"t9md/vim-choosewin",
	},
	{
		"TimUntersberger/neogit",
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
