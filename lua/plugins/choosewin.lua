return {
	-- {
	-- 	"t9md/vim-choosewin",
	-- 	version = false,
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		-- Label to choose when selecting tab.
	-- 		vim.g.choosewin_label = "HTNSAOEU"
	--
	-- 		-- Dont show labels when there are only single window.
	-- 		vim.g.choosewin_return_on_single_win = 1
	--
	-- 		-- Dont blink the cursor window is selected.
	-- 		vim.g.choosewin_blink_on_land = 0
	--
	-- 		-- require("helper").nmap("-", "<Plug>(choosewin)")
	-- 	end,
	-- },
	-- {
	-- 	-- WINDOW PICKER
	-- 	"s1n7ax/nvim-window-picker",
	-- 	version = "v1.*",
	-- 	config = function()
	-- 		local picker = require("window-picker")
	-- 		picker.setup({ fg_color = "#000000", hint = "floating-big-letter" })
	--
	-- 		vim.keymap.set("n", "<leader><leader>w", function()
	-- 			local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
	-- 			vim.api.nvim_set_current_win(picked_window_id)
	-- 		end, { desc = "Pick a window" })
	-- 	end,
	-- },
	{
		"yorickpeterse/nvim-window",
		-- keys = {
		-- 	{ "<leader>wj", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
		-- },
		config = function()
			require("nvim-window").setup({
				-- The characters available for hinting windows.
				chars = { "h", "t", "n", "s", "a", "o", "e", "u" },
			})

			require("helper").nmap("-", "<CMD>lua require('nvim-window').pick()<CR>")
		end,
	},
}
