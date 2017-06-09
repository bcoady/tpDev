" Vim filetype plugin for TpTree
if exists('b:loaded_tpDevFtpluginTpTree')
	finish
endif
let b:loaded_tpDevFtpluginTpTree = 1

" Set buffer view options
setlocal shiftwidth=2
setlocal foldmethod=indent
setlocal foldcolumn=2
setlocal foldtext=('')
setlocal nonu
setlocal nospell
setlocal nowrap
setlocal splitright
setlocal foldminlines=0

" Reformat view when entering buffer
augroup AutoTpTree
	autocmd!
	autocmd BufEnter *.TpTree :call tpDev#TreeEnter()
augroup END


"Assing key mapping to buffer
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeOpenFold ." zo"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeOpenAllFolds ." zR"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeCloseFold ." zc"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeCloseAllFolds ." zM"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeOpenNode ." :call tpDev#TreeNodeOpen()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeMouseOpenNode ." :call tpDev#TreeNodeOpen()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeExpand ." :call tpDev#TreeExpand()<cr>"
execute "nnoremap <silent> <buffer> ". g:tpDevTpTreeRefresh ." :call tpDev#TreeRefresh()<cr>"

"un-map tag jumping
nmap <buffer> <c-leftmouse> <nop> 
nmap <buffer> <c-rightmouse> <nop> 
nmap <buffer> <c><cr> <nop> 
