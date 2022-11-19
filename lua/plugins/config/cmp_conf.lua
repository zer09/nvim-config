local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local ls = require("luasnip")
local lspkind = require("lspkind")
local compare = require("cmp.config.compare")
local cmp_buffer = require("cmp_buffer")

ls.config.set_config({
	history = false,
	update_events = "TextChanged,TextChangedI",
	region_check_events = "InsertEnter",
})

-- snippets
require("plugins.config.snippets.typescript")
require("plugins.config.snippets.sql")
require("plugins.config.snippets.html")
require("plugins.config.snippets.all")

-- nvim-cmp setup
local cmp = require("cmp")

local up = function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif ls.jumpable(-1) then
		ls.jump(-1)
	else
		fallback()
	end
end

local down = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif ls.expand_or_jumpable() then
		ls.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			preset = "codicons",
			maxwidth = 50,
			menu = {
				buffer = "[BUF]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[API]",
				path = "[PATH]",
				luasnip = "[SNIP]",
			},
		}),
	},
	matching = {
		disallow_fuzzy_matching = true,
		disallow_prefix_unmatching = true,
	},
	experimental = {
		native_menu = false,
		ghost_text = false,
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			compare.length,
			compare.score,
			compare.offset,
			function(...)
				return cmp_buffer:compare_locality(...)
			end,
			compare.exact,
			compare.recently_used,
			compare.kind,
			compare.sort_text,
			compare.order,
		},
	},
	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
	}),
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		[",."] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(down, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(up, { "i", "s" }),
		["<Down>"] = cmp.mapping(down, { "i", "s" }),
		["<Up>"] = cmp.mapping(up, { "i", "s" }),
	},
})

vim.cmd([[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])
