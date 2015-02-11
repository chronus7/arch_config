set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

nmap <leader>p :let g:pymode=0

let g:pymode_python = 'python3'
let g:pymode_indent = 1
let g:pymode_doc = 1
let g:pymode_doc_bind = '<C-Q>'
let g:pymode_virtualenv = 1
let g:pymode_run = 1
let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_message = 1
" let g:pymode_lint_ignore = ...
let g:pymode_syntax = 1
