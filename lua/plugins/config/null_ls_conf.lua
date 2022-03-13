local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.selene,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.shfmt,
	},
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			local lspformataug = vim.api.nvim_create_augroup("lspformataug", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = lspformataug,
				callback = function()
					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})
