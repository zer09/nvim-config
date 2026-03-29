-- insure this to install on venv
-- https://pypi.org/project/django-types/
-- to make it stricter aad this or set typeCheckingMode to default recommended
-- echo '{ "venvPath": ".", "venv": ".venv" }' >> pyrightconfig.json

-- Navigation only (definition, implementation, references, rename, hover)
-- Diagnostics disabled — ty handles type checking, ruff handles linting
vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "off",
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				inlayHints = {
					callArgumentNames = true,
				},
			},
		},
	},
})
