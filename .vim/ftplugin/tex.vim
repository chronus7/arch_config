set wrap
set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

let g:build_dir = 'output'
let g:LatexBox_build_dir = 'output'
let g:LatexBox_latexmk_options = '-new-viewer-'
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_quickfix = 2

let g:LatexBox_output_type = 'pdf'
let g:LatexBox_viewer = 'mupdf'

" old vim-latex settings
"let g:latex_view_enabled = 1
"let g:latex_view_method = 'general'
"let g:latex_view_general_viewer = 'mupdf'
