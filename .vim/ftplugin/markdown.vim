set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

set wrap
set autoindent
set fo+=n2

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ],
    \ 'sort': 0,
\ }
