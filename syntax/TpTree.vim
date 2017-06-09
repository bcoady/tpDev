" Vim syntax file
" Language: TpTree
" Author:   Ben Coady

if exists("b:current_syntax")
  finish
endif

if version < 600
  syntax clear
endif


"Heading
syn match	heading		/^=.*=$/
hi def link	heading		Comment


"Stops
syn match	stopRec		/.*<$/
hi def link	stopRec		Define

syn match	stopEnd		/.*\]$/
hi def link	stopEnd		Type

"Tags
syn match	noTag		/.*\.$/
hi def link	noTag		Special


let b:current_syntax = "TpTree"
