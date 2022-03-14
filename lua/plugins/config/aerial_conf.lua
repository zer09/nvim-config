local nnoremap = require("helper").nnoremap

require("aerial").setup({
	close_behavior = "global",
	placement_editor_edge = "true",
	on_attach = function(bufnr)
		local opts = { buffer = bufnr }
		-- Toggle the aerial window with <Leader>a
		nnoremap("<Leader>a", "<CMD>AerialToggle!<CR>", opts)
		-- Jump forwards/backwards with '{' and '}'
		nnoremap("{", "<CMD>AerialPrev<CR>", opts)
		nnoremap("}", "<CMD>AerialNext<CR>", opts)
		-- Jump up the tree with '[[' or ']]'
		nnoremap("[[", "<CMD>AerialPrevUp<CR>", opts)
		nnoremap("]]", "<CMD>AerialNextUp<CR>", opts)
	end,
})
