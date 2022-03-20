require("nightfox").setup({
	options = {
		styles = {
			comments = "italic",
			keywords = "bold",
			functions = "italic",
		},
		inverse = {
			match_paren = true,
			-- search = true,
		},
	},
})

vim.cmd([[colorscheme nordfox]])
