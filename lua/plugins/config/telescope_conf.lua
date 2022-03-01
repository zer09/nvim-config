local helper = require("helper")
local map = helper.map
local telescope = require("telescope")
local actions = require("telescope.actions")

map("n", "<Leader>ff", ":Telescope fd<CR>")
map("n", "<Leader>fb", ":Telescope file_browser path=%:p:h<CR>")
map("n", "<Leader>bb", ":Telescope buffers<CR>")
map("n", "<Leader>fg", ":Telescope live_grep<CR>")
map("n", "<Leader>fh", ":Telescope help_tags<CR>")
map("n", "<Leader>fm", ":Telescope keymaps<CR>")

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
	pickers = {
		file_browser = {
			path = "%:p:h",
		},
	},
	extensions = {},
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
