-- resources
-- https://github.com/shaeinst/roshnivim/blob/main/lua/packer_nvim.lua
-- https://github.com/martinsione/dotfiles
-- https://github.com/folke/dot
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://oroques.dev/notes/neovim-init/

require("impatient") -- comment this during install
-- Do not source the default filetype.vim
vim.g.did_load_filetypes = 1

require("cmds")
require("options")

local mappings = require("mappings")
mappings.standard()

-- comment this if packer is not installed
require("plugins")
mappings.telescope()
mappings.neogit()
