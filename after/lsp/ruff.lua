vim.lsp.config("ruff", {
	init_options = {
		settings = {
			configurationPreference = "filesystemFirst",
			lint = {
				preview = false,
			},
		},
	},
})
