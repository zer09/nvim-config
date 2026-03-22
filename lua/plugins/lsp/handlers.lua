local UserLspConfig = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
local keymap = vim.keymap.set

keymap("n", "<leader>ls", vim.diagnostic.setloclist)
keymap("n", "<leader>lS", vim.diagnostic.setqflist)

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

		local lsp = vim.lsp.buf
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
		keymap("n", "ga", lsp.code_action, opts)
		keymap("n", "gd", lsp.definition, opts)
		keymap("n", "gt", lsp.type_definition, opts)
		keymap("n", "gi", lsp.implementation, opts)
		keymap("n", "ga", lsp.code_action, opts)

		if vim.fn.findfile("angular.json", ".;") ~= "" then
			keymap("n", "grn", function()
				lsp.rename(nil, { name = "angularls" })
			end, opts)
		else
			keymap("n", "<leader>", lsp.rename, opts)
		end

		keymap("n", "gq", function()
			if vim.diagnostic.is_enabled() then
				vim.diagnostic.enable(false)
			else
				vim.diagnostic.enable()
			end
		end, { desc = "Toggle diagnostics" })
	end,
})
