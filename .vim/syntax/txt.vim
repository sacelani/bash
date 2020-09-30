" ==============================================================================
" Auth: David Daub <david.daub@googlemail.com>, Alex
" Lang: Text
" Revn: 15-11-2009 Official, 09-29-2020  1.4
" Func: Define syntax coloring for .txt files when being edited in Vim
"
" TODO: very much
"       learn regex
" ==============================================================================
" CHANGE LOG
" ------------------------------------------------------------------------------
" 09-29-2020:  copy over from go.vim
"
" ==============================================================================

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif


syntax match var "\k\+" nextgroup=assignment
syntax match assignment "::" contained


hi def link var Identifier
hi def link assignment Statement


let b:current_syntax = "txt"
