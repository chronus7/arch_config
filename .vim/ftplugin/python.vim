set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4
set textwidth=79
set autoindent

let python_highlight_all = 1

" let g:SimpylFold_docstring_preview = 1
setlocal foldmethod=indent


" <F7> to run flake
let g:flake8_show_quickfix = 0      " open quickfix window
let g:flake8_show_in_gutter = 1     " show mark in gutter
let g:flake8_show_in_file = 0       " show mark in file
let g:flake8_error_marker='E'       " set error marker to 'EE'
let g:flake8_warning_marker='W'     " set warning marker to 'WW'
let g:flake8_pyflake_marker='F'     " set PyFlakes warnings
let g:flake8_complexity_marker='M'  " set McCabe complexity warnings
let g:flake8_naming_marker='N'      " disable naming warnings
" flake8 configs in ~/.config/flake8

" run flake8 on write
"autocmd BufWritePost *.py call Flake8()

" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" most possibly useful for YCM
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate, dict(__file__=activate_this))
EOF
