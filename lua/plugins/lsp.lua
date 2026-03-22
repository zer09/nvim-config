local UserLspConfig = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
local keymap = vim.keymap.set
local lsp = vim.lsp.buf
local mode = { "n", "x", "o" }

keymap(mode, "<leader>ls", vim.diagnostic.setloclist)
keymap(mode, "<leader>lS", vim.diagnostic.setqflist)

vim.api.nvim_create_autocmd("LspAttach", {
	group = UserLspConfig,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		local caps = client.server_capabilities

		caps.documentFormattingProvider = false
		caps.documentRangeFormattingProvider = false
		caps.semanticTokensProvider = nil

		if client.name == "ruff" then
			caps.hoverProvider = false
		end

		local opts = { buffer = ev.buf, noremap = true }

		-- this are the defaults
		-- "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
		-- "gri" is mapped to vim.lsp.buf.implementation()
		-- "grn" is mapped to vim.lsp.buf.rename()
		-- "grr" is mapped to vim.lsp.buf.references()
		-- "grt" is mapped to vim.lsp.buf.type_definition()
		-- "grx" is mapped to vim.lsp.codelens.run()
		-- "gO" is mapped to vim.lsp.buf.document_symbol()
		-- CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
		-- v_an and v_in fall back to LSP vim.lsp.buf.selection_range() if treesitter is not active.
		-- gx handles textDocument/documentLink. Example: with gopls, invoking gx on "os" in this Go code will open documentation externally:
		-- K is mapped to vim.lsp.buf.hover() unless 'keywordprg' is customized or a custom keymap for K exists.
		-- nnoremap("K", "<CMD>lua vim.lsp.buf.hover()<CR>", opts)
		-- nnoremap("<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>", opts)
		-- keymap("n", "K", lsp.hover, opts)

		-- 	if client.config.name == "typescript-tools" then
		-- 		nnoremap("gld", "<CMD>TSToolsGoToSourceDefinition<CR>", opts)
		-- 		nnoremap("glf", "<CMD>TSToolsFixAll<CR>", opts)
		-- 		nnoremap("gli", "<CMD>TSToolsAddMissingImports<CR>", opts)
		-- 		nnoremap("glo", "<CMD>TSToolsOrganizeImports<CR>", opts)
		-- 	end

		keymap(mode, "ga", lsp.code_action, opts)
		keymap(mode, "gd", lsp.definition, opts)
		keymap(mode, "gt", lsp.type_definition, opts)
		keymap(mode, "gi", lsp.implementation, opts)

		if vim.fn.findfile("angular.json", ".;") ~= "" then
			keymap(mode, "grn", function()
				lsp.rename(nil, { name = "angularls" })
			end, opts)
		else
			keymap(mode, "grn", lsp.rename, opts)
		end

		keymap(mode, "gq", function()
			if vim.diagnostic.is_enabled() then
				vim.diagnostic.enable(false)
			else
				vim.diagnostic.enable()
			end
		end, { desc = "Toggle diagnostics" })
	end,
})

-- https://github.com/nvim-telescope/telescope.nvim/issues/3328#issuecomment-2472420006
-- local filterDuplicates = function(array)
-- 	local uniqueArray = {}
-- 	for _, tableA in ipairs(array) do
-- 		local isDuplicate = false
-- 		for _, tableB in ipairs(uniqueArray) do
-- 			if vim.deep_equal(tableA, tableB) then
-- 				isDuplicate = true
-- 				break
-- 			end
-- 		end
-- 		if not isDuplicate then
-- 			table.insert(uniqueArray, tableA)
-- 		end
-- 	end
-- 	return uniqueArray
-- end
--
-- local on_list = function(options)
-- 	options.items = filterDuplicates(options.items)
-- 	vim.fn.setqflist({}, " ", options)
-- 	vim.cmd("botright copen")
-- end

-- disable for now observe the default find reference
-- this will override the onlist for find references
-- vim.keymap.set("n", "gr", function()
-- 	vim.lsp.buf.references(nil, { on_list = on_list })
-- end, { noremap = true })

local icons = require("helper").icons

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
	},
	float = {
		border = "rounded",
	},
})

return {
	{
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
			keymap(mode, ";", ts_repeat.repeat_last_move)
			keymap(mode, ",", ts_repeat.repeat_last_move_opposite)
			keymap(mode, "f", ts_repeat.builtin_f_expr, { expr = true })
			keymap(mode, "F", ts_repeat.builtin_F_expr, { expr = true })
			keymap(mode, "t", ts_repeat.builtin_t_expr, { expr = true })
			keymap(mode, "T", ts_repeat.builtin_T_expr, { expr = true })

			keymap(mode, "gn", next_diag)
			keymap(mode, "gp", prev_diag)
			keymap(mode, "gen", next_err_diag)
			keymap(mode, "gep", prev_err_diag)

			-- https://www.youtube.com/watch?v=FuYQ7M73bC0
			---@diagnostic disable-next-line: missing-fields
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
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		dependencies = {
			"Bilal2453/luvit-meta",
			"DrKJeff16/wezterm-types",
		},
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				-- Only load the lazyvim library when the `LazyVim` global is found
				{ path = "LazyVim", words = { "LazyVim" } },
				-- Load the wezterm types when the `wezterm` module is required
				-- Needs `DrKJeff16/wezterm-types` to be installed
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
			enabled = function(root_dir)
				return not vim.uv.fs_stat(root_dir .. "/.init.lua")
			end,
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"angularls",
				"basedpyright",
				"bashls",
				"cssls",
				"djls",
				"djlsp",
				"eslint",
				"gopls",
				"html",
				"jsonls",
				"lua_ls",
				"pbls",
				"ruff",
				"rust_analyzer",
				"svelte",
				"tailwindcss",
				"ts_ls",
				"vue_ls",
				"yamlls",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			{
				"neovim/nvim-lspconfig",
				pin = true,
			},
			{
				"b0o/SchemaStore.nvim",
				version = false,
				lazy = true,
			},
		},
	},
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("flutter-tools").setup({
				dev_log = {
					notify_errors = true, -- if there is an error whilst running then notify the user
					open_cmd = "tabedit", -- command to use to open the log buffer
				},
				widget_guides = {
					enabled = true,
				},
				lsp = {
					color = { -- show the derived colours for dart variables
						enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
						background = true, -- highlight the background
					},
				},
			})

			require("telescope").load_extension("flutter")
			keymap("n", "<leader>tf", "<CMD>Telescope flutter commands<CR>")
		end,
	},
}
