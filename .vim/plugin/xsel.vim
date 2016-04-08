" Uses xsel to copy visually marked content.
" Keymapping is <C-c> in visual mode.
" 
" Dave J (https://github.com/chronus7)

function! xsel#yank()
    normal! gv
    normal! y
    call s:write_clipboard(@@)
    return
endfunction

function! s:write_clipboard(text)
    call system('xsel -i <<< "'.a:text.'"')
    return
endfunction

execute 'silent! vmap <unique> <C-c> :call xsel#yank()<Return>'
