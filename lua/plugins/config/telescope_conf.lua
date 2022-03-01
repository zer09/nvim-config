local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = "❯ ",
		selection_caret = "❯ ",
		file_ignore_patterns = { "node_modules/.*", "%.env" },
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-u>"] = false,
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
