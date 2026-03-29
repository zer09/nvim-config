vim.lsp.config("ty", {
	settings = {
		ty = {
			-- Let Ruff handle syntax errors
			showSyntaxErrors = false,
			completions = {
				autoImport = true,
			},
		},
	},
})
