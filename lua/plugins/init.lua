local function conf(name)
	return require(string.format("plugins.config.%s_conf", name))
end

local plugins = {
	{
		"lewis6991/impatient.nvim",
		"nathom/filetype.nvim",
		"ggandor/lightspeed.nvim",
	},
	{
		"folke/tokyonight.nvim",
		config = conf("tokyonight"),
	},
	{
		"nvim-lualine/lualine.nvim",
		config = conf("lualine"),
	},
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = conf("lsp"),
		requires = {
			"williamboman/nvim-lsp-installer",
		},
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = conf("null_ls"),
		requires = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = conf("cmp"),
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
		config = conf("treesitter"),
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
			"lewis6991/spellsitter.nvim",
		},
	},
	{
		"windwp/nvim-autopairs",
		config = conf("autopairs"),
	},
	{
		"t9md/vim-choosewin",
		config = conf("choosewin"),
	},
}

local packer = require("packer")

packer.init({
	-- Move to lua dir so impatient.nvim can cache it
	compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
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
