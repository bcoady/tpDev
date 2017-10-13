" SECTION: Script Init {{{1
"============================================================
if exists('g:loaded_tpDevPlugin')
	finish
endif
let g:loaded_tpDevPlugin = 1


" FUNCTION: Initialize Global Variables {{{1
"============================================================
function! s:initVariable(var, default)
	if !exists(a:var)
		exec 'let ' . a:var . ' = ' . a:default
	endif
endfunction

" DEFAULTS: Dependencies {{{1
"============================================================
call s:initVariable("g:tpDevUseNERDTree", 1)
call s:initVariable("g:tpDevUseAsyncRun", 1)

" DEFAULTS: Key Mapping {{{1
"============================================================
call s:initVariable("g:tpDevPasteProgram", "\"<space>p\"")
execute "nnoremap <silent> ". g:tpDevPasteProgram ." :call tpDev#PasteProgram()<cr>"
call s:initVariable("g:tpDevCopyProgram", "\"<space>c\"")
execute "nnoremap <silent> ". g:tpDevCopyProgram ." :call tpDev#CopyProgram()<cr>"
call s:initVariable("g:tpDevTpTreeToggle", "\"<F5>\"")
execute "nnoremap <silent> ". g:tpDevTpTreeToggle ." :call tpDev#TpTreeToggle()<cr>"

" DEFAULTS: TP Key Mapping {{{1
"============================================================
call s:initVariable("g:tpDevTppDebug", "\"<space>tp\"")
call s:initVariable("g:tpDevRemark", "\"<space>r\"")
call s:initVariable("g:tpDevLsClean", "\"<space>ls\"")
call s:initVariable("g:tpDevCompileTp", "\"<F3>\"")
call s:initVariable("g:tpDevDataGrep", "\"<space>dg\"")

" DEFAULTS: TpTree Key Mapping {{{1
"============================================================
call s:initVariable("g:tpDevTpTreeOpenFold", "\"o\"")
call s:initVariable("g:tpDevTpTreeOpenAllFolds", "\"O\"")
call s:initVariable("g:tpDevTpTreeCloseFold", "\"c\"")
call s:initVariable("g:tpDevTpTreeCloseAllFolds", "\"C\"")
call s:initVariable("g:tpDevTpTreeOpenNode", "\"<cr>\"")
call s:initVariable("g:tpDevTpTreeMouseOpenNode", "\"<2-leftmouse>\"")
call s:initVariable("g:tpDevTpTreeExpand", "\"e\"")
call s:initVariable("g:tpDevTpTreeRefresh", "\"r\"")

" DEFAULTS: Locations {{{1
"============================================================
call s:initVariable("g:tpDevDirMain", "$vim")
call s:initVariable("g:tpDevDirSrc", "$vim")
call s:initVariable("g:tpDevDirBin", "$vim")

" DEFAULTS: TpTree Options {{{1
"============================================================
call s:initVariable("g:tpDevTpTreeWidth", 30)
call s:initVariable("g:tpDevMainProg", "\"a_main\"")
call s:initVariable("g:tpDevDataFile", "\"data\"")

" vim: set fdm=marker:
