-- Navigation only (definition, implementation, references, rename, hover)
-- Diagnostics disabled at Neovim level — ty handles type checking, ruff handles linting
vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				inlayHints = {
					callArgumentNames = true,
				},
			},
		},
		python = {
			venvPath = ".",
			venv = ".venv",
		},
	},
})
