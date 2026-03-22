-- https://github.com/mezdelex/neovim/blob/main/lua/plugins/treesitter.lua
---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = function()
				require("treesitter-context").setup({
					enable = true,
					multiline_threshold = 3,
				})
			end,
		},
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup()
			end,
		},
		{
			"andymass/vim-matchup",
			opts = {
				matchparen = {
					offscreen = {},
					deferred = 1,
				},
				motion = {
					override_Npercent = 0,
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "master",
		},
	},
	config = function()
		local config = require("nvim-treesitter.configs")
		local map = vim.keymap.set
		local mode = { "n", "x", "o" }
		local ts_repeat = require("nvim-treesitter.textobjects.repeatable_move")

		local next_diag, prev_diag = ts_repeat.make_repeatable_move_pair(function()
			vim.diagnostic.jump({ count = vim.v.count1, float = true })
		end, function()
			vim.diagnostic.jump({ count = -vim.v.count1, float = true })
		end)

		local next_err_diag, prev_err_diag = ts_repeat.make_repeatable_move_pair(function()
			vim.diagnostic.jump({ count = vim.v.count1, float = true, severity = vim.diagnostic.severity.ERROR })
		end, function()
			vim.diagnostic.jump({ count = -vim.v.count1, float = true, severity = vim.diagnostic.severity.ERROR })
		end)

		-- Repeatable move mappings
		map(mode, ";", ts_repeat.repeat_last_move)
		map(mode, ",", ts_repeat.repeat_last_move_opposite)
		map(mode, "f", ts_repeat.builtin_f_expr, { expr = true })
		map(mode, "F", ts_repeat.builtin_F_expr, { expr = true })
		map(mode, "t", ts_repeat.builtin_t_expr, { expr = true })
		map(mode, "T", ts_repeat.builtin_T_expr, { expr = true })

		map(mode, "gn", next_diag)
		map(mode, "gp", prev_diag)
		map(mode, "gen", next_err_diag)
		map(mode, "gep", prev_err_diag)

		-- https://www.youtube.com/watch?v=FuYQ7M73bC0
		config.setup({
			ensure_installed = {
				"angular",
				"bash",
				"comment",
				"css",
				"dart",
				"go",
				"hjson",
				"html",
				"htmldjango",
				"javascript",
				"jsonc",
				"jsdoc",
				"lua",
				"markdown",
				"markdown_inline",
				"ninja",
				"proto",
				"python",
				"query",
				"regex",
				"rst",
				"rust",
				"scss",
				"sql",
				"styled",
				"svelte",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"yaml",
			},
			sync_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false, -- required by catppuccin/nvim
				disable = { "fzf" },
			},
			indent = { enable = true },
			textobjects = {
				select = {
					enable = true,
					-- You have to clear all mappings in the buffer to test updated mappings:
					-- :mapclear <buffer>
					keymaps = {
						["ia"] = "@parameter.inner",
						["aa"] = "@parameter.outer",
						["ic"] = "@conditional.inner",
						["ac"] = "@conditional.outer",
						["if"] = "@function.inner",
						["af"] = "@function.outer",
						-- ["ig"] = "@call.inner",
						-- ["ag"] = "@call.outer",
						["ak"] = "@comment.outer",
						["ir"] = "@number.inner",
						["at"] = "@assignment.outer",
						["in"] = "@assignment.lhs",
						["iv"] = "@assignment.rhs",
						["ix"] = "@loop.inner",
						["ax"] = "@loop.outer",
					},
					selection_modes = {
						["@function.outer"] = "V",
						["@conditional.outer"] = "V",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>."] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>,"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]a"] = "@parameter.inner", -- (vim: next argument list (v0.11)
						["]k"] = "@conditional.outer", -- (vim: cursor N times forward to start of change)
						["]f"] = "@function.outer", -- (vim: same as "gf")
						["]g"] = "@call.outer",
						["]c"] = "@comment.outer",
						["]w"] = "@assignment.lhs",
						["]o"] = "@loop.outer",
						["]x"] = "@number.inner",
						["]v"] = "@assignment.rhs",
					},
					goto_next_end = {
						["]A"] = "@parameter.inner", -- (vim: last argument list (v0.11)
						["]K"] = "@conditional.outer",
						["]F"] = "@function.outer",
						["]G"] = "@call.outer",
						["]C"] = "@comment.outer",
						["]W"] = "@assignment.lhs",
						["]O"] = "@loop.outer",
						["]X"] = "@number.inner",
						["]V"] = "@assignment.rhs",
					},
					goto_previous_start = {
						["[a"] = "@parameter.inner", -- (vim: prev argument list (v0.11)
						["[k"] = "@conditional.outer", -- (vim: cursor N times backwards to start of change)
						["[f"] = "@function.outer", -- (vim: same as "gf")
						["[g"] = "@call.outer",
						["[c"] = "@comment.outer",
						["[w"] = "@assignment.lhs",
						["[o"] = "@loop.outer",
						["[x"] = "@number.inner",
						["[v"] = "@assignment.rhs",
					},
					goto_previous_end = {
						["[A"] = "@parameter.inner", -- (vim: first argument list (v0.11)
						["[K"] = "@conditional.outer",
						["[F"] = "@function.outer",
						["[G"] = "@call.outer",
						["[C"] = "@comment.outer",
						["[W"] = "@assignment.lhs",
						["[O"] = "@loop.outer",
						["[X"] = "@number.inner",
						["[V"] = "@assignment.rhs",
					},
				},
				lsp_interop = {
					enable = true,
					border = "single",
					floating_preview_opts = {},
					peek_definition_code = {
						["<leader>K"] = "@function.outer",
					},
				},
			},
		})
	end,
}
