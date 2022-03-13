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
					local ft = vim.bo.filetype
					if ft == "javascript" or ft == "typescript" then
						local params = {
							command = "_typescript.organizeImports",
							arguments = { vim.api.nvim_buf_get_name(0) },
							title = "",
						}
						vim.lsp.buf_request_sync(
							vim.api.nvim_get_current_buf(),
							"workspace/executeCommand",
							params,
							1000
						)
					end

					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})
