-- insure this to install on venv
-- https://pypi.org/project/django-types/
-- to make it stricter aad this or set typeCheckingMode to default recommended
-- echo '{ "venvPath": ".", "venv": ".venv" }' >> pyrightconfig.json

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
	},
})
