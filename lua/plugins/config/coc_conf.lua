vim.cmd([[

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Coc Extensions
let g:coc_global_extensions = [
  \   'coc-angular',
  \   'coc-css',
  \   'coc-cssmodules',
  \   'coc-html',
  \   'coc-json',
  \   'coc-snippets',
  \   'coc-yaml'
  \ ]

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Completion tab reverse
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr><C-Space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr><CR> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Add new line and indent when you press enter between curly brace, etc.
" inoremap <silent><expr> <CR> pumvisible() ?
"   \ coc#_select_confirm() :
"   \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" snippets jump to the next placeholder.
let g:coc_snippet_next = '<C-l>'
" snippet jump to the previous placeholder.
let g:coc_snippet_prev = '<C-h>'
]])
