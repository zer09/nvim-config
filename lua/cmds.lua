-- Prevent add new comment when creating new line
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

-- highlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {}]])

-- remove the cursorline if the buffer is not in focus
vim.cmd([[
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline
]])

-- format on save
-- vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 100)]])
