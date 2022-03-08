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

-- vim.cmd([[colorscheme base16-monokai]])
-- vim.cmd([[colorscheme base16-tomorrow]])
vim.cmd([[colorscheme base16-solarized-dark]])

vim.cmd([[
highlight! link TelescopeSelection    Visual
highlight! link TelescopeNormal       Normal
highlight! link TelescopePromptNormal TelescopeNormal
highlight! link TelescopeBorder       TelescopeNormal
highlight! link TelescopePromptBorder TelescopeBorder
highlight! link TelescopeTitle        TelescopeBorder
highlight! link TelescopePromptTitle  TelescopeTitle
highlight! link TelescopeResultsTitle TelescopeTitle
highlight! link TelescopePreviewTitle TelescopeTitle
highlight! link TelescopePromptPrefix Identifier
]])
