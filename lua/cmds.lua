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

vim.cmd([[autocmd FileType NeogitCommitMessage nmap <buffer>cc :wq<CR>]])

-- function TurnOffCaps()
-- 	local _, _, caps_state = vim.fn.system("xset -q"):find("00: Caps Lock:%s+(%a+)")
-- 	if caps_state == "on" then
-- 		vim.fn.system("xdotool key Caps_Lock")
-- 	end
-- end

vim.cmd([[
function TurnOffCaps()
  let capsState = matchstr(system('xset -q'), '00: Caps Lock:\s\+\zs\(on\|off\)\ze')
  if capsState == 'on'
    silent! execute ':!xdotool key Caps_Lock'
  endif
endfunction

au InsertLeave * call TurnOffCaps()
]])

vim.cmd([[
""
" Will remove the trailing whitespace
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

" Remove whitespaces on save
autocmd BufWritePre * :call TrimWhitespace()
]])
