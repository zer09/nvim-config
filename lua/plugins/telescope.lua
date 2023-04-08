return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
			local trouble = require("trouble.providers.telescope")

			telescope.setup({
				defaults = {
					prompt_prefix = "❯ ",
					selection_caret = "❯ ",
					-- layout_strategy = "vertical",
					file_ignore_patterns = {
						"node_modules/.*",
						"%.env",
						"yarn.lock",
						"package-lock.json",
						"init.sql",
						"target/.*",
						".git/.*",
					},
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
							["<C-u>"] = false,
							["<C-t>"] = trouble.open_with_trouble,
						},
						n = {
							["<C-t>"] = trouble.open_with_trouble,
						},
					},
				},
				extensions = {
					file_browser = {
						path = "%:p:h",
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
		end,
	},
}
