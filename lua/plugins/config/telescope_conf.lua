local telescope = require("telescope")

telescope.setup({
	defaults = {
		prompt_prefix = "❯ ",
		selection_caret = "❯ ",
		-- layout_strategy = "vertical",
		file_ignore_patterns = { "node_modules/.*", "%.env", "yarn.lock", "package-lock.json" },
		mappings = require("mappings").telescope_default_mappings,
	},
	extensions = {
		file_browser = {
			path = "%:p:h",
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
