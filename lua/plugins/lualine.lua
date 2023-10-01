return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				component_separators = "",
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
				lualine_c = {
					{
						"filetype",
						padding = { left = 1, right = 0 },
						icon_only = true,
					},
					{
						"filename",
					},
				},
				lualine_x = {
					"encoding",
				},
			},
		},
	},
}
