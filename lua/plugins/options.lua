local function conf(name)
	require(string.format("plugins.config.%s_conf", name))
end

conf("lsp")
conf("null_ls")
conf("coc")
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
conf("nightfox")
conf("lualine")
