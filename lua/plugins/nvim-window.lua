return {
	"yorickpeterse/nvim-window",
	-- keys = {
	-- 	{ "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
	-- },
	config = function()
		require("nvim-window").setup({
			chars = { "h", "t", "n", "s", "a", "o", "e", "u" },
		})

		require("helper").nmap("-", "<CMD>lua require('nvim-window').pick()<CR>")
	end,
}
