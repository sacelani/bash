" ==============================================================================
" Auth: Alex Celani
" Lang: Text
" Revn: 10-01-2020  1.2
" Func: Define syntax coloring for .txt files when being edited in Vim
"
" TODO: very much
"       learn regex
" ==============================================================================
" CHANGE LOG
" ------------------------------------------------------------------------------
" 09-29-2020:  copy over from go.vim
" 10-01-2020:  made my own quote regex
"              made comment
"              added link to list of group names and their colors
"
" ==============================================================================

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" quotes should exist between odd pairs of quotation marks
" eg| "quote" not
"     "quote" not "quote"
"     "not
"     quote"
" 
" the first and last quote define the expression
"  \ is the escape character, so \" means I want to look for a quote
"  . is every non-new line character possible
"  \{,} is \{0,infinity}, means I'm looking for between 0 and infinity
"      matches for the previous character, which is a wildcard, .
"  \{-,} means that it prioritizes the smallest amount of matches possible
syn match quote "\".\{-,}\""

" comments come after #
" eg| not comment  # now a comment
"     # comment
"     not a comment
"     not
"     not
"                     ### comment
"
" first and last quote define the expression
" # can come literally, because it doesn't need escaping
" . is every non-new line character possible
" * matches as many matches as possible
" i.e. a pound sign, and then as many characters as possible
syn match comment "#.*"



" For a list of Color Structures, try :help group-name
hi def link quote Constant
hi def link comment Comment

let b:current_syntax = "txt"
