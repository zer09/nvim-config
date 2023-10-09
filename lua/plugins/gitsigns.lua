return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		on_attach = function(bufnr)
			local nnoremap = require("helper").nnoremap

			nnoremap("gtn", "<CMD>lua package.loaded.gitsigns.next_hunk()<CR>", { buffer = bufnr })
			nnoremap("gtp", "<CMD>lua package.loaded.gitsigns.prev_hunk()<CR>", { buffer = bufnr })
			nnoremap("gtd", "<CMD>lua package.loaded.gitsigns.diffthis()<CR>", { buffer = bufnr })
		end,
	},
}
