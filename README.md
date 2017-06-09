# tpDev

A Vim plugin for the Fanuc TP language

  TpDev creates a development environment for programming Fanuc robots
using the TP (teach pendant) language. This includes syntax highlighting,
code snippets, tags, debugging, compiling, and viewing the program call structure.
Some features are dependent on 3rd party plugins or software. Some
features use the Windows command line. No current intentions to adapt to
other OS, but open to forks. 

## Installing

- Install [pathogen](http://www.vim.org/scripts/script.php?script_id=2332) into `\vimfiles\autoload` and add the
   following line to your `_vimrc`:

        call pathogen#infect()

 - Clone or copy tpDev into `vimfiles\bundle`

## Dependencies (some have option to disable):

 - 	Windows		Command line is used for: Tag generation, Copy/Paste
			Programs, TpTree Generation, Compiling programs

 - 	NERDTree	https://github.com/scrooloose/nerdtree
			Enabled by default, to disable:
			set g:tpDevUseNERDTree = 0

 - 	AsyncRun	https://github.com/skywind3000/asyncrun.vim
			Enabled by default, to disable:
			set g:tpDevUseAsyncRun = 0

 - 	SnipMate	https://github.com/garbas/vim-snipmate
			Required to use built in code snippets
			Is automatically disabled if SnipMate is not installed
			Code snippets located in tpDev\snippets\tp.snippets
			
 - 	MakeTP		http://robot.fanucamerica.com/
			Command line utility required to compile tp programs. 
			Must be acquired from Fanuc by purchasing RoboGuide or OLPCPro.

 - 	AutoComplPop	https://github.com/vim-scripts/AutoComplPop
			Optional but recommended
			Very useful for autocompleting of words and code snippets

## Help

  in Vim	`:help tpDev`

## License ##

MIT
