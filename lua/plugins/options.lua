local function conf(name)
	require(string.format("plugins.config.%s_conf", name))
end

conf("lualine")
conf("lsp")
conf("null_ls")
conf("cmp")
conf("treesitter")
conf("autopairs")
conf("choosewin")
conf("neogit")
conf("telescope")
conf("gitsign")
conf("aerial")

-- conf("tokyonight")
-- conf("material")
-- conf("oceanic_next")
-- conf("base_16")

require("nightfox").setup({
	options = {
		styles = {
			comments = "italic",
			keywords = "bold",
			functions = "italic",
		},
		inverse = {
			match_paren = true,
			search = true,
		},
	},
})

vim.cmd([[colorscheme nordfox]])
