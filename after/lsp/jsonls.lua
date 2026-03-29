vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas({
				select = {
					"package.json",
					"tsconfig.json",
					".eslintrc",
					"prettierrc.json",
					"cloudbuild.json",
				},
			}),
			validate = { enable = true },
		},
	},
})
