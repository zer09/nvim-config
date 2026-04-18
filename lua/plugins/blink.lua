return {
	-- {
	-- 	"nvim-mini/mini.cmdline",
	-- 	event = "CmdlineEnter",
	-- 	version = "*",
	-- 	opts = {
	-- 		autopeek = {
	-- 			enable = false,
	-- 		},
	-- 	},
	-- },
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*",
		dependencies = {
			"onsails/lspkind.nvim",
			"xzbdmw/colorful-menu.nvim",
			{
				"Kaiser-Yang/blink-cmp-dictionary",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{
				"rafamadriz/friendly-snippets",
				dependencies = {
					"saghen/blink.compat",
					-- use v2.* for blink.cmp v1.*
					version = "2.*",
					-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
					lazy = true,
					dependencies = {
						"ray-x/cmp-sql",
					},
					-- make sure to set opts so that lazy.nvim calls blink.compat's setup
					opts = {},
				},
			},
		},
		opts = {
			keymap = {
				preset = "enter",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-Up>"] = { "scroll_documentation_up", "fallback" },
				["<C-Down>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				ghost_text = {
					enabled = false,
				},
				documentation = {
					auto_show = false,
					window = {
						border = "rounded",
						winblend = 10,
					},
				},
				menu = {
					border = "rounded",
					winblend = 10,
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label" }, { "kind" }, { "source_name" } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = require("lspkind").symbol_map[ctx.kind] or ""
									end

									return icon .. ctx.icon_gap
								end,

								-- Optionally, use the highlight groups from nvim-web-devicons
								-- You can also add the same function for `kind.highlight` if you want to
								-- keep the highlight groups in sync with the icons.
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
							source_name = {
								text = function(ctx)
									return "[" .. ctx.source_name .. "]"
								end,
							},
						},
					},
				},
			},
			sources = {
				-- evaluated on every completion trigger — adds dictionary only in comments/strings
				default = function()
					local base = { "lazydev", "lsp", "path", "snippets", "buffer" }
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, row - 1, math.max(col - 1, 0))
					if ok and captures then
						for _, cap in ipairs(captures) do
							if cap.capture:match("comment") or cap.capture:match("string") then
								table.insert(base, "dictionary")
								break
							end
						end
					end
					return base
				end,
				per_filetype = {
					-- only enable lsp and snippets on html
					html = { "lsp", "snippets" },
					sql = { "sql", "lsp", "snippets", "buffer" },
					markdown = { "dictionary", "buffer", "snippets" },
					text = { "dictionary", "buffer" },
					gitcommit = { "dictionary", "buffer" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						transform_items = function(_, items)
							-- Removes language keywords/constants (if, else, while, etc.)
							-- provided by the language server from completion results.
							-- Useful if you prefer to use builtin or custom snippets
							-- for such constructs.
							return vim.tbl_filter(function(item)
								return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
							end, items)
						end,
					},
					sql = {
						name = "sql",
						module = "blink.compat.source",
					},
					dictionary = {
						name = "dictionary",
						module = "blink-cmp-dictionary",
						min_keyword_length = 3,
						opts = {
							dictionary_files = { "/usr/share/dict/words" },
						},
					},
				},
			},
			fuzzy = {
				implementation = "rust",

				-- Frecency tracks the most recently/frequently used items and boosts the score of the item
				-- Note, this does not apply when using the Lua implementation.
				frecency = {
					-- Whether to enable the frecency feature
					enabled = true,
					-- Location of the frecency database
					path = vim.fn.stdpath("state") .. "/blink/cmp/frecency.dat",
				},

				-- Proximity bonus boosts the score of items matching nearby words
				-- Note, this does not apply when using the Lua implementation.
				use_proximity = true,

				-- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
				-- You may pass a function instead of a string to customize the sorting
				sorts = {
					"exact",
					"score",
					"sort_text",
					"label",
				},
			},
			cmdline = {
				completion = {
					ghost_text = {
						enabled = false,
					},
				},
			},
			snippets = { preset = "default" },
		},
	},
}
