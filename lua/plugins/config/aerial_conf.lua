require("aerial").setup({
	close_behavior = "global",
	placement_editor_edge = "true",
	on_attach = function(bufnr)
		-- Toggle the aerial window with <Leader>a
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>a", "<CMD>AerialToggle!<CR>", {})
		-- Jump forwards/backwards with '{' and '}'
		vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<CMD>AerialPrev<CR>", {})
		vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<CMD>AerialNext<CR>", {})
		-- Jump up the tree with '[[' or ']]'
		vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<CMD>AerialPrevUp<CR>", {})
		vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<CMD>AerialNextUp<CR>", {})
	end,
})
