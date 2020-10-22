" ====================================================================
" Auth: Alex Celani
" Lang: Text
" Revn: 10-16-2020  1.5
" Func: Define syntax coloring for .txt files when being edited in Vim
"
" TODO: make comments create new comments on line overrun and newline
"       add highlighting for titles, vocab words, definitions
"       create a better template file showing all the highlighting
"       get term=underline working to avoid using link statements
" ====================================================================
" CHANGE LOG
" --------------------------------------------------------------------
" 09-29-2020:  copy over from go.vim
" 10-01-2020:  gutted entire file
"              made my own quote regex
"              made comment
"              added link to list of group names and their colors
" 10-02-2020:  rewrote quotes to allow multiline quotes with rollover
"              added recognition for numbers
"              separated numbers into numbers and numbers in quotes
"              added date recognition, underlines dates in change log
"              made comments recognize Auth, Lang, Revn, Func, Todo
"              underline Auth, Lang, Revn, Func, Todo, and Change Log
"              recognized fields, the field delimiter (::), and
"                   property delimiter (->)
"              added tags for notes to self, and the body of such
"              began writing something to passively color body
"              colored things Norse things green, and Russian red
"              added Color Guide, and source
"              changed some colors up a bit
"              made property delimiter of variable length, also use =>
" 10-03-2020:  added reminded to color explicitly in Todo
" 10-11-2020:  replaced most links with explicit ctermfg statements
"              added expressions, names, operations
"              changed some colors up a bit
"              shortened lines down to <= 70 characters
" 10-16-2020:  added Norge to norwegian words
"              added spaces around = in expression to avoid confusion
"                   with => marker
"              changed noteTag color from DkRed to Red to match notes
"              added <> region
"              added i, j, e, pi as numbers
"
" ====================================================================

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif


" XXX Expressions:
" highlight equations, formulas, expressions, etc
" expressions: .* is any number of characters
"              = is literal
"              .* is any number of characters again
"              added spaces around = to avoid confusion with =>
"              
"              the idea is that it's stuff that equals stuff, and we
"              worry about what it is later
" name: \c case-escapes the sequence
"       \a is alphabetic characters, probably don't need escaping
"       \+ is at least 1 match, so it's 1 or more letters is a name
" name: \c\a\=  is 0 or 1 case-escaped alphabetic characters
"       _       is literal, best I can get to subscripts
"       \a\+    is 1 or more case-escaped alphabetic characters
" op: inside [] can allow for one choice from any contained characters
"     =, +, -, /, ^ are all literals for operations
"     \* escapes the * character, which is now multiplication
" Num: see Numbers: below
" FIXME try to make name into one thing, probably with \{,1}
syn match expression ".* = .*" contains=name,op,num skipwhite
syn match name "\c\a\+" contained
syn match name "\c\a\=_\a\+" contained
syn match op "[=+-/^\*]" contained


" XXX Quotes:
" quotes should exist between odd pairs of quotation marks
" eg| "quote" not
"     "quote" not "quote"
"     "not
"     quote"
"     "quote only if the it rolls
"     over onto the next line"
" Calling the quotation a region instead of pattern match makes it
" easier to wrap around a new line
" the first and last quote define the expression
" \ escapes the next character, allowing \" to appear as a literal "
" thus, start and end are both quotes, and the reqion can span lines
" added contains num on the off chance I want to embed a number
" added contains for norwegian and russian for the hell of it
syn region quote start="\"" end="\"" contains=numQuote,norwegian,russian
"  -- DEPRECATED --
" the first and last quote define the expression
"  \ is the escape character, so \" means I want to look for a quote
"  . is every non-new line character possible
"  \{,} is \{0,infinity}, means I'm looking for between 0 and infinity
"       matches for the previous character, which is a wildcard, .
"  \{-,} will prioritize the smallest amount of matches possible
" syn match quote "\".\{-,}\""
"  -- DEPRECATED --


" XXX Unnamed Field:
" match, because it should really only span one line
" < and > are literals
" .* means any character any number of times
" contains numQuote
syn match unnamed "<.*>" contains=numQuote


" XXX Numbers:
" num and numQuote allow for the coloring of numbers. numQuote exists
" for the sole purpose of coloring numbers differently for when
" they're inside of a quote, thus the contained keyword for numQuote
" the first and last quote define the expression
" - is the negative symbol, \? allows for 0 or 1 matchings, which
"       allows for negative numbers
" \d is any digit [0-9], \+ is 1 or more matches, which means there
"       MUST be at least one number for a match to be seen
" \a is any letter [a-zA-Z], * allows any number of them for variables
" \. escapes the . character so decimal points can be represented
" \? allows 0 or 1 matches of \., because number only have 1 decimal
" \d for numbers after the decimal
" * for any number of matches, using \+ (one or more matches) would
"       have only allowed for 2 digit numbers minimum
" i, j, e, pi are all common numbers
syn match numQuote "-\?\d\+\a*\.\?\d*" contained
syn keyword numQuote j i e pi contained
syn match num "-\?\d\+\a*\.\?\d*"
syn keyword num j i e pi



" XXX Dates:
" Date highlighting for the Change Log
" the first and last quote define the expression
" \d is any digit [0-9]
" \{1,2} matches 1 or 2 times, although it should only ever get 2
" - literal hyphen, which seperates months, days, and years
" The same three elements are repeated again for the days
" \d is any digit, used again for the years
" \{4} for only four digits can be matched
" ends with : because only dates in change log should be highlighted
" marked as contained, as it should only be highlighted in comments
" contains colon, so I can highlight the color separately
" for some reason, the colon doesn't work as keyword, so simple match
syn match date "\d\{1,2}-\d\{1,2}-\d\{4}:" contained contains=colon
syn match colon ":" contained


" XXX Comments:
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
syn match comments "#.*" contains=commentFields,commentTodo,date,norwegian,russian
" commentFields and commentTodo are contained within comments, so they
" are as such in the definition of a comment, and listed as contained
" in their own definitions
" commentFields is match instead of keyword, will contain the space
syn keyword commentFields contained Auth Revn File Func
syn keyword commentTodo contained TODO
syn match commentFields contained "CHANGE LOG"


" XXX Fields:
" Denotes properties, things that are of importance
" first and last quote define the expression
" . is any character
" * is any number of that character
" :: is the literal characters '::', which denotes the property
" Using nextgroup would have been better praxis, but this works
" After, denote the delimiter as own syntax element to color uniquely
" FIXME: make this better with nextgroup
syn match fields ".*::" contains=delim
syn match delim "::"

" XXX Properties:
" Denotes a property of a field
" -\+ is one or more hyphens
" =\+ is one or more equals signs
" > is a literal
syn match properties "-\+>"
syn match properties "=\+>"


" XXX Notes:
" Allow for notes to be left with special highlighting
" \c escapes the case, so search is entirely case insensitive
" note are all literals
" s\? will alow for either 0 or 1 of the character "s" to be matched,
"       essentially allowing for both notes and note
" finally followed by a colon
" nextgroup is the actual notes to be taken, as this is just the tag
syn match noteTag "\cnotes\?:" nextgroup=notes
" define notes as starting with space, ending with exclamation mark
" if it's not denoted as contained, then the whole damn thing will be
"       highlighted
syn region notes start=" " end="!" contained


" FIXME Body:
" This is the rest of the text
" I found out with notes, if this isn't given as contained, it'll just
"       highlight everything
"syn region body start=" " end=" "


" XXX Norwegian:
" XXX Russian:
" lmfao ignore case sensitivity to avoid writing things twice
" Highlight norwegian shit green
syn case ignore
syn keyword norwegian   nordic nordics
syn keyword norwegian   norse
syn keyword norwegian   norway
syn keyword norwegian   norge
syn keyword norwegian   norsk
syn keyword norwegian   norwegian norwegians
" Highlight Russian shit red
syn keyword russian     russian russians
syn keyword russian     rusky ruskies
syn keyword russian     russia
syn keyword russian     slav slavs
syn keyword russian     slavic
syn case match
" lmfao and turn the case sensitivity back on



" ColorGuide: ctermfg and ctermbg args - - - - source:: :help cterm
" Black
" LightBlue/Cyan/LightCyan, Blue/DarkBlue/DarkCyan
" Green/LightGreen, DarkGreen
" Red/LightRed, DarkRed
" Magenta/LightMagenta, DarkMagenta
" Yellow/LightYellow, DarkYellow/Brown
" White
" Gray/LightGray, DarkGray
" ColorGuide: ctermfg and ctermbg args - - - - source:: :help cterm
" ColorGuide: - - - - - - - - - - - - - - - source:: :help group-name
" Dates and fields in comments still use links for highlighting to get
" access to 'term' arguments that don't want to load correctly, namely
" Underline     -> PreProc (Magenta in default colo), with underline 
" ColorGuide: - - - - - - - - - - - - - - - source:: :help group-name


" XXX Coloring:
" hi[ghlight] <group> ctermfg=<color> [ctermbg=<color>]
" group is typically a user-made group
" ctermfg is the foreground, or font color
" ctermbg is the background color, or highlight color

" Note: Keep ctermfg for expression and op the same value
hi expression ctermfg=Blue
hi name ctermfg=LightGreen
hi op ctermfg=Blue
hi num ctermfg=Magenta

hi unnamed ctermfg=Magenta
hi quote ctermfg=DarkRed
hi numQuote ctermfg=Green

hi comments ctermfg=Green
" I want the underlines, but I can't figure out how to make them work
" Normally, you add 'term=Underline', but that doesn't quite work
hi def link commentFields Underlined
hi def link date Underlined
hi colon ctermfg=Cyan
hi commentTodo ctermfg=Black ctermbg=Yellow

hi fields ctermfg=Red
hi delim ctermfg=Yellow

hi properties ctermfg=Red
hi noteTag ctermfg=White ctermbg=Red
hi notes ctermfg=White ctermbg=Red

"hi body ctermfg=LightBlue

hi norwegian ctermfg=Green
hi russian ctermfg=Red

let b:current_syntax = "txt"

