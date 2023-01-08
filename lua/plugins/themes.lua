return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

			require("catppuccin").setup({
				styles = {
					comments = { "italic" },
					keywords = { "bold" },
					functions = { "italic" },
				},
			})

			vim.cmd([[colorscheme catppuccin]])
		end,
	},
}
