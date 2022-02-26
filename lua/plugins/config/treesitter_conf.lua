require("nvim-treesitter.configs").setup({
	ensured_installed = {
		"bash",
		"comment",
		"css",
		"html",
		"javascript",
		"jsdoc",
		"jsonc",
		"lua",
		"markdown",
		"regex",
		"scss",
		"toml",
		"typescript",
		"yaml",
	},
	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = false,
	},
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		lsp_interop = {
			enable = true,
			peek_definition_code = {
				["gD"] = "@function.outer",
			},
		},
	},
	textsubjects = {
		enable = true,
		prev_selection = ",", -- (Optional) keymap to select the previous selection
		keymaps = {
			["."] = "textsubjects-smart",
			[";"] = "textsubjects-container-outer",
			["i;"] = "textsubjects-container-inner",
		},
	},
	rainbow = {
		enable = true,
		extended_mode = true,
	},
	pairs = {
		enable = true,
		keymaps = {
			goto_partner = "%",
		},
	},
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
})

require("treesitter-context").setup({
	enable = true,
})

require("spellsitter").setup()
