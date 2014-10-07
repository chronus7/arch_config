" Vundle settings (bundle management)
set rtp+=/home/eled/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle manages itself
Plugin 'gmarik/Vundle.vim'

" Python-mode
Plugin 'klen/python-mode'

" Haskell-mode
Plugin 'lukerandall/haskellmode-vim'

" C.vim
Plugin 'vim-scripts/c.vim'

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
set nowrap

set laststatus=2
set encoding=utf-8
set ttimeoutlen=50

" *.md as markdown
au BufAdd,BufNewFile *.md set filetype=markdown

" vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
" set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#whitespace#mixed_indent_algo = 1
