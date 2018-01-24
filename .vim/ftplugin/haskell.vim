set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround

let hs_highlight_delimiters = 1
let hs_highlight_boolean = 1
let hs_highlight_types = 1
let hs_highlight_more_types = 1
let hs_allow_hash_operator = 1

" Haskell-mode settings
au BufEnter *.hs compiler ghc
"let g:ghc = "/usr/bin/ghc"
let g:haddock_browser_nosilent = 1
let g:haddock_browser = "/usr/bin/qutebrowser"
let g:haskellmode_completion_ghc = 1
let g:haskellmode_completion_haddock = 0
