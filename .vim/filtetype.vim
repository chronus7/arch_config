" *.md as markdown
au BufAdd,BufNewFile *.md set filetype=markdown

augroup filtypedetect
	" Mail
	autocmd BufRead,BufNewFiel *mutt-*	setfiletype mail
augroup END
