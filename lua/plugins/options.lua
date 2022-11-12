local function conf(name)
	require(string.format("plugins.config.%s_conf", name))
end

-- conf("lsp")
-- conf("null_ls")
conf("mason")
conf("formatter")
conf("cmp")
conf("treesitter")
conf("autopairs")
conf("choosewin")
conf("neogit")
conf("telescope")
conf("gitsign")
conf("aerial")
conf("indent_blankline")

-- conf("themes.tokyonight")
-- conf("themes.material")
-- conf("themes.oceanic_next")
-- conf("themes.base_16")
-- conf("themes.nightfox")
conf("themes.catppuccin")
conf("lualine")
