-- Label to choose when selecting tab.
vim.g.chooswin_label = "HTNSAOEU"

-- Dont show labels when there are only single window.
vim.g.choosewin_return_on_single_win = 1

-- Dont blink the cursor window is selected.
vim.g.choosewin_blink_on_land = 0

-- Keymap to activate the choosewin.
vim.cmd([[nmap - <Plug>(choosewin)]])
