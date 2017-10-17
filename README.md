# tpDev

A Vim plugin for the Fanuc TP language

  TpDev creates a development environment for programming Fanuc robots
using the TP (teach pendant) language. This includes syntax highlighting,
code snippets, tags, data commenting, data & IO cross referencing, debugging,
compiling, and viewing the program call structure. Some features are dependent
on 3rd party plugins or software. Some features use the Windows command line.
No current intentions to adapt to other OS, but open to forks. 

## Installing

- Install [pathogen](http://www.vim.org/scripts/script.php?script_id=2332) into `\vimfiles\autoload` and add the
   following line to your `_vimrc`:

        call pathogen#infect()

 - Clone or copy tpDev into `vimfiles\bundle`

## Dependencies (some can be disabled):

 - 	Windows		Command line is used for: Tag generation, Copy/Paste
			Programs, TpTree Generation, Compiling programs

 - 	[NERDTree](https://github.com/scrooloose/nerdtree)
			Enabled by default, to disable:
			set g:tpDevUseNERDTree = 0

 - 	[AsyncRun](https://github.com/skywind3000/asyncrun.vim)
			Enabled by default, to disable:
			set g:tpDevUseAsyncRun = 0

 - 	[SnipMate](https://github.com/garbas/vim-snipmate)
			Required to use built in code snippets
			Is automatically disabled if SnipMate is not installed
			Code snippets located in tpDev\snippets\tp.snippets
			
 - 	[MakeTP](http://robot.fanucamerica.com/)
			Command line utility required to compile tp programs. 
			Must be acquired from Fanuc by purchasing RoboGuide or OLPCPro.

 - 	[AutoComplPop](https://github.com/vim-scripts/AutoComplPop)
			Optional but recommended
			Very useful for autocompleting of words and code snippets

## Help
  	in Vim	`:help tpDev`

	Example vimrc setup:
	----------------
	"TpDev Settings
	let g:tpDevDirMain = 'C:\Users\name\Projects'
	let g:tpDevDirSrc = 'C:\Users\name\Projects\source'
	let g:tpDevDirBin = 'C:\Users\name\Projects\binary'

	"NERDTree settings
	let NERDTreeIgnore=['tags$', '\~$', '/*.TpTree']
	
	"SnipMate settings
 	 "Shows available snippets
	imap '<tab> <c-r><tab>
 	 "insert real tab
	imap <c-tab> <c-q><tab>

	"Tag Jumps except in special windows
	au FileType * :call TagMap()
	function! TagMap()
		if &ft isnot 'qf' && &ft isnot 'nerdtree'
			nnoremap <buffer> <cr> <c-]>
			nnoremap <buffer> <c-cr> <c-T>
		endif

	"VIM internal caps lock <c-^>
	"TP files default to all caps by default
	for c in range(char2nr('A'), char2nr('Z'))
	  execute 'lnoremap ' . nr2char(c+32) . ' ' . nr2char(c)
 	 execute 'lnoremap ' . nr2char(c) . ' ' . nr2char(c+32)
	endfor
	set iminsert=0 " Caps lock normally off
	au FileType tp setlocal iminsert=1
	au FileType vim setlocal iminsert=0
	imap .cl <C-^>
	nmap .cl V~


## License ##

  TpDev is released under the MIT license.
  See https://opensource.org/licenses/MIT
