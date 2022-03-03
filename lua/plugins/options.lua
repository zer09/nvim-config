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

-- conf("tokyonight")
-- conf("material")
-- conf("oceanic_next")

vim.cmd([[colorscheme base16-solarized-dark]])
