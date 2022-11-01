local nnoremap = require("helper").nnoremap

require("aerial").setup({
	layout = {
		placement = "edge",
	},
})

nnoremap("<Leader>a", "<CMD>AerialToggle!<CR>")
