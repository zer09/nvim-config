require("neogit").setup({
	disable_commit_confirmation = true,
	-- disable_insert_on_commit = false,
	signs = {
		-- { CLOSED, OPENED }
		section = { "", "" },
		item = { "", "" },
		hunk = { "", "" },
	},
})
