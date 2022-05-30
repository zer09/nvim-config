require("catppuccin").setup({
	styles = {
		comments = "italic",
		keywords = "bold",
		functions = "italic",
	},
})
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
vim.cmd([[colorscheme catppuccin]])
