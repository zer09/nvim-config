require("helper").map("n", "<Leader>gg", ":Neogit<CR>")

require("neogit").setup({
	signs = {
		-- { CLOSED, OPENED }
		section = { "", "" },
		item = { "", "" },
		hunk = { "", "" },
	},
})
