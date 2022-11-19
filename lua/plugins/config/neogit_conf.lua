require("neogit").setup({
	auto_refresh = false,
	disable_commit_confirmation = true,
	disable_insert_on_commit = true,
	signs = {
		-- { CLOSED, OPENED }
		section = { "", "" },
		item = { "", "" },
		hunk = { "", "" },
	},
})
