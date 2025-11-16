return {
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "VeryLazy",
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = "VeryLazy",
		opts = {
			draw = {
				animation = function()
					return 2
				end,
			},
			symbol = "│",
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
	{
		"ggandor/leap.nvim",
		config = function()
			-- require("leap").add_default_mappings()
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			-- vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

			local leap = require("leap")

			leap.opts.preview_filter = function(ch0, ch1, ch2)
				return not (ch1:match("%s") or ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
			end

			leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
		end,
	},
	{
		"nvim-mini/mini.jump",
		version = false,
		config = function()
			require("mini.jump").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local np = require("nvim-autopairs")
			np.setup({ check_ts = true })
			np.add_rules({
				require("nvim-autopairs.rule")("<", ">", { "typescript" }):with_pair(
					require("nvim-autopairs.conds").not_before_text(" ")
				),
			})

			np.get_rules("[")[1].not_filetypes = { "html" }
			np.get_rules("(")[1].not_filetypes = { "html" }
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			preview = {
				winblend = 0,
			},
		},
	},
	{
		"andrewferrier/wrapping.nvim",
		config = function()
			require("wrapping").setup()
			local nnoremap = require("helper").nnoremap
			nnoremap("<Leader>ow", "<CMD>lua require('wrapping').soft_wrap_mode()<CR>")
			nnoremap("<Leader>yow", "<CMD>lua require('wrapping').toggle_wrap_mode()<CR>")
		end,
	},
	{
		"folke/noice.nvim",
		version = false,
		event = "VeryLazy",
		opts = {
			notify = {
				enabled = true,
				view = "mini",
			},
			messages = {
				enabled = true,
				view = "mini",
				view_error = "mini",
				view_warn = "mini",
				view_history = "messages",
				-- view_search = "virtualtext",
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				-- bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"rcarriga/nvim-notify",
				opts = {
					on_open = function(win)
						vim.api.nvim_win_set_config(win, { focusable = false })
					end,
				},
			},
		},
	},
	{
		"nvim-zh/colorful-winsep.nvim",
		event = { "WinLeave" },
		config = function()
			require("colorful-winsep").setup({
				animate = {
					enabled = false,
				},
			})
		end,
	},
}
