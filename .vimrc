" .vimrc
" vim: foldmethod=marker:foldlevel=0

" Vundle settings (bundle management) {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle manages itself
Plugin 'gmarik/Vundle.vim'

" Syntastic
Plugin 'scrooloose/syntastic'

" NERD-Tree
Plugin 'scrooloose/nerdtree'

" Tagbar
Plugin 'majutsushi/tagbar'

" Fugitive
Plugin 'tpope/vim-fugitive'

" CTRL-P
Plugin 'kien/ctrlp.vim'

" Systemd-syntax
Plugin 'Matt-Deacalion/vim-systemd-syntax'

" bbcode
Plugin 'bbcode'

" Python-mode
Plugin 'klen/python-mode'

" Haskell-mode
Plugin 'lukerandall/haskellmode-vim'

" C.vim
Plugin 'vim-scripts/c.vim'

" vim-latex #replaced by LaTeX-Box
"Plugin 'lervag/vim-latex'

" LaTeX-Box
Plugin 'LaTeX-Box-Team/LaTeX-Box'

" Powerline #replaced by airline
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" airline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()
filetype plugin indent on
" docs ':h vundle'
" }}}

" Normal settings {{{
syntax enable
set background=dark
set number          " display linenumbers
set relativenumber  " display linenumbers relative to current line
set mouse=a
set tabstop=4       " number of visual spaces per TAB
set shiftwidth=4
set softtabstop=4   " number of spaces per TAB in editing
set expandtab       " TABs are spaces
set nowrap

set encoding=utf-8
set ttimeoutlen=50

set laststatus=2
set wildmenu        " visual command-completion (filenames)
set showcmd         " displays current key-command (bottom-right)
" }}}

" visual appearence {{{
"set fillchars+=vert:│
"hi VertSplit cterm=NONE ctermbg=NONE
hi VertSplit cterm=NONE ctermbg=8 ctermfg=8
hi Folded cterm=NONE ctermbg=NONE

set cursorline
"hi CursorLine cterm=NONE ctermbg=black ctermfg=NONE
hi CursorLine cterm=NONE ctermbg=black
hi CursorLineNr ctermbg=black
" }}}

" Keymappings {{{
" -- select
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
" -- move line
imap <C-S-Up> <Esc><C-S-Up>i
imap <C-S-Down> <Esc><C-S-Down>i
nmap <C-S-Up> dd<Up>P
nmap <C-S-Down> ddp
" -- move page
nmap <C-Up> <C-y>
nmap <C-Down> <C-e>

" -- movement over visually wrapped lines
nnoremap j gj
nnoremap k gk

" -- toggle search-highlighting
nnoremap <silent> <Space> :set hlsearch! hlsearch?<CR>

" -- cycle tabs with Alt-Tab (<C-Tab> does not work properly in xterm)
nmap <A-Tab> :tabnext<CR>

" -- xclip in selection-mode
" TODO not perfect yet
vnoremap <C-c> :w !xclip -i<CR><CR>
vnoremap <C-v> :r !xclip -o<CR><CR>
" }}}

" plugin-specific settings {{{
let g:airline_powerline_fonts = 0
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ""
let g:airline_right_sep = ""
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = 'ro'
let g:airline_symbols.linenr = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = "ubaryd"

" NERD-Tree
nmap <leader>e :NERDTreeToggle<CR>

" Tagbar
nmap <leader>t :TagbarToggle<CR>
" }}}

" Make {{{
function! s:SilentMakeCommand(cmdline)
    silent execute ':pedit! '.a:cmdline
    wincmd P
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    silent execute "$read!".a:cmdline
    " setlocal nomodifiable
    wincmd p
endfunction
command! -complete=shellcmd -nargs=+ SilentShell call s:SilentMakeCommand(<q-args>)
nmap <silent> <leader>m :w<CR>:SilentShell make<CR>
"nmap <leader>m :w<CR>:make<CR>

" List Search-results
" function! s:SilentSearchCommand(args)
" 	silent execute ':pedit! '.a:args
" 	wincmd P
" 	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
" 	setlocal hlsearch
" 	silent execute "$read! grep '".a:args."' #"
" 	" not working "silent execute search(a:args)
" 	wincmd p
" endfunction
" command! -complete=shellcmd -nargs=+ SilentSearch call s:SilentSearchCommand(<q-args>)
" nmap <leader>s :SilentSearch
" }}}

" Diff
" http://vimdoc.sourceforge.net/htmldoc/diff.html#diff-original-file
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Spellchecking {{{
nmap <leader>sd :setlocal spell spelllang=de<CR>
nmap <leader>se :setlocal spell spelllang=en<CR>
nmap <leader>so :set nospell<CR>
" }}}
