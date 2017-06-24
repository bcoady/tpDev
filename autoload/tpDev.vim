" SECTION: Script Init {{{1
"============================================================
if exists('g:loaded_tpDevAutoload')
	finish
endif
let g:loaded_tpDevAutoload = 1

" SECTION: Global Functions {{{1
"============================================================
" FUNCTION: TppDebug {{{2
fu! tpDev#TppDebug()
	"Removes line number's
	"Checks that headers exist
	"Fixes missing ':' & ';'
	if (&ft == 'tp')
		silent call tpDev#LsClean()
		let ctotal = 0
		let stotal = 0
		let hfail = 1
		let origView = winsaveview()
		execute "normal! gg"
		let h_prog = search("/PROG")
		let h_attr = search("/ATTR")
		let h_appl = search("/APPL")
		let h_mn = search("/MN")
		let h_pos = search("/POS")
		let h_end = search("/END")
		if (h_prog != 0) && (h_attr != 0) && (h_appl != 0) && (h_mn != 0) && (h_pos != 0) && (h_end != 0)
			let hfail = 0
		endif
		if (h_mn != 0) && (h_pos != 0)
			let h_mn += 1
			let h_pos -= 1
			let lines = getline(h_mn, h_pos)
			execute "normal!" h_mn . "gg"
			for i in lines
				execute "normal! 0vl\"ay"
				if (@a != ":")
					execute "normal! 0i:"
					let ctotal += 1
				endif
				execute "normal! 0lvl\"by"
				execute "normal! $vl\"cy"
				if (@b != "C") && (@c != ";") && (i !~ "--eg")
					execute "normal! $a;"
					let stotal += 1
				endif
				execute "normal! j"
			endfor
		endif
		let etotal = (stotal + ctotal + hfail)
		echom "TppDebug Report:"
		if (etotal == 0)
			echom "Nice work Slick!"
		endif
		if (ctotal !=0)
			echom ctotal "colon errors fixed!"
		endif
		if (stotal !=0)
			echom stotal "semicolon errors fixed!"
		endif
		if (hfail == 1)
			echoerr "Did not find all headers!"
		endif
		call winrestview(origView)
	endif
endfunction

" FUNCTION: Remark {{{2
fu! tpDev#Remark()

	silent call tpDev#LsClean()
	if (&ft == 'tp')
		let origLine = line('.')
		let @a = ""
		let @b = ""
		let @c = ""
		let @d = ""
		execute "normal! ^V\"ay"
		execute "normal! " . origLine . "gg"
		execute "normal! ^vl\"by"
		execute "normal!" . origLine . "gg"
		if (strlen(@a) > 2) && (@b == ":")
			execute "normal! ^wvll\"cy"
			execute "normal!" . origLine . "gg"
			execute "normal! ^lvll\"dy"
			execute "normal!" . origLine . "gg"
			if (@c == "//")
				execute "normal! ^wxx"
			elseif (@d == "//")
				execute "normal! ^lxx"
			else
				execute "normal! ^wi//"
			endif
		endif
		execute "normal! \<esc>"
		execute "normal!" . origLine . "gg"
		execute "normal! 0"
	endif
endfunction

" FUNCTION: LsClean {{{2
"Removes line numbers from imported ls files
fu! tpDev#LsClean()
	if (&ft == 'tp')
		let origView = winsaveview()
		let hfail = 1
		execute "normal! gg"
		let h_mn = search("/MN")
		let h_pos = search("/POS")
		if (h_mn != 0) && (h_pos != 0)
			let hfail = 0
			let h_mn += 1
			let h_pos -= 1
			let lines = getline(h_mn, h_pos)
			execute "normal!" h_mn . "gg"
			for i in lines
				execute "normal! 0"
				let curLine = line('.')
				let colSearch = search(':', 'c', curLine)
				let position = getcurpos()
				if (colSearch == curLine && position[2] != 1)
					execute "normal! v0d"
				endif
				let curLine += 1
				execute "normal" curLine . "gg"
			endfor
		endif
		echom "LsClean Report:"
		if (hfail != 0 )
			echoerr "Did not find headers!"
		else
			echom "We don't need no stinking numbers!"
		endif
		call winrestview(origView)
	endif
endfunction

" FUNCTION: CompileTP {{{2
"Compiles current .ls file into bin directory
fu! tpDev#CompileTP()
	if (&ft == 'tp')
		w

		echom "Starting MakeTP"
		execute 'cd' g:tpDevDirMain

		if g:tpDevUseAsyncRun
			execute "AsyncRun maketp \"" . expand('%:p') . "\" \"" .  g:tpDevDirBin . "\""
			copen
			wincmd p
		else
			execute "!maketp \"" . expand('%:p') . "\" \"" .  g:tpDevDirBin . "\""
		endif
	endif
endfunction

" FUNCTION: CopyProgram {{{2
fu! tpDev#CopyProgram()
		let g:tpDevCopyPath = expand('%:p')
		let g:tpDevCopyName = expand('%:t')
		let g:tpDevCopyExt = expand('%:e')
		echom g:tpDevCopyName . " is copied to the clipboard."
endfunction

" FUNCTION: PasteProgram {{{2
fu! tpDev#PasteProgram()
   	call inputsave()
    	let newName = input("Type new name or press enter to keep \"" . g:tpDevCopyName . "\":")
   	call inputrestore()

	if newName == ""
		let newName = g:tpDevCopyName
	elseif s:GetExtension(newName) == ""
		let newName = newName . "." . g:tpDevCopyExt
	endif

	let pastePath = getcwd() . "\\" . newName

	execute "silent ! copy \"" . g:tpDevCopyPath . "\" \"" . pastePath . "\""
	wincmd b
	execute "e " . pastePath
	if (newName =~ expand('%:t') && &ft == 'tp')
		let progName = toupper(expand('%:t:r'))
		execute "normal! gg2wC" . progName
	endif
	update
endfunction

" FUNCTION: TreeRefresh {{{2
fu! tpDev#TreeRefresh()
	call s:TreeMain(1)
endfunction

" FUNCTION: TpTreeToggle {{{2
fu! tpDev#TpTreeToggle()
	call s:TreeMain(0)

endfunction

" FUNCTION: TreeExpand {{{2
fu!	tpDev#TreeExpand()
	call s:HiddenStart()

	if (&ft == 'TpTree')
		
		call s:GetSetCD()
		if foldclosed('.') > 0
			execute "normal! zo"
		endif

		execute "normal! 0"
		let curWord = expand("<cword>")

		if !s:TreeItemIsRecursive() && curWord !~ g:tpDevMainProg
			let origLine = line('.')
			let curIndent = foldlevel('.')
			execute "normal! j"
			let nextIndent = foldlevel('.')
			execute "normal!" . origLine . "gg"

			if (curIndent >= nextIndent)
				setlocal modifiable
				call s:TreeExpandInternal()
				call s:SyntaxLoopChildren()
				call s:RefreshUnlisted()
				execute "normal!" . origLine . "gg"
				w
				setlocal nomodifiable
			endif
		endif
	endif
	call s:HiddenEnd()
endfunction

" FUNCTION: TagMaker {{{2
fu! tpDev#TagMaker()
	if (&ft == 'tp')
		let cur_dir = s:GetSetCD()
		let origFile = expand('%:t')
		let origView = winsaveview()
		
		let tagread = s:GetFileList()
		e tags
		
		normal! ggdG
		let item_cnt=0
		for item in tagread
			"set file name/type filters
			if (item != 'tags')  && (item !~ '\.swp') && (item !~ '\~') && (item =~ '.ls')
				call append(item_cnt, item . "\<tab>" . item . "\<tab>" . "/" . item)
				let item_cnt += 1
				execute "normal!" item_cnt . "gg"
				"Trim ext on tag name
				execute "normal! 0wde"
				execute "normal!" item_cnt . "gg"
				"Uppercase Tag name
				execute "normal! 0vwU"
				execute "normal!" item_cnt . "gg"
				"Trim ext on tag command
				execute "normal! $2bde"
				execute "normal!" item_cnt . "gg"
				"Uppercase tag command
				execute "normal! $bvwU"
			endif
		endfor

		update
		execute "e " . origFile
		call winrestview(origView)
	endif
endfunction

" FUNCTION: TreeNodeOpen {{{2
fu! tpDev#TreeNodeOpen()
	let openProg = expand('<cword>') . ".ls"
	let curDir = s:GetSetCD()
	if filereadable(openProg) 
		let curWin = winnr()
		wincmd b
		let rightWin = winnr()
		execute "cd " . curDir
		if rightWin == curWin
			exec "vsplit " . openProg
		else
			exec "e " . openProg
		endif
	endif



endfunction

" FUNCTION: TreeEnter {{{2
fu! tpDev#TreeEnter()
	setlocal nomodifiable
	let curWin = winnr()
	wincmd b
	let rightWin = winnr()
	if rightWin == curWin
		vnew
	endif
	exe curWin . "wincmd w"
	execute "vert resize" . g:tpDevTpTreeWidth

endfunction


" FUNCTION: ReplaceData {{{2
fu! tpDev#ReplaceData()
	let origFile = expand('%:t')
	let origLine = line('.')

	let DataFile = s:FindDataFile()
	if DataFile != ""
		execute "e " . DataFile
		execute "normal! gg"
		execute "normal! 0"
		let xlist = []
		let lnum = 1
		let lastLine = line('$')
	
		"Build array of Data Variables
		while (lnum <= lastLine)
			let templist = []
			let CurLine = line('.')

			"Skip if line doesn't contain 5 words
			execute "normal! 4w"
			if line('.') == CurLine
				execute "normal! 0"
	
	
				let tempword0 = expand("<cword>")
				execute "normal! 2w"
				let tempword1 = expand("<cword>")
				execute "normal! 2w"
				let tempword2 = expand("<cword>")
	
				"Verify correct data format
				if tempword0 =~ '^\a\+$' && tempword1 =~ '^\d\+$' && tempword2 =~ '^\w\+$'
					call add(templist, tempword0)
					call add(templist, tempword1)
					call add(templist, tempword2)
	
					call add(xlist, templist)

				endif
			endif

			execute "normal! " . CurLine . "gg"
			execute "normal! j"
			execute "normal! 0"
			let lnum += 1
		endwhile
	
		execute "e " . origFile
	
		"Iterate through each variable
		let listLength = len(xlist)
		let item = 0
		while item < listLength
	
			let listi = xlist[item]
			if len(listi)==3
				let listType = listi[0]
				let listNum = listi[1]
				let listComment = listi[2]

	
				"Find data without numbers
				execute "silent" ':%s/\(\A\)' . listType . '\[' . listComment . '\]/\1'  . listType . '\[' . listNum . ':' . listComment . '\]/gei'

				"Find elemental PR's without numbers
				execute "silent" ':%s/\(\A\)' . listType . '\[' . listComment . ',\(\d\)\]/\1'  . listType . '\[' . listNum . ',\2:' . listComment . '\]/gei'

				"Find data without comments
				execute "silent" ':%s/\(\A\)' . listType . '\[' . listNum . '\]/\1' . listType . '\[' . listNum . ':' . listComment . '\]/gei'

				"Find elemental PR's without comments
				execute "silent" ':%s/\(\A\)' . listType . '\[' . listNum . ',\(\d\)\]/\1' . listType . '\[' . listNum . ',\2:' . listComment . '\]/gei'

				"Update comments
				execute "silent" ':%s/\(\A\)' . listType . '\[' . listNum . '\:.\{-}\]/' . '\1' . listType . '\[' . listNum . ':' . listComment . '\]/gei'

				"Update comments for elemental PR's
				execute "silent" ':%s/\(\A\)' . listType . '\[' . listNum . ',\(\d\)\:.\{-}\]/' . '\1' . listType . '\[' . listNum . ',\2:' . listComment . '\]/gei'


			endif
	
			let item += 1
		endwhile
	
		execute "normal! " . origLine . "gg"
	
	endif
	
	
endfunction

" SECTION: Local Functions {{{1
"============================================================
" FUNCTION: TreeMain {{{2
fu!	s:TreeMain(refresh)

	call s:HiddenStart()

	" Toggle between TpTree and NerdTree
	let bnr = bufwinnr('*.TpTree')
    	if (bnr > 0 && a:refresh == 0)
       		execute bnr . " close" 
		if g:tpDevUseNERDTree
			NERDTree
		endif

    	else
		
		let MainProg = ""

		let origWin = winnr()
		wincmd b
		let origFile = expand('%:t')
		let cur_dir = s:GetSetCD()
		execute origWin . " wincmd w"

		execute "cd " . cur_dir

		let fileList = s:GetFileList()

		let MainProg = s:FindMainProg(fileList)

		if (MainProg != "")

			let mainTag = toupper(MainProg)
			let mainTag = s:StripExtension(mainTag)
			let g:tpDevMainProg = mainTag

			execute "e " . MainProg

			let TreeList = s:TreeBuild()

			"Create Structure file
			setlocal nosplitright
			vsplit a_main.TpTree
			setlocal splitright
			setlocal modifiable
			execute "normal! ggdG"

			call append(0, "===========================")
			call append(0, TreeList)
			execute "normal! Gdd"
			call s:TreeExpandFirst()
			call append(0, "===========================")
			call append(0, mainTag)
			call append(0, "===========================")
			call append(0, "========   Tree   ========")
			call append(0, "==========  TP  ==========")
			call s:SyntaxLoopInit(fileList)

			let unusedList = s:GetUnusedPrograms(fileList)
			if len(unusedList) > 0
				setlocal modifiable
				call append(line('$'), "======== Unlisted: ========")
				call append(line('$'), unusedList)
			endif

			execute "normal! gg"
			execute "normal! zM"
			update
			setlocal nomodifiable

			let totalWin = winnr('$')
			let winCnt = totalWin-1
			while winCnt > 0
				execute winCnt . " wincmd w"
				if (&ft != 'TpTree')
					execute "silent " . winCnt . " close!"
				endif
				let winCnt -= 1
			endwhile

			wincmd b
			if (&ft != 'TpTree' && origFile != '')
				execute "b " . origFile
			endif

			execute "1 wincmd w"
			execute "vert resize" . g:tpDevTpTreeWidth
			setlocal winfixwidth
		else
			echoerr "Did not find " . g:tpDevMainProg . " program!"

		endif
    	endif

	call s:HiddenEnd()
endfunction

" FUNCTION: FindDataFile {{{2
fu!	s:FindDataFile()
	
	let fileList = s:GetFileList()
	let DataFile = ""
	let DataFileRegex = g:tpDevDataFile . ".*\.csv$"
		for item in fileList
			if (item =~ DataFileRegex)
				let DataFile = item
			endif
		endfor

	return DataFile
endfunction

" FUNCTION: FindMainProg {{{2
fu!	s:FindMainProg(fileList)
	
	let MainProg = ""
	let mainProgRegex = g:tpDevMainProg . ".*\.ls$"
		for item in a:fileList
			if (item =~ mainProgRegex)
				let MainProg = item
			endif
		endfor

	if (MainProg == "") && (&ft == 'tp') && (expand('%:t') =~ ".*\.ls$")
			let MainProg = expand('%:t')
	endif
	return MainProg
endfunction

" FUNCTION: TreeBuild {{{2
fu!	s:TreeBuild()
		execute "normal! gg"
		let h_mn = search("/MN")
		let h_mn +=1
		let h_pos = search("/POS")
		let h_pos -= 1
		let lines = getline(h_mn, h_pos)
		let TreeList = []
		execute "normal!" h_mn . "gg"
		for i in lines
			if (i !~ ':  !') && (i !~ '--eg:') && ((i =~ 'CALL ') || (i =~ 'RUN '))
				if (i =~ 'CALL')
					let CallType = 'CALL '
				else
					let CallType = 'RUN '
				endif
				let CurLine = line('.')
				execute "normal!" CurLine . "gg"
				let testline = search(CallType, '', line('.'))
				execute "normal! wve\"ay"
				call add(TreeList, @a)
			endif
			execute "normal! j"
		endfor

		return TreeList
endfunction


" FUNCTION: TreeExpandInternal {{{2
fu!	s:TreeExpandInternal()
	if (&ft == 'TpTree')
		let CurWord = expand("<cword>")
		let Depth = foldlevel('.')
		let Branch = "  "
		let i = 0
		while i < Depth
			let i+= 1
			let Branch = Branch . "  "
		endwhile


		if filereadable(CurWord . ".ls") 

			execute "e " . CurWord . ".ls"

			let TreeList = s:TreeBuild()
			let branchTree = []
			for item in TreeList
				call add(branchTree, Branch . item)
			endfor
			b a_main.TpTree
			setlocal modifiable
			call append(line('.'), branchTree)
		endif

	endif

endfunction

" FUNCTION: TreeExpandFirst {{{2
fu!	s:TreeExpandFirst()
		execute "normal! G"
		let lnum = line('$')
		while (lnum > 0)
			if (foldlevel('.') == 0)
				call s:TreeExpandInternal()
			endif
			let lnum -= 1
			execute "normal! k"
		endwhile

endfunction

" FUNCTION: TreeItemIsRecursive {{{2
fu! s:TreeItemIsRecursive()
	let origLine = line('.')
	let origString = expand("<cword>")
	let isRecursive = 0
	let origIndent = foldlevel('.')
	let curIndent = origIndent
	let lastIndent = curIndent
	let parents = []

	if (origLine != 1) && (curIndent != 0)
		while (curIndent != 0)
			if curIndent < lastIndent
				let lastIndent = curIndent
			endif

			execute "normal! k"
			let curIndent = foldlevel('.')

			if (curIndent < lastIndent)
				execute "normal! 0"
				let tempString = expand("<cword>")
				call add(parents, tempString)
			endif
		endwhile

		for item in parents
			if (item =~ origString)
				let isRecursive = 1
			endif
		endfor
	endif

	execute "normal!" . origLine . "gg"

	return isRecursive

endfunction

" FUNCTION: SyntaxLoopWork {{{2
fu! s:SyntaxLoopWork(fileList)
	execute "normal! ^"

	if !s:IsTreeHeader()
		if s:TagCheck(a:fileList)
			execute "normal! $a."
			execute "normal! ^"
			if s:TreeItemIsRecursive()
				execute "normal! $a<"
				execute "normal! ^"
			endif
			if s:NoChildren()
				execute "normal! $a]"
				execute "normal! ^"
			endif
		endif
	endif
endfunction

" FUNCTION: SyntaxLoopChildren {{{2
fu! s:SyntaxLoopChildren()
	setlocal modifiable

	let fileList = s:GetFileList()
	let origLine = line('.')
	let parentLevel = foldlevel('.')
	let childLevel = parentLevel+1
	execute "normal! j"
	let curLevel = foldlevel('.')


	while (curLevel == childLevel)
		call s:SyntaxLoopWork(fileList)
		if (line('.') == line('$'))
			break
		endif
		execute "normal! j"
		let curLevel = foldlevel('.')
	endwhile

	execute "normal!" . origLine . "gg"

	setlocal nomodifiable

endfunction

" FUNCTION: SyntaxLoopInit {{{2
fu! s:SyntaxLoopInit(fileList)
	setlocal modifiable

	let lnum = 1

	while (lnum <= line('$'))
		execute "normal!" . lnum . "gg"
		call s:SyntaxLoopWork(a:fileList)
		let lnum += 1
	endwhile
	setlocal nomodifiable

endfunction

" FUNCTION: GetUnusedPrograms {{{2
fu! s:GetUnusedPrograms(fileList)

	let lnum = 1
	let unusedList = []
	let usedList = []

	while (lnum <= line('$'))
		execute "normal!" . lnum . "gg"
		call add(usedList, expand('<cword>'))
		let lnum += 1
	endwhile

	for fileItem in a:fileList
		if s:GetExtension(fileItem) == "ls"
			let unused = 1
			for wordItem in usedList
				if fileItem =~ wordItem
					let unused = 0
				endif
			endfor
			if unused
				call add(unusedList, "  " . fileItem)
			endif
		endif
	endfor

	return unusedList

endfunction

" FUNCTION: RefreshUnlisted {{{2
fu! s:RefreshUnlisted()
	let unlistedStart = search("Unlisted:")
	if unlistedStart > 0
		let unlistedStart += 1
		let unlistedStart = search("Unlisted:") + 1
		execute "normal! " . unlistedStart . "gg"
		setlocal modifiable
		execute "normal! dG"
		let fileList = s:GetFileList()
		let unusedList = s:GetUnusedPrograms(fileList)
		if len(unusedList) > 0
			call append(line('$'), unusedList)
		endif
	endif
endfunction

" FUNCTION: TagCheck {{{2
fu! s:TagCheck(fileList)
	let curWord = expand("<cword>")
	let curFile = curWord . ".ls"
	let isTag = 0
	for item in a:fileList
		if (item == curFile)
			let isTag = 1
		endif
	endfor
	return isTag
endfunction

" FUNCTION: IsTreeHeader {{{2
fu! s:IsTreeHeader()
	let curLine = getline('.')
	let isHeader = 0
	if (curLine =~ '^=.*=$')
		let isHeader = 1
	endif
	return isHeader
endfunction

" FUNCTION: NoChildren {{{2
fu! s:NoChildren()
	let TreeList = []
	let curWord = expand("<cword>")
	if filereadable(curWord . ".ls") 

		execute "e " . curWord . ".ls"
		let TreeList = s:TreeBuild()
		b a_main.TpTree
		setlocal modifiable
	endif
	return (empty(TreeList))
	
endfunction

" FUNCTION: GetFileList {{{2
fu! s:GetFileList()
	return split(system('dir /A:-D /b'))
endfunction


" FUNCTION: StripExtension {{{2
fu! s:StripExtension(name)
	let inputName = a:name
	let nameSplit = split(inputName, '\.')
	if len(nameSplit) > 1
		let inputName = nameSplit[0]
	endif
	return inputName
endfunction

" FUNCTION: GetExtension {{{2
fu! s:GetExtension(name)
	let inputName = a:name
	let nameSplit = split(inputName, '\.')
	if len(nameSplit) > 1
		let extIndex = len(nameSplit) - 1
		let ext = nameSplit[extIndex]
	else
		let ext = ""
	endif
	return ext
endfunction

" FUNCTION: GetSetCD {{{2
fu! s:GetSetCD()
	let curDir = expand('%:p:h')
	execute "cd " . curDir
	return curDir
endfunction

" FUNCTION: HiddenStart {{{2
fu! s:HiddenStart()
	let g:tpDevHiddenSet = &hidden
	set hidden
endfunction

" FUNCTION: HiddenEnd {{{2
fu! s:HiddenEnd()
	if !g:tpDevHiddenSet
		set nohidden
	endif
endfunction

" vim: set fdm=marker:
