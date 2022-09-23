-- resources
-- https://github.com/shaeinst/roshnivim/blob/main/lua/packer_nvim.lua
-- https://github.com/martinsione/dotfiles
-- https://github.com/folke/dot
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- https://oroques.dev/notes/neovim-init/

require("impatient") -- comment this during install
require("cmds")
require("options")

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
	require("plugins")
end, 0)

-- comment this if packer is not installed
require("plugins.options")
local mappings = require("mappings")
mappings.standard()
mappings.telescope()
mappings.neogit()
mappings.choosewin()
mappings.theme()
mappings.trouble()
