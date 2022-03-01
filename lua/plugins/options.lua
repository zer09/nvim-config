local function conf(name)
	require(string.format("plugins.config.%s_conf", name))
end

conf("tokyonight")
conf("lualine")
conf("lsp")
conf("null_ls")
conf("cmp")
conf("treesitter")
conf("autopairs")
conf("choosewin")
conf("neogit")
conf("telescope")
