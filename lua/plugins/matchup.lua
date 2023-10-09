return {
	"andymass/vim-matchup",
	version = false,
	event = "VeryLazy",
	config = function()
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
		vim.g.matchup_matchparen_deferred = 1
		vim.g.matchup_motion_override_Npercent = 0 -- enable vim default {count}%
	end,
}
