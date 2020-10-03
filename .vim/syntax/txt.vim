" ==============================================================================
" Auth: Alex Celani
" Lang: Text
" Revn: 10-03-2020  1.4
" Func: Define syntax coloring for .txt files when being edited in Vim
"
" TODO: make comments create new comments on line overrun and newline
"       add highlighting for titles, vocab words, definitions
"       color things explicitly with 'hi <group> cterm[f,b]g=<Color>, and add
"           table of acceptable options, with link ( :help hi )
" ==============================================================================
" CHANGE LOG
" ------------------------------------------------------------------------------
" 09-29-2020:  copy over from go.vim
" 10-01-2020:  gutted entire file
"              made my own quote regex
"              made comment
"              added link to list of group names and their colors
" 10-02-2020:  rewrote quotes to allow for multiline quotes with rollover
"              added recognition for numbers
"              separated numbers into numbers and numbers in quotes
"              added recognition of dates, to underline dates in the change log
"              added to comments to recognize Auth, Lang, Revn, Func, and Todo
"              underline Auth, Lang, Revn, Func, Todo, and Change Log
"              recognized fields, the field delimiter (::), and property
"                   delimiter (->)
"              added tags for notes to self, and the body of such
"              began to write something to passively color the body, no luck yet
"              colored things relating to Norway green, and Russia red
"              added Color Guide (for the default highlighting file) and source
"              changed some colors up a bit
"              made property delimiter of variable length, and also use =>
" 10-03-2020:  added reminded to color explicitly in Todo
"
" ==============================================================================

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif



" XXX Quotes:
" quotes should exist between odd pairs of quotation marks
" eg| "quote" not
"     "quote" not "quote"
"     "not
"     quote"
"     "quote only if the it rolls
"     over onto the next line"
" Calling the quotation a region instead of pattern match makes it easier to
" wrap around a new line
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
"  \{-,} means that it prioritizes the smallest amount of matches possible
" syn match quote "\".\{-,}\""
"  -- DEPRECATED --


" XXX Numbers:
" num and numQuote allow for the coloring of numbers. numQuote exists for the
" for the sole purpose of coloring numbers differently for when they're inside
"       of a quote, thus the contained keyword for numQuote
" the first and last quote define the expression
" - is the negative symbol, and \? allows for either 0 or 1 matchings, which
"       allows for negative numbers
" \d is any digit [0-9], and \+ is one or more matches, which means there MUST
"       be at least one number for a match to be seen
" \a is any letter [a-zA-Z], * allows for any number of them for variables
" \. escapes the . character so decimal points can be represented
" \? allows 0 or 1 matches of \., because a number can only have one decimal
" \d for numbers after the decimal
" * for any number of matches, using \+ (one or more matches) would have only
"       allowed for 2 digit numbers minimum
syn match numQuote "-\?\d\+\a*\.\?\d*" contained
syn match num "-\?\d\+\a*\.\?\d*"


" XXX Dates:
" Date highlighting for the Change Log
" the first and last quote define the expression
" \d is any digit [0-9]
" \{1,2} will match only one or two times, although it should only ever get two
" - is the literal hyphen, which seperates months and days, and days and years
" The same three elements are repeated again for the days
" \d is any digit, used again for the years
" \{4} for only four digits can be matched
" ends with : because only the dates in the change log should be highlighted
" marked as contained, because it should only be highlighted in comments
" contains colon, so I can highlight the color separately
" for some reason, the colon doesn't work as a keyword, so simple match
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
" commentFields and commentTodo are contained within comments, so they are
" as such in the definition of a comment, and listed as contained in their own
" definitions
syn keyword commentFields contained Auth Revn File Func
syn keyword commentTodo contained TODO
syn match commentFields contained "CHANGE LOG"


" XXX Fields:
" Denotes properties, things that are of importance
" first and last quote define the expression
" . is any character
" * is any number of that character
" :: is the literal characters '::', which denotes the property
" Using nextgroup would have been better praxis, but this works and is simple
" After, denote the delimiter as its own syntax element to color it differently
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
" denote the notes as starting with a space and ending with and exclamation mark
" if it's not denoted as contained, then the whole damn thing will be
"       highlighted
syn region notes start=" " end="!" contained


" FIXME Body:
" This is the rest of the text
" I found out with notes, if this isn't given as contained, it'll just highlight
"       everything
"syn region body start=" " end=" "


" XXX Norwegian:
" XXX Russian:
" lmfao ignore case sensitivity to avoid writing things twice
" Highlight norwegian shit green
syn case ignore
syn keyword norwegian   nordic nordics
syn keyword norwegian   norse
syn keyword norwegian   norway
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



" ColorGuide: - - - - - - - - - - - - - - - - - - - - source:: :help group-name
" Constant     -> Red
" Comment      -> Light Blue
" Statement    -> Orange
" Identifier   -> Light Blue
" PreProc      -> Purple
" Type         -> Green
" Special      -> Purple
" Error        -> White, Red highlight
" Todo         -> Black, Yellow Highlight
" Underlined   -> Purple, underlined
" ColorGuide: - - - - - - - - - - - - - - - - - - - - source:: :help group-name


" XXX Coloring:
hi def link quote Constant
hi def link numQuote Special
hi def link num Constant

hi def link comments Type
hi def link commentFields Underlined
hi def link date Underlined
hi def link colon Type
hi def link commentTodo Todo

hi def link properties Statement
hi def link delim Constant

hi def link fields PreProc

hi def link noteTag Error
hi def link notes Error

"hi def link body Identifier

hi def link norwegian Type
hi def link russian Constant

let b:current_syntax = "txt"

