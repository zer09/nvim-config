return {
	"yorickpeterse/nvim-window",
	config = function()
		require("nvim-window").setup({
			chars = { "h", "t", "n", "s", "a", "o", "e", "u" },
		})

		require("helper").nmap("-", "<CMD>lua require('nvim-window').pick()<CR>")
	end,
}
