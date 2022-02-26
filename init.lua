-- resources
-- https://github.com/shaeinst/roshnivim/blob/main/lua/packer_nvim.lua
-- https://github.com/martinsione/dotfiles
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://oroques.dev/notes/neovim-init/

require("plugins.config.impatient_conf")
require("plugins.config.filetype_conf")
require("mappings")
require("options")
require("plugins")

-- require("paq")({
-- 	"savq/paq-nvim",
-- 	"neovim/nvim-lspconfig",
-- 	"hrsh7th/nvim-cmp", -- Autocompletion plugin
-- 	"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
-- 	"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
-- 	"L3MON4D3/LuaSnip", -- Snippets plugin
-- 	"nvim-lualine/lualine.nvim",
-- 	"nvim-lua/plenary.nvim",
-- 	"jose-elias-alvarez/null-ls.nvim",
-- })
