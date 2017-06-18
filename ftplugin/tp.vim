" Vim filetype plugin for Tp
if exists('b:loaded_tpDevFtpluginTp')
	finish
endif
let b:loaded_tpDevFtpluginTp = 1

"Case SETTINGS
setlocal ignorecase
setlocal nosmartcase

"Generate tags after writing file
augroup AutoTP
	autocmd!
	autocmd BufEnter *.ls :call tpDev#ReplaceData()
	autocmd BufWritePost *.ls :call tpDev#TagMaker()
	autocmd BufWritePost *.ls :call tpDev#ReplaceData()
augroup END

"Add snippets to dictionary for use with AutoComplPop
let tpDevSnipLocation = expand('<sfile>:p:h:h') . "\\snippets\\tp.snippets"
execute "setlocal dictionary+=" . tpDevSnipLocation

"Assign key mappings to buffer
execute "nnoremap <silent> <buffer> ". g:tpDevTppDebug ." :call tpDev#TppDebug()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevRemark ." :call tpDev#Remark()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevLsClean ." :call tpDev#LsClean()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevCompileTp ." :call tpDev#CompileTP()<cr>"
