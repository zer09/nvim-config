return {
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				filetype = { "html", "yaml", "svelte" },
				show_current_context = true,
			})
		end,
	},
}
