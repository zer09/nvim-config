return {
	"kevinhwang91/nvim-fundo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	init = function()
		require("fundo").install()
	end,
}
