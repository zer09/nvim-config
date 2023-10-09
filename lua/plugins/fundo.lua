return {
	"kevinhwang91/nvim-fundo",
	version = false,
	event = "VeryLazy",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	opts = {},
	init = function()
		require("fundo").install()
	end,
}
