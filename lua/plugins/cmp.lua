return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = { "InsertEnter", "VeryLazy" },
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			keys = {
				{
					"<Tab>",
					function()
						return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
					end,
					expr = true,
					silent = true,
					mode = "i",
				},
				{
					"<Tab>",
					function()
						require("luasnip").jump(1)
					end,
					mode = "s",
				},
				{
					"<S-Tab>",
					function()
						require("luasnip").jump(-1)
					end,
					mode = { "i", "s" },
				},
			},
		},
	},
	opts = function()
		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

		local cmp = require("cmp")

		local iconKinds = require("helper").icons.kinds
		local iconKindLower = {}
		for k, v in pairs(iconKinds) do
			iconKindLower[k:lower()] = v
		end

		return {
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
			formatting = {
				format = function(entry, item)
					if iconKindLower[item.abbr:lower()] then
						item.kind = iconKindLower[item.abbr:lower()] .. item.kind
					elseif iconKinds[item.kind] then
						item.kind = iconKinds[item.kind] .. item.kind
					end

					item.menu = ({
						buffer = "[BUF]",
						nvim_lsp = "[LSP]",
						nvim_lua = "[API]",
						path = "[PATH]",
						luasnip = "[SNIP]",
					})[entry.source.name]
					return item
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<S-CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			matching = {
				disallow_fuzzy_matching = true,
				disallow_prefix_unmatching = true,
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sorting = require("cmp.config.default")().sorting,
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "nvim_lua" },
				{ name = "path" },
				{ name = "nvim_lsp_signature_help" },
			}, {
				{ name = "buffer" },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		}
	end,
}
