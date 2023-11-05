return {
	{
		"nvim-telescope/telescope.nvim",
		version = false,
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local act = require("telescope.actions")
			local act_layout = require("telescope.actions.layout")
			local tele = require("telescope")

			tele.setup({
				defaults = {
					winblend = 10,
					layout_config = { -- :help telescope.layout
						horizontal = { width = 0.9 },
						mirror = false,
						-- prompt_position = "top",
					},
					prompt_prefix = "❯ ",
					selection_caret = "❯ ",
					file_ignore_patterns = {
						"node_modules/.*",
						"%.env",
						"yarn.lock",
						"package%-lock.json",
						"pnpm%-lock.yaml",
						"lazy%-lock.json",
						"init.sql",
						"target/.*",
						".git/.*",
					},
					mappings = {
						n = {
							["<M-p>"] = act_layout.toggle_preview,
						},
						i = {
							["<esc>"] = act.close,
							["<M-p>"] = act_layout.toggle_preview,
							["<C-h>"] = "which_key",
						},
					},
				},
				pickers = {
					buffers = {
						mappings = {
							i = {
								["<C-d>"] = act.delete_buffer + act.move_to_top,
							},
						},
					},
				},
				extensions = {
					file_browser = {
						path = "%:p:h",
					},
				},
			})

			tele.load_extension("fzf")

			local nnoremap = require("helper").nnoremap
			nnoremap("<Leader>th", "<CMD>Telescope help_tags<CR>")
			nnoremap("<Leader>tm", "<CMD>Telescope keymaps<CR>")
			nnoremap("<Leader>tp", "<CMD>Telescope find_files hidden=true<CR>")
			nnoremap("<Leader>ts", "<CMD>Telescope live_grep<CR>")
			nnoremap("<Leader>bb", "<CMD>Telescope buffers<CR>")
		end,
	},
	{
		"AckslD/nvim-neoclip.lua",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"kkharji/sqlite.lua",
		},
		opts = function()
			require("telescope").load_extension("neoclip")
			require("helper").nnoremap("<Leader>tc", "<CMD>Telescope neoclip<CR>")

			return {
				enable_persistent_history = true,
			}
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("telescope").load_extension("file_browser")
			require("helper").nnoremap("<Leader>tt", "<CMD>Telescope file_browser hidden=true<CR>")
		end,
	},
	{
		"nvim-telescope/telescope-project.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("telescope").load_extension("project")
			require("helper").nnoremap("<Leader>pp", "<CMD>Telescope project<CR>")
		end,
	},
}
