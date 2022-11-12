vim.g.material_style = "lighter"

require("material").setup({
	italics = {
		comments = true, -- Enable italic comments
		functions = true, -- Enable italic functions
	},
	high_visibility = {
		lighter = true, -- Enable higher contrast text for lighter style
		darker = true, -- Enable higher contrast text for darker style
	},
})

vim.cmd([[colorscheme material]])
