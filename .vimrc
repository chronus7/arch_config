" Vundle settings (bundle management)
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

" Python-mode
Plugin 'klen/python-mode'

" Haskell-mode
Plugin 'lukerandall/haskellmode-vim'

" C.vim
Plugin 'vim-scripts/c.vim'

" vim-latex
Plugin 'lervag/vim-latex'

" Powerline #replaced by airline
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" airline
Plugin 'bling/vim-airline'

call vundle#end()
filetype plugin indent on
" docs ':h vundle'

" Normal settings

syntax on
set background=dark
set number
set mouse=a
set tabstop=4
set shiftwidth=4
set softtabstop=4
set nowrap

set laststatus=2
set encoding=utf-8
set ttimeoutlen=50

" Keymappings
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

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" NERD-Tree
nmap <leader>e :NERDTreeToggle<CR>

" Tagbar
nmap <leader>t :TagbarToggle<CR>

" Make
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

" Spellchecking
nmap <leader>sd :setlocal spell spelllang=de<CR>
nmap <leader>se :setlocal spell spelllang=en<CR>
nmap <leader>so :set nospell<CR>
