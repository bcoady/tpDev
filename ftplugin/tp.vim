" Vim filetype plugin for Tp
if exists('b:loaded_tpDevFtpluginTp')
	finish
endif
let b:loaded_tpDevFtpluginTp = 1


"Generate tags after writing file
augroup AutoTP
	autocmd!
	autocmd BufWritePost *.ls :call tpDev#TagMaker()
augroup END

"Add snippets to dictionary
setlocal dictionary+=$vim\vimfiles\bundle\tpDev\snippets\tp.snippets

"Assign key mappings to buffer
execute "nnoremap <silent> <buffer> ". g:tpDevTppDebug ." :call tpDev#TppDebug()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevRemark ." :call tpDev#Remark()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevLsClean ." :call tpDev#LsClean()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevCompileTp ." :call tpDev#CompileTP()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevSetMainProg ." :call tpDev#TpTreeSetMain()<cr>"
