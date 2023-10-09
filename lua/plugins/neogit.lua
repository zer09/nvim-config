return {
	"NeogitOrg/neogit",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"nvim-telescope/telescope.nvim", -- optional
		"sindrets/diffview.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
	},
	opts = {
		auto_refresh = false,
		console_timeout = 10000,
		disable_context_highlighting = true,
		disable_commit_confirmation = false,
		disable_builtin_notifications = true,
		disable_insert_on_commit = false,
		signs = {
			-- { CLOSED, OPENED }
			section = { "", "" },
			item = { "", "" },
			hunk = { "", "" },
		},
	},
	init = function()
		require("helper").nnoremap("<Leader>gg", "<CMD>Neogit<CR>")
	end,
}
