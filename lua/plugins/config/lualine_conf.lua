require("lualine").setup({
	options = {
		theme = "powerline",
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(mode)
					return table.concat(vim.tbl_map(function(word)
						return word:sub(1, 1)
					end, vim.split(mode, "-")))
				end,
			},
		},
	},
})
