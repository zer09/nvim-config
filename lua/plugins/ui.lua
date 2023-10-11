local iconKinds = require("helper").icons.kinds

return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "VeryLazy",
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"stevearc/dressing.nvim",
		version = false,
		event = "VeryLazy",
		opts = {},
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
		},
	},
	{
		"folke/noice.nvim",
		version = false,
		event = "VeryLazy",
		opts = {
			messages = {
				enabled = true,
				view = "mini",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
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
		"folke/todo-comments.nvim",
		version = false,
		event = "VeryLazy",
		opts = {},
	},
	{
		"folke/flash.nvim",
		version = false,
		event = "VeryLazy",
		opts = {},
	},
	{
		"simrat39/symbols-outline.nvim",
		version = false,
		event = "VeryLazy",
		opts = {
			symbols = {
				File = { icon = iconKinds.File, hl = "@text.uri" },
				Module = { icon = iconKinds.Module, hl = "@namespace" },
				Namespace = { icon = iconKinds.Namespace, hl = "@namespace" },
				Package = { icon = iconKinds.Package, hl = "@namespace" },
				Class = { icon = iconKinds.Class, hl = "@type" },
				Method = { icon = iconKinds.Method, hl = "@method" },
				Property = { icon = iconKinds.Property, hl = "@method" },
				Field = { icon = iconKinds.Field, hl = "@field" },
				Constructor = { icon = iconKinds.Constructor, hl = "@constructor" },
				Enum = { icon = iconKinds.Enum, hl = "@type" },
				Interface = { icon = iconKinds.Interface, hl = "@type" },
				Function = { icon = iconKinds.Function, hl = "@function" },
				Variable = { icon = iconKinds.Variable, hl = "@constant" },
				Constant = { icon = iconKinds.Constant, hl = "@constant" },
				String = { icon = iconKinds.String, hl = "@string" },
				Number = { icon = iconKinds.Number, hl = "@number" },
				Boolean = { icon = iconKinds.Boolean, hl = "@boolean" },
				Array = { icon = iconKinds.Array, hl = "@constant" },
				Object = { icon = iconKinds.Object, hl = "@type" },
				Key = { icon = iconKinds.Key, hl = "@type" },
				Null = { icon = iconKinds.Null, hl = "@type" },
				EnumMember = { icon = iconKinds.EnumMember, hl = "@field" },
				Struct = { icon = iconKinds.Struct, hl = "@type" },
				Event = { icon = iconKinds.Event, hl = "@type" },
				Operator = { icon = iconKinds.Operator, hl = "@operator" },
				TypeParameter = { icon = iconKinds.TypeParameter, hl = "@parameter" },
				Component = { icon = "", hl = "@function" },
				Fragment = { icon = "", hl = "@constant" },
			},
		},
		init = function()
			require("helper").nnoremap("<Leader>oo", "<CMD>SymbolsOutline<CR>")
		end,
	},
	{
		"windwp/nvim-autopairs",
		version = false,
		event = "VeryLazy",
		opts = {},
	},
	{
		"kevinhwang91/nvim-bqf",
		version = false,
		lazy = true,
		ft = "qf",
		opts = {
			preview = {
				winblend = 0,
			},
		},
	},
}
