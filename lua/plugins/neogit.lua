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
		local Color = require("neogit.lib.color").Color
		local base_green = Color.from_hex("#a6d189")
		local base_red = Color.from_hex("#e78284")

		local green = base_green:to_css()
		local bg_green = base_green:shade(-0.18):to_css()
		local line_green = base_green:shade(-0.72):set_saturation(0.2):to_css()

		local red = base_red:to_css()
		local bg_red = base_red:shade(-0.18):to_css()
		local line_red = base_red:shade(-0.6):set_saturation(0.4):to_css()

		vim.api.nvim_set_hl(0, "NeogitDiffAdd", {
			bg = line_green,
			fg = bg_green,
		})

		vim.api.nvim_set_hl(0, "NeogitDiffDelete", {
			bg = line_red,
			fg = bg_red,
		})

		vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", {
			bg = line_green,
			fg = green,
		})

		vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", {
			bg = line_red,
			fg = red,
		})
	end,
}
