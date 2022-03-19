local function formatter(client)
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_add_user_command("Format", function()
			if #vim.lsp.buf_get_clients() < 1 then
				return
			end

			vim.lsp.buf.formatting_sync(nil, 1500)
		end, {
			desc = "Format the document using the formatter configured in null-ls config",
		})
	end
end

local function organizeImports()
	local ft = vim.bo.filetype
	if ft == "javascript" or ft == "typescript" then
		vim.api.nvim_add_user_command("OrganizeImports", function()
			if #vim.lsp.buf_get_clients() < 1 then
				return
			end

			local params = {
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
				title = "",
			}

			vim.lsp.buf_request_sync(vim.api.nvim_get_current_buf(), "workspace/executeCommand", params, 1500)
			vim.lsp.buf.formatting_sync()
		end, {
			desc = "Organize imports via tsserver",
		})
	end
end

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.selene,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.shfmt,
	},
	on_attach = function(client)
		formatter(client)
		organizeImports()
	end,
})
