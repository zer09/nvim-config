return {
	{
		"lewis6991/gitsigns.nvim",
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
	},
	{
		"isakbm/gitgraph.nvim",
		opts = {
			git_cmd = "git",
			symbols = {
				merge_commit = "M",
				commit = "*",
			},
			format = {
				timestamp = "%H:%M:%S %d-%m-%Y",
				fields = { "hash", "timestamp", "author", "branch_name", "tag" },
			},
			hooks = {
				-- Check diff of a commit
				on_select_commit = function(commit)
					vim.notify("DiffviewOpen " .. commit.hash .. "^!")
					vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
				end,
				-- Check diff from commit a -> commit b
				on_select_range_commit = function(from, to)
					vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
					vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			-- "nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua", -- optional
		},
		config = function()
			require("neogit").setup({
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
				commit_editor = {
					kind = "vsplit",
					show_staged_diff = false,
				},
			})

			require("helper").nnoremap("<Leader>gg", "<CMD>Neogit<CR>")

			-- map cc to save commit
			local gitaug = vim.api.nvim_create_augroup("gitaug", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gitcommit",
				group = gitaug,
				callback = function()
					require("helper").nmap("cc", "<CMD>wq<CR>", { buffer = 0 })
				end,
			})

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
	},
	{
		"tpope/vim-fugitive",
	},
}
