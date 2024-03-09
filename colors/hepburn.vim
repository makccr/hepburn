" -----------------------------------------------------------------------------
" File: hepburn.vim
" Description: An OLED fork of Gruvbox
" Author: makccr <mackenziegcriswell@gmail.com>
" Source: https://github.com/makccr/hepburn
" Last Modified: 08 Mar 2024
" -----------------------------------------------------------------------------

" Supporting code -------------------------------------------------------------
" Initialisation: {{{

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name='hepburn'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" }}}
" Global Settings: {{{

if !exists('g:hepburn_bold')
  let g:hepburn_bold=1
endif
if !exists('g:hepburn_italic')
  if has('gui_running') || $TERM_ITALICS == 'true'
    let g:hepburn_italic=1
  else
    let g:hepburn_italic=0
  endif
endif
if !exists('g:hepburn_undercurl')
  let g:hepburn_undercurl=1
endif
if !exists('g:hepburn_underline')
  let g:hepburn_underline=1
endif
if !exists('g:hepburn_inverse')
  let g:hepburn_inverse=1
endif

if !exists('g:hepburn_guisp_fallback') || index(['fg', 'bg'], g:hepburn_guisp_fallback) == -1
  let g:hepburn_guisp_fallback='NONE'
endif

if !exists('g:hepburn_improved_strings')
  let g:hepburn_improved_strings=0
endif

if !exists('g:hepburn_improved_warnings')
  let g:hepburn_improved_warnings=0
endif

if !exists('g:hepburn_termcolors')
  let g:hepburn_termcolors=256
endif

if !exists('g:hepburn_invert_indent_guides')
  let g:hepburn_invert_indent_guides=0
endif

if exists('g:hepburn_contrast')
  echo 'g:hepburn_contrast is deprecated; use g:hepburn_contrast_light and g:hepburn_contrast_dark instead'
endif

if !exists('g:hepburn_contrast_dark')
  let g:hepburn_contrast_dark='medium'
endif

if !exists('g:hepburn_contrast_light')
  let g:hepburn_contrast_light='medium'
endif

let s:is_dark=(&background == 'dark')

" }}}
" Palette: {{{

" setup palette dictionary
let s:gb = {}

" fill it with absolute colors
let s:gb.dark0_hard  = ['#000000', 234]     " 29-32-33
let s:gb.dark0       = ['#000000', 235]     " 40-40-40
let s:gb.dark0_soft  = ['#000000', 236]     " 50-48-47
let s:gb.dark1       = ['#000000', 237]     " 60-56-54
let s:gb.dark2       = ['#000000', 239]     " 80-73-69
let s:gb.dark3       = ['#000000', 241]     " 102-92-84
let s:gb.dark4       = ['#000000', 243]     " 124-111-100
let s:gb.dark4_256   = ['#000000', 243]     " 124-111-100

let s:gb.gray_245    = ['#807E75', 245]     " 146-131-116
let s:gb.gray_244    = ['#807E75', 244]     " 146-131-116

let s:gb.light0_hard = ['#F9F6E5', 230]     " 249-245-215
let s:gb.light0      = ['#F9F6E5', 229]     " 253-244-193
let s:gb.light0_soft = ['#F9F6E5', 228]     " 242-229-188
let s:gb.light1      = ['#F9F6E5', 223]     " 235-219-178
let s:gb.light2      = ['#F9F6E5', 250]     " 213-196-161
let s:gb.light3      = ['#F9F6E5', 248]     " 189-174-147
let s:gb.light4      = ['#F9F6E5', 246]     " 168-153-132
let s:gb.light4_256  = ['#F9F6E5', 246]     " 168-153-132

let s:gb.bright_red     = ['#fb4934', 167]     " 251-73-52
let s:gb.bright_green   = ['#b8bb26', 142]     " 184-187-38
let s:gb.bright_yellow  = ['#fabd2f', 214]     " 250-189-47
let s:gb.bright_blue    = ['#83a598', 109]     " 131-165-152
let s:gb.bright_purple  = ['#d3869b', 175]     " 211-134-155
let s:gb.bright_aqua    = ['#8ec07c', 108]     " 142-192-124
let s:gb.bright_orange  = ['#fe8019', 208]     " 254-128-25

let s:gb.neutral_red    = ['#cc241d', 124]     " 204-36-29
let s:gb.neutral_green  = ['#98971a', 106]     " 152-151-26
let s:gb.neutral_yellow = ['#d79921', 172]     " 215-153-33
let s:gb.neutral_blue   = ['#458588', 66]      " 69-133-136
let s:gb.neutral_purple = ['#b16286', 132]     " 177-98-134
let s:gb.neutral_aqua   = ['#689d6a', 72]      " 104-157-106
let s:gb.neutral_orange = ['#d65d0e', 166]     " 214-93-14

let s:gb.faded_red      = ['#9d0006', 88]      " 157-0-6
let s:gb.faded_green    = ['#79740e', 100]     " 121-116-14
let s:gb.faded_yellow   = ['#b57614', 136]     " 181-118-20
let s:gb.faded_blue     = ['#076678', 24]      " 7-102-120
let s:gb.faded_purple   = ['#8f3f71', 96]      " 143-63-113
let s:gb.faded_aqua     = ['#427b58', 66]      " 66-123-88
let s:gb.faded_orange   = ['#af3a03', 130]     " 175-58-3

" }}}
" Setup Emphasis: {{{

let s:bold = 'bold,'
if g:hepburn_bold == 0
  let s:bold = ''
endif

let s:italic = 'italic,'
if g:hepburn_italic == 0
  let s:italic = ''
endif

let s:underline = 'underline,'
if g:hepburn_underline == 0
  let s:underline = ''
endif

let s:undercurl = 'undercurl,'
if g:hepburn_undercurl == 0
  let s:undercurl = ''
endif

let s:inverse = 'inverse,'
if g:hepburn_inverse == 0
  let s:inverse = ''
endif

" }}}
" Setup Colors: {{{

let s:vim_bg = ['bg', 'bg']
let s:vim_fg = ['fg', 'fg']
let s:none = ['NONE', 'NONE']

" determine relative colors
if s:is_dark
  let s:bg0  = s:gb.dark0
  if g:hepburn_contrast_dark == 'soft'
    let s:bg0  = s:gb.dark0_soft
  elseif g:hepburn_contrast_dark == 'hard'
    let s:bg0  = s:gb.dark0_hard
  endif

  let s:bg1  = s:gb.dark1
  let s:bg2  = s:gb.dark2
  let s:bg3  = s:gb.dark3
  let s:bg4  = s:gb.dark4

  let s:gray = s:gb.gray_245

  let s:fg0 = s:gb.light0
  let s:fg1 = s:gb.light1
  let s:fg2 = s:gb.light2
  let s:fg3 = s:gb.light3
  let s:fg4 = s:gb.light4

  let s:fg4_256 = s:gb.light4_256

  let s:red    = s:gb.bright_red
  let s:green  = s:gb.bright_green
  let s:yellow = s:gb.bright_yellow
  let s:blue   = s:gb.bright_blue
  let s:purple = s:gb.bright_purple
  let s:aqua   = s:gb.bright_aqua
  let s:orange = s:gb.bright_orange
else
  let s:bg0  = s:gb.light0
  if g:hepburn_contrast_light == 'soft'
    let s:bg0  = s:gb.light0_soft
  elseif g:hepburn_contrast_light == 'hard'
    let s:bg0  = s:gb.light0_hard
  endif

  let s:bg1  = s:gb.light1
  let s:bg2  = s:gb.light2
  let s:bg3  = s:gb.light3
  let s:bg4  = s:gb.light4

  let s:gray = s:gb.gray_244

  let s:fg0 = s:gb.dark0
  let s:fg1 = s:gb.dark1
  let s:fg2 = s:gb.dark2
  let s:fg3 = s:gb.dark3
  let s:fg4 = s:gb.dark4

  let s:fg4_256 = s:gb.dark4_256

  let s:red    = s:gb.faded_red
  let s:green  = s:gb.faded_green
  let s:yellow = s:gb.faded_yellow
  let s:blue   = s:gb.faded_blue
  let s:purple = s:gb.faded_purple
  let s:aqua   = s:gb.faded_aqua
  let s:orange = s:gb.faded_orange
endif

" reset to 16 colors fallback
if g:hepburn_termcolors == 16
  let s:bg0[1]    = 0
  let s:fg4[1]    = 7
  let s:gray[1]   = 8
  let s:red[1]    = 9
  let s:green[1]  = 10
  let s:yellow[1] = 11
  let s:blue[1]   = 12
  let s:purple[1] = 13
  let s:aqua[1]   = 14
  let s:fg1[1]    = 15
endif

" save current relative colors back to palette dictionary
let s:gb.bg0 = s:bg0
let s:gb.bg1 = s:bg1
let s:gb.bg2 = s:bg2
let s:gb.bg3 = s:bg3
let s:gb.bg4 = s:bg4

let s:gb.gray = s:gray

let s:gb.fg0 = s:fg0
let s:gb.fg1 = s:fg1
let s:gb.fg2 = s:fg2
let s:gb.fg3 = s:fg3
let s:gb.fg4 = s:fg4

let s:gb.fg4_256 = s:fg4_256

let s:gb.red    = s:red
let s:gb.green  = s:green
let s:gb.yellow = s:yellow
let s:gb.blue   = s:blue
let s:gb.purple = s:purple
let s:gb.aqua   = s:aqua
let s:gb.orange = s:orange

" }}}
" Setup Terminal Colors For Neovim: {{{

if has('nvim')
  let g:terminal_color_0 = s:bg0[0]
  let g:terminal_color_8 = s:gray[0]

  let g:terminal_color_1 = s:gb.neutral_red[0]
  let g:terminal_color_9 = s:red[0]

  let g:terminal_color_2 = s:gb.neutral_green[0]
  let g:terminal_color_10 = s:green[0]

  let g:terminal_color_3 = s:gb.neutral_yellow[0]
  let g:terminal_color_11 = s:yellow[0]

  let g:terminal_color_4 = s:gb.neutral_blue[0]
  let g:terminal_color_12 = s:blue[0]

  let g:terminal_color_5 = s:gb.neutral_purple[0]
  let g:terminal_color_13 = s:purple[0]

  let g:terminal_color_6 = s:gb.neutral_aqua[0]
  let g:terminal_color_14 = s:aqua[0]

  let g:terminal_color_7 = s:fg4[0]
  let g:terminal_color_15 = s:fg1[0]
endif

" }}}
" Overload Setting: {{{

let s:hls_cursor = s:orange
if exists('g:hepburn_hls_cursor')
  let s:hls_cursor = get(s:gb, g:hepburn_hls_cursor)
endif

let s:number_column = s:none
if exists('g:hepburn_number_column')
  let s:number_column = get(s:gb, g:hepburn_number_column)
endif

let s:sign_column = s:bg1

if exists('g:gitgutter_override_sign_column_highlight') &&
      \ g:gitgutter_override_sign_column_highlight == 1
  let s:sign_column = s:number_column
else
  let g:gitgutter_override_sign_column_highlight = 0

  if exists('g:hepburn_sign_column')
    let s:sign_column = get(s:gb, g:hepburn_sign_column)
  endif
endif

let s:color_column = s:bg1
if exists('g:hepburn_color_column')
  let s:color_column = get(s:gb, g:hepburn_color_column)
endif

let s:vert_split = s:bg0
if exists('g:hepburn_vert_split')
  let s:vert_split = get(s:gb, g:hepburn_vert_split)
endif

let s:invert_signs = ''
if exists('g:hepburn_invert_signs')
  if g:hepburn_invert_signs == 1
    let s:invert_signs = s:inverse
  endif
endif

let s:invert_selection = s:inverse
if exists('g:hepburn_invert_selection')
  if g:hepburn_invert_selection == 0
    let s:invert_selection = ''
  endif
endif

let s:invert_tabline = ''
if exists('g:hepburn_invert_tabline')
  if g:hepburn_invert_tabline == 1
    let s:invert_tabline = s:inverse
  endif
endif

let s:italicize_comments = s:italic
if exists('g:hepburn_italicize_comments')
  if g:hepburn_italicize_comments == 0
    let s:italicize_comments = ''
  endif
endif

let s:italicize_strings = ''
if exists('g:hepburn_italicize_strings')
  if g:hepburn_italicize_strings == 1
    let s:italicize_strings = s:italic
  endif
endif

" }}}
" Highlighting Function: {{{

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:hepburn_guisp_fallback != 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:hepburn_guisp_fallback == 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

" }}}
" Hepburn Hi Groups: {{{

" memoize common hi groups
call s:HL('HepburnFg0', s:fg0)
call s:HL('HepburnFg1', s:fg1)
call s:HL('HepburnFg2', s:fg2)
call s:HL('HepburnFg3', s:fg3)
call s:HL('HepburnFg4', s:fg4)
call s:HL('HepburnGray', s:gray)
call s:HL('HepburnBg0', s:bg0)
call s:HL('HepburnBg1', s:bg1)
call s:HL('HepburnBg2', s:bg2)
call s:HL('HepburnBg3', s:bg3)
call s:HL('HepburnBg4', s:bg4)

call s:HL('HepburnRed', s:red)
call s:HL('HepburnRedBold', s:red, s:none, s:bold)
call s:HL('HepburnGreen', s:green)
call s:HL('HepburnGreenBold', s:green, s:none, s:bold)
call s:HL('HepburnYellow', s:yellow)
call s:HL('HepburnYellowBold', s:yellow, s:none, s:bold)
call s:HL('HepburnBlue', s:blue)
call s:HL('HepburnBlueBold', s:blue, s:none, s:bold)
call s:HL('HepburnPurple', s:purple)
call s:HL('HepburnPurpleBold', s:purple, s:none, s:bold)
call s:HL('HepburnAqua', s:aqua)
call s:HL('HepburnAquaBold', s:aqua, s:none, s:bold)
call s:HL('HepburnOrange', s:orange)
call s:HL('HepburnOrangeBold', s:orange, s:none, s:bold)

call s:HL('HepburnRedSign', s:red, s:sign_column, s:invert_signs)
call s:HL('HepburnGreenSign', s:green, s:sign_column, s:invert_signs)
call s:HL('HepburnYellowSign', s:yellow, s:sign_column, s:invert_signs)
call s:HL('HepburnBlueSign', s:blue, s:sign_column, s:invert_signs)
call s:HL('HepburnPurpleSign', s:purple, s:sign_column, s:invert_signs)
call s:HL('HepburnAquaSign', s:aqua, s:sign_column, s:invert_signs)
call s:HL('HepburnOrangeSign', s:orange, s:sign_column, s:invert_signs)

" }}}

" Vanilla colorscheme ---------------------------------------------------------
" General UI: {{{

" Normal text
call s:HL('Normal', s:fg1, s:bg0)

" Correct background (see issue #7):
" --- Problem with changing between dark and light on 256 color terminal
" --- https://github.com/morhetz/hepburn/issues/7
if s:is_dark
  set background=dark
else
  set background=light
endif

if version >= 700
  " Screen line that the cursor is
  call s:HL('CursorLine',   s:none, s:bg1)
  " Screen column that the cursor is
  hi! link CursorColumn CursorLine

  " Tab pages line filler
  call s:HL('TabLineFill', s:bg4, s:bg1, s:invert_tabline)
  " Active tab page label
  call s:HL('TabLineSel', s:green, s:bg1, s:invert_tabline)
  " Not active tab page label
  hi! link TabLine TabLineFill

  " Match paired bracket under the cursor
  call s:HL('MatchParen', s:none, s:bg3, s:bold)
endif

if version >= 703
  " Highlighted screen columns
  call s:HL('ColorColumn',  s:none, s:color_column)

  " Concealed element: \lambda → λ
  call s:HL('Conceal', s:blue, s:none)

  " Line number of CursorLine
  call s:HL('CursorLineNr', s:yellow, s:bg1)
endif

hi! link NonText HepburnBg2
hi! link SpecialKey HepburnBg2

call s:HL('Visual',    s:none,  s:bg3, s:invert_selection)
hi! link VisualNOS Visual

call s:HL('Search',    s:yellow, s:bg0, s:inverse)
call s:HL('IncSearch', s:hls_cursor, s:bg0, s:inverse)

call s:HL('Underlined', s:blue, s:none, s:underline)

call s:HL('StatusLine',   s:bg2, s:fg1, s:inverse)
call s:HL('StatusLineNC', s:bg1, s:fg4, s:inverse)

" The column separating vertically split windows
call s:HL('VertSplit', s:bg3, s:vert_split)

" Current match in wildmenu completion
call s:HL('WildMenu', s:blue, s:bg2, s:bold)

" Directory names, special names in listing
hi! link Directory HepburnGreenBold

" Titles for output from :set all, :autocmd, etc.
hi! link Title HepburnGreenBold

" Error messages on the command line
call s:HL('ErrorMsg',   s:bg0, s:red, s:bold)
" More prompt: -- More --
hi! link MoreMsg HepburnYellowBold
" Current mode message: -- INSERT --
hi! link ModeMsg HepburnYellowBold
" 'Press enter' prompt and yes/no questions
hi! link Question HepburnOrangeBold
" Warning messages
hi! link WarningMsg HepburnRedBold

" }}}
" Gutter: {{{

" Line number for :number and :# commands
call s:HL('LineNr', s:bg4, s:number_column)

" Column where signs are displayed
call s:HL('SignColumn', s:none, s:sign_column)

" Line used for closed folds
call s:HL('Folded', s:gray, s:bg1, s:italic)
" Column where folds are displayed
call s:HL('FoldColumn', s:gray, s:bg1)

" }}}
" Cursor: {{{

" Character under cursor
call s:HL('Cursor', s:none, s:none, s:inverse)
" Visual mode cursor, selection
hi! link vCursor Cursor
" Input moder cursor
hi! link iCursor Cursor
" Language mapping cursor
hi! link lCursor Cursor

" }}}
" Syntax Highlighting: {{{

if g:hepburn_improved_strings == 0
  hi! link Special HepburnOrange
else
  call s:HL('Special', s:orange, s:bg1, s:italicize_strings)
endif

call s:HL('Comment', s:gray, s:none, s:italicize_comments)
call s:HL('Todo', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('Error', s:red, s:vim_bg, s:bold . s:inverse)

" Generic statement
hi! link Statement HepburnRed
" if, then, else, endif, swicth, etc.
hi! link Conditional HepburnRed
" for, do, while, etc.
hi! link Repeat HepburnRed
" case, default, etc.
hi! link Label HepburnRed
" try, catch, throw
hi! link Exception HepburnRed
" sizeof, "+", "*", etc.
hi! link Operator Normal
" Any other keyword
hi! link Keyword HepburnRed

" Variable name
hi! link Identifier HepburnBlue
" Function name
hi! link Function HepburnGreenBold

" Generic preprocessor
hi! link PreProc HepburnAqua
" Preprocessor #include
hi! link Include HepburnAqua
" Preprocessor #define
hi! link Define HepburnAqua
" Same as Define
hi! link Macro HepburnAqua
" Preprocessor #if, #else, #endif, etc.
hi! link PreCondit HepburnAqua

" Generic constant
hi! link Constant HepburnPurple
" Character constant: 'c', '/n'
hi! link Character HepburnPurple
" String constant: "this is a string"
if g:hepburn_improved_strings == 0
  call s:HL('String',  s:green, s:none, s:italicize_strings)
else
  call s:HL('String',  s:fg1, s:bg1, s:italicize_strings)
endif
" Boolean constant: TRUE, false
hi! link Boolean HepburnPurple
" Number constant: 234, 0xff
hi! link Number HepburnPurple
" Floating point constant: 2.3e10
hi! link Float HepburnPurple

" Generic type
hi! link Type HepburnYellow
" static, register, volatile, etc
hi! link StorageClass HepburnOrange
" struct, union, enum, etc.
hi! link Structure HepburnAqua
" typedef
hi! link Typedef HepburnYellow

" }}}
" Completion Menu: {{{

if version >= 700
  " Popup menu: normal item
  call s:HL('Pmenu', s:fg1, s:bg2)
  " Popup menu: selected item
  call s:HL('PmenuSel', s:bg2, s:blue, s:bold)
  " Popup menu: scrollbar
  call s:HL('PmenuSbar', s:none, s:bg2)
  " Popup menu: scrollbar thumb
  call s:HL('PmenuThumb', s:none, s:bg4)
endif

" }}}
" Diffs: {{{

call s:HL('DiffDelete', s:red, s:bg0, s:inverse)
call s:HL('DiffAdd',    s:green, s:bg0, s:inverse)
"call s:HL('DiffChange', s:bg0, s:blue)
"call s:HL('DiffText',   s:bg0, s:yellow)

" Alternative setting
call s:HL('DiffChange', s:aqua, s:bg0, s:inverse)
call s:HL('DiffText',   s:yellow, s:bg0, s:inverse)

" }}}
" Spelling: {{{

if has("spell")
  " Not capitalised word, or compile warnings
  if g:hepburn_improved_warnings == 0
    call s:HL('SpellCap',   s:none, s:none, s:undercurl, s:red)
  else
    call s:HL('SpellCap',   s:green, s:none, s:bold . s:italic)
  endif
  " Not recognized word
  call s:HL('SpellBad',   s:none, s:none, s:undercurl, s:blue)
  " Wrong spelling for selected region
  call s:HL('SpellLocal', s:none, s:none, s:undercurl, s:aqua)
  " Rare word
  call s:HL('SpellRare',  s:none, s:none, s:undercurl, s:purple)
endif

" }}}

" Plugin specific -------------------------------------------------------------
" EasyMotion: {{{

hi! link EasyMotionTarget Search
hi! link EasyMotionShade Comment

" }}}
" Sneak: {{{

hi! link Sneak Search
hi! link SneakLabel Search

" }}}
" Indent Guides: {{{

if !exists('g:indent_guides_auto_colors')
  let g:indent_guides_auto_colors = 0
endif

if g:indent_guides_auto_colors == 0
  if g:hepburn_invert_indent_guides == 0
    call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg1)
  else
    call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2, s:inverse)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg3, s:inverse)
  endif
endif

" }}}
" IndentLine: {{{

if !exists('g:indentLine_color_term')
  let g:indentLine_color_term = s:bg2[1]
endif
if !exists('g:indentLine_color_gui')
  let g:indentLine_color_gui = s:bg2[0]
endif

" }}}
" Rainbow Parentheses: {{{

if !exists('g:rbpt_colorpairs')
  let g:rbpt_colorpairs =
    \ [
      \ ['blue', '#458588'], ['magenta', '#b16286'],
      \ ['red',  '#cc241d'], ['166',     '#d65d0e']
    \ ]
endif

let g:rainbow_guifgs = [ '#d65d0e', '#cc241d', '#b16286', '#458588' ]
let g:rainbow_ctermfgs = [ '166', 'red', 'magenta', 'blue' ]

if !exists('g:rainbow_conf')
   let g:rainbow_conf = {}
endif
if !has_key(g:rainbow_conf, 'guifgs')
   let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
endif
if !has_key(g:rainbow_conf, 'ctermfgs')
   let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
endif

let g:niji_dark_colours = g:rbpt_colorpairs
let g:niji_light_colours = g:rbpt_colorpairs

"}}}
" GitGutter: {{{

hi! link GitGutterAdd HepburnGreenSign
hi! link GitGutterChange HepburnAquaSign
hi! link GitGutterDelete HepburnRedSign
hi! link GitGutterChangeDelete HepburnAquaSign

" }}}
" GitCommit: "{{{

hi! link gitcommitSelectedFile HepburnGreen
hi! link gitcommitDiscardedFile HepburnRed

" }}}
" Signify: {{{

hi! link SignifySignAdd HepburnGreenSign
hi! link SignifySignChange HepburnAquaSign
hi! link SignifySignDelete HepburnRedSign

" }}}
" Syntastic: {{{

call s:HL('SyntasticError', s:none, s:none, s:undercurl, s:red)
call s:HL('SyntasticWarning', s:none, s:none, s:undercurl, s:yellow)

hi! link SyntasticErrorSign HepburnRedSign
hi! link SyntasticWarningSign HepburnYellowSign

" }}}
" Signature: {{{
hi! link SignatureMarkText   HepburnBlueSign
hi! link SignatureMarkerText HepburnPurpleSign

" }}}
" ShowMarks: {{{

hi! link ShowMarksHLl HepburnBlueSign
hi! link ShowMarksHLu HepburnBlueSign
hi! link ShowMarksHLo HepburnBlueSign
hi! link ShowMarksHLm HepburnBlueSign

" }}}
" CtrlP: {{{

hi! link CtrlPMatch HepburnYellow
hi! link CtrlPNoEntries HepburnRed
hi! link CtrlPPrtBase HepburnBg2
hi! link CtrlPPrtCursor HepburnBlue
hi! link CtrlPLinePre HepburnBg2

call s:HL('CtrlPMode1', s:blue, s:bg2, s:bold)
call s:HL('CtrlPMode2', s:bg0, s:blue, s:bold)
call s:HL('CtrlPStats', s:fg4, s:bg2, s:bold)

" }}}
" Startify: {{{

hi! link StartifyBracket HepburnFg3
hi! link StartifyFile HepburnFg1
hi! link StartifyNumber HepburnBlue
hi! link StartifyPath HepburnGray
hi! link StartifySlash HepburnGray
hi! link StartifySection HepburnYellow
hi! link StartifySpecial HepburnBg2
hi! link StartifyHeader HepburnOrange
hi! link StartifyFooter HepburnBg2

" }}}
" Vimshell: {{{

let g:vimshell_escape_colors = [
  \ s:bg4[0], s:red[0], s:green[0], s:yellow[0],
  \ s:blue[0], s:purple[0], s:aqua[0], s:fg4[0],
  \ s:bg0[0], s:red[0], s:green[0], s:orange[0],
  \ s:blue[0], s:purple[0], s:aqua[0], s:fg0[0]
  \ ]

" }}}
" BufTabLine: {{{

call s:HL('BufTabLineCurrent', s:bg0, s:fg4)
call s:HL('BufTabLineActive', s:fg4, s:bg2)
call s:HL('BufTabLineHidden', s:bg4, s:bg1)
call s:HL('BufTabLineFill', s:bg0, s:bg0)

" }}}
" Asynchronous Lint Engine: {{{

call s:HL('ALEError', s:none, s:none, s:undercurl, s:red)
call s:HL('ALEWarning', s:none, s:none, s:undercurl, s:yellow)
call s:HL('ALEInfo', s:none, s:none, s:undercurl, s:blue)

hi! link ALEErrorSign HepburnRedSign
hi! link ALEWarningSign HepburnYellowSign
hi! link ALEInfoSign HepburnBlueSign

" }}}
" Dirvish: {{{

hi! link DirvishPathTail HepburnAqua
hi! link DirvishArg HepburnYellow

" }}}
" Netrw: {{{

hi! link netrwDir HepburnAqua
hi! link netrwClassify HepburnAqua
hi! link netrwLink HepburnGray
hi! link netrwSymLink HepburnFg1
hi! link netrwExe HepburnYellow
hi! link netrwComment HepburnGray
hi! link netrwList HepburnBlue
hi! link netrwHelpCmd HepburnAqua
hi! link netrwCmdSep HepburnFg3
hi! link netrwVersion HepburnGreen

" }}}
" NERDTree: {{{

hi! link NERDTreeDir HepburnAqua
hi! link NERDTreeDirSlash HepburnAqua

hi! link NERDTreeOpenable HepburnOrange
hi! link NERDTreeClosable HepburnOrange

hi! link NERDTreeFile HepburnFg1
hi! link NERDTreeExecFile HepburnYellow

hi! link NERDTreeUp HepburnGray
hi! link NERDTreeCWD HepburnGreen
hi! link NERDTreeHelp HepburnFg1

hi! link NERDTreeToggleOn HepburnGreen
hi! link NERDTreeToggleOff HepburnRed

" }}}
" Vim Multiple Cursors: {{{

call s:HL('multiple_cursors_cursor', s:none, s:none, s:inverse)
call s:HL('multiple_cursors_visual', s:none, s:bg2)

" }}}
" coc.nvim: {{{

hi! link CocErrorSign HepburnRedSign
hi! link CocWarningSign HepburnOrangeSign
hi! link CocInfoSign HepburnYellowSign
hi! link CocHintSign HepburnBlueSign
hi! link CocErrorFloat HepburnRed
hi! link CocWarningFloat HepburnOrange
hi! link CocInfoFloat HepburnYellow
hi! link CocHintFloat HepburnBlue
hi! link CocDiagnosticsError HepburnRed
hi! link CocDiagnosticsWarning HepburnOrange
hi! link CocDiagnosticsInfo HepburnYellow
hi! link CocDiagnosticsHint HepburnBlue

hi! link CocSelectedText HepburnRed
hi! link CocCodeLens HepburnGray

call s:HL('CocErrorHighlight', s:none, s:none, s:undercurl, s:red)
call s:HL('CocWarningHighlight', s:none, s:none, s:undercurl, s:orange)
call s:HL('CocInfoHighlight', s:none, s:none, s:undercurl, s:yellow)
call s:HL('CocHintHighlight', s:none, s:none, s:undercurl, s:blue)

" }}}

" Filetype specific -----------------------------------------------------------
" Diff: {{{

hi! link diffAdded HepburnGreen
hi! link diffRemoved HepburnRed
hi! link diffChanged HepburnAqua

hi! link diffFile HepburnOrange
hi! link diffNewFile HepburnYellow

hi! link diffLine HepburnBlue

" }}}
" Html: {{{

hi! link htmlTag HepburnBlue
hi! link htmlEndTag HepburnBlue

hi! link htmlTagName HepburnAquaBold
hi! link htmlArg HepburnAqua

hi! link htmlScriptTag HepburnPurple
hi! link htmlTagN HepburnFg1
hi! link htmlSpecialTagName HepburnAquaBold

call s:HL('htmlLink', s:fg4, s:none, s:underline)

hi! link htmlSpecialChar HepburnOrange

call s:HL('htmlBold', s:vim_fg, s:vim_bg, s:bold)
call s:HL('htmlBoldUnderline', s:vim_fg, s:vim_bg, s:bold . s:underline)
call s:HL('htmlBoldItalic', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('htmlBoldUnderlineItalic', s:vim_fg, s:vim_bg, s:bold . s:underline . s:italic)

call s:HL('htmlUnderline', s:vim_fg, s:vim_bg, s:underline)
call s:HL('htmlUnderlineItalic', s:vim_fg, s:vim_bg, s:underline . s:italic)
call s:HL('htmlItalic', s:vim_fg, s:vim_bg, s:italic)

" }}}
" Xml: {{{

hi! link xmlTag HepburnBlue
hi! link xmlEndTag HepburnBlue
hi! link xmlTagName HepburnBlue
hi! link xmlEqual HepburnBlue
hi! link docbkKeyword HepburnAquaBold

hi! link xmlDocTypeDecl HepburnGray
hi! link xmlDocTypeKeyword HepburnPurple
hi! link xmlCdataStart HepburnGray
hi! link xmlCdataCdata HepburnPurple
hi! link dtdFunction HepburnGray
hi! link dtdTagName HepburnPurple

hi! link xmlAttrib HepburnAqua
hi! link xmlProcessingDelim HepburnGray
hi! link dtdParamEntityPunct HepburnGray
hi! link dtdParamEntityDPunct HepburnGray
hi! link xmlAttribPunct HepburnGray

hi! link xmlEntity HepburnOrange
hi! link xmlEntityPunct HepburnOrange
" }}}
" Vim: {{{

call s:HL('vimCommentTitle', s:fg4_256, s:none, s:bold . s:italicize_comments)

hi! link vimNotation HepburnOrange
hi! link vimBracket HepburnOrange
hi! link vimMapModKey HepburnOrange
hi! link vimFuncSID HepburnFg3
hi! link vimSetSep HepburnFg3
hi! link vimSep HepburnFg3
hi! link vimContinue HepburnFg3

" }}}
" Clojure: {{{

hi! link clojureKeyword HepburnBlue
hi! link clojureCond HepburnOrange
hi! link clojureSpecial HepburnOrange
hi! link clojureDefine HepburnOrange

hi! link clojureFunc HepburnYellow
hi! link clojureRepeat HepburnYellow
hi! link clojureCharacter HepburnAqua
hi! link clojureStringEscape HepburnAqua
hi! link clojureException HepburnRed

hi! link clojureRegexp HepburnAqua
hi! link clojureRegexpEscape HepburnAqua
call s:HL('clojureRegexpCharClass', s:fg3, s:none, s:bold)
hi! link clojureRegexpMod clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass

hi! link clojureParen HepburnFg3
hi! link clojureAnonArg HepburnYellow
hi! link clojureVariable HepburnBlue
hi! link clojureMacro HepburnOrange

hi! link clojureMeta HepburnYellow
hi! link clojureDeref HepburnYellow
hi! link clojureQuote HepburnYellow
hi! link clojureUnquote HepburnYellow

" }}}
" C: {{{

hi! link cOperator HepburnPurple
hi! link cStructure HepburnOrange

" }}}
" Python: {{{

hi! link pythonBuiltin HepburnOrange
hi! link pythonBuiltinObj HepburnOrange
hi! link pythonBuiltinFunc HepburnOrange
hi! link pythonFunction HepburnAqua
hi! link pythonDecorator HepburnRed
hi! link pythonInclude HepburnBlue
hi! link pythonImport HepburnBlue
hi! link pythonRun HepburnBlue
hi! link pythonCoding HepburnBlue
hi! link pythonOperator HepburnRed
hi! link pythonException HepburnRed
hi! link pythonExceptions HepburnPurple
hi! link pythonBoolean HepburnPurple
hi! link pythonDot HepburnFg3
hi! link pythonConditional HepburnRed
hi! link pythonRepeat HepburnRed
hi! link pythonDottedName HepburnGreenBold

" }}}
" CSS: {{{

hi! link cssBraces HepburnBlue
hi! link cssFunctionName HepburnYellow
hi! link cssIdentifier HepburnOrange
hi! link cssClassName HepburnGreen
hi! link cssColor HepburnBlue
hi! link cssSelectorOp HepburnBlue
hi! link cssSelectorOp2 HepburnBlue
hi! link cssImportant HepburnGreen
hi! link cssVendor HepburnFg1

hi! link cssTextProp HepburnAqua
hi! link cssAnimationProp HepburnAqua
hi! link cssUIProp HepburnYellow
hi! link cssTransformProp HepburnAqua
hi! link cssTransitionProp HepburnAqua
hi! link cssPrintProp HepburnAqua
hi! link cssPositioningProp HepburnYellow
hi! link cssBoxProp HepburnAqua
hi! link cssFontDescriptorProp HepburnAqua
hi! link cssFlexibleBoxProp HepburnAqua
hi! link cssBorderOutlineProp HepburnAqua
hi! link cssBackgroundProp HepburnAqua
hi! link cssMarginProp HepburnAqua
hi! link cssListProp HepburnAqua
hi! link cssTableProp HepburnAqua
hi! link cssFontProp HepburnAqua
hi! link cssPaddingProp HepburnAqua
hi! link cssDimensionProp HepburnAqua
hi! link cssRenderProp HepburnAqua
hi! link cssColorProp HepburnAqua
hi! link cssGeneratedContentProp HepburnAqua

" }}}
" JavaScript: {{{

hi! link javaScriptBraces HepburnFg1
hi! link javaScriptFunction HepburnAqua
hi! link javaScriptIdentifier HepburnRed
hi! link javaScriptMember HepburnBlue
hi! link javaScriptNumber HepburnPurple
hi! link javaScriptNull HepburnPurple
hi! link javaScriptParens HepburnFg3

" }}}
" YAJS: {{{

hi! link javascriptImport HepburnAqua
hi! link javascriptExport HepburnAqua
hi! link javascriptClassKeyword HepburnAqua
hi! link javascriptClassExtends HepburnAqua
hi! link javascriptDefault HepburnAqua

hi! link javascriptClassName HepburnYellow
hi! link javascriptClassSuperName HepburnYellow
hi! link javascriptGlobal HepburnYellow

hi! link javascriptEndColons HepburnFg1
hi! link javascriptFuncArg HepburnFg1
hi! link javascriptGlobalMethod HepburnFg1
hi! link javascriptNodeGlobal HepburnFg1
hi! link javascriptBOMWindowProp HepburnFg1
hi! link javascriptArrayMethod HepburnFg1
hi! link javascriptArrayStaticMethod HepburnFg1
hi! link javascriptCacheMethod HepburnFg1
hi! link javascriptDateMethod HepburnFg1
hi! link javascriptMathStaticMethod HepburnFg1

" hi! link javascriptProp HepburnFg1
hi! link javascriptURLUtilsProp HepburnFg1
hi! link javascriptBOMNavigatorProp HepburnFg1
hi! link javascriptDOMDocMethod HepburnFg1
hi! link javascriptDOMDocProp HepburnFg1
hi! link javascriptBOMLocationMethod HepburnFg1
hi! link javascriptBOMWindowMethod HepburnFg1
hi! link javascriptStringMethod HepburnFg1

hi! link javascriptVariable HepburnOrange
" hi! link javascriptVariable HepburnRed
" hi! link javascriptIdentifier HepburnOrange
" hi! link javascriptClassSuper HepburnOrange
hi! link javascriptIdentifier HepburnOrange
hi! link javascriptClassSuper HepburnOrange

" hi! link javascriptFuncKeyword HepburnOrange
" hi! link javascriptAsyncFunc HepburnOrange
hi! link javascriptFuncKeyword HepburnAqua
hi! link javascriptAsyncFunc HepburnAqua
hi! link javascriptClassStatic HepburnOrange

hi! link javascriptOperator HepburnRed
hi! link javascriptForOperator HepburnRed
hi! link javascriptYield HepburnRed
hi! link javascriptExceptions HepburnRed
hi! link javascriptMessage HepburnRed

hi! link javascriptTemplateSB HepburnAqua
hi! link javascriptTemplateSubstitution HepburnFg1

" hi! link javascriptLabel HepburnBlue
" hi! link javascriptObjectLabel HepburnBlue
" hi! link javascriptPropertyName HepburnBlue
hi! link javascriptLabel HepburnFg1
hi! link javascriptObjectLabel HepburnFg1
hi! link javascriptPropertyName HepburnFg1

hi! link javascriptLogicSymbols HepburnFg1
hi! link javascriptArrowFunc HepburnYellow

hi! link javascriptDocParamName HepburnFg4
hi! link javascriptDocTags HepburnFg4
hi! link javascriptDocNotation HepburnFg4
hi! link javascriptDocParamType HepburnFg4
hi! link javascriptDocNamedParamType HepburnFg4

hi! link javascriptBrackets HepburnFg1
hi! link javascriptDOMElemAttrs HepburnFg1
hi! link javascriptDOMEventMethod HepburnFg1
hi! link javascriptDOMNodeMethod HepburnFg1
hi! link javascriptDOMStorageMethod HepburnFg1
hi! link javascriptHeadersMethod HepburnFg1

hi! link javascriptAsyncFuncKeyword HepburnRed
hi! link javascriptAwaitFuncKeyword HepburnRed

" }}}
" PanglossJS: {{{

hi! link jsClassKeyword HepburnAqua
hi! link jsExtendsKeyword HepburnAqua
hi! link jsExportDefault HepburnAqua
hi! link jsTemplateBraces HepburnAqua
hi! link jsGlobalNodeObjects HepburnFg1
hi! link jsGlobalObjects HepburnFg1
hi! link jsFunction HepburnAqua
hi! link jsFuncParens HepburnFg3
hi! link jsParens HepburnFg3
hi! link jsNull HepburnPurple
hi! link jsUndefined HepburnPurple
hi! link jsClassDefinition HepburnYellow

" }}}
" TypeScript: {{{

hi! link typeScriptReserved HepburnAqua
hi! link typeScriptLabel HepburnAqua
hi! link typeScriptFuncKeyword HepburnAqua
hi! link typeScriptIdentifier HepburnOrange
hi! link typeScriptBraces HepburnFg1
hi! link typeScriptEndColons HepburnFg1
hi! link typeScriptDOMObjects HepburnFg1
hi! link typeScriptAjaxMethods HepburnFg1
hi! link typeScriptLogicSymbols HepburnFg1
hi! link typeScriptDocSeeTag Comment
hi! link typeScriptDocParam Comment
hi! link typeScriptDocTags vimCommentTitle
hi! link typeScriptGlobalObjects HepburnFg1
hi! link typeScriptParens HepburnFg3
hi! link typeScriptOpSymbols HepburnFg3
hi! link typeScriptHtmlElemProperties HepburnFg1
hi! link typeScriptNull HepburnPurple
hi! link typeScriptInterpolationDelimiter HepburnAqua

" }}}
" PureScript: {{{

hi! link purescriptModuleKeyword HepburnAqua
hi! link purescriptModuleName HepburnFg1
hi! link purescriptWhere HepburnAqua
hi! link purescriptDelimiter HepburnFg4
hi! link purescriptType HepburnFg1
hi! link purescriptImportKeyword HepburnAqua
hi! link purescriptHidingKeyword HepburnAqua
hi! link purescriptAsKeyword HepburnAqua
hi! link purescriptStructure HepburnAqua
hi! link purescriptOperator HepburnBlue

hi! link purescriptTypeVar HepburnFg1
hi! link purescriptConstructor HepburnFg1
hi! link purescriptFunction HepburnFg1
hi! link purescriptConditional HepburnOrange
hi! link purescriptBacktick HepburnOrange

" }}}
" CoffeeScript: {{{

hi! link coffeeExtendedOp HepburnFg3
hi! link coffeeSpecialOp HepburnFg3
hi! link coffeeCurly HepburnOrange
hi! link coffeeParen HepburnFg3
hi! link coffeeBracket HepburnOrange

" }}}
" Ruby: {{{

hi! link rubyStringDelimiter HepburnGreen
hi! link rubyInterpolationDelimiter HepburnAqua

" }}}
" ObjectiveC: {{{

hi! link objcTypeModifier HepburnRed
hi! link objcDirective HepburnBlue

" }}}
" Go: {{{

hi! link goDirective HepburnAqua
hi! link goConstants HepburnPurple
hi! link goDeclaration HepburnRed
hi! link goDeclType HepburnBlue
hi! link goBuiltins HepburnOrange

" }}}
" Lua: {{{

hi! link luaIn HepburnRed
hi! link luaFunction HepburnAqua
hi! link luaTable HepburnOrange

" }}}
" MoonScript: {{{

hi! link moonSpecialOp HepburnFg3
hi! link moonExtendedOp HepburnFg3
hi! link moonFunction HepburnFg3
hi! link moonObject HepburnYellow

" }}}
" Java: {{{

hi! link javaAnnotation HepburnBlue
hi! link javaDocTags HepburnAqua
hi! link javaCommentTitle vimCommentTitle
hi! link javaParen HepburnFg3
hi! link javaParen1 HepburnFg3
hi! link javaParen2 HepburnFg3
hi! link javaParen3 HepburnFg3
hi! link javaParen4 HepburnFg3
hi! link javaParen5 HepburnFg3
hi! link javaOperator HepburnOrange

hi! link javaVarArg HepburnGreen

" }}}
" Elixir: {{{

hi! link elixirDocString Comment

hi! link elixirStringDelimiter HepburnGreen
hi! link elixirInterpolationDelimiter HepburnAqua

hi! link elixirModuleDeclaration HepburnYellow

" }}}
" Scala: {{{

" NB: scala vim syntax file is kinda horrible
hi! link scalaNameDefinition HepburnFg1
hi! link scalaCaseFollowing HepburnFg1
hi! link scalaCapitalWord HepburnFg1
hi! link scalaTypeExtension HepburnFg1

hi! link scalaKeyword HepburnRed
hi! link scalaKeywordModifier HepburnRed

hi! link scalaSpecial HepburnAqua
hi! link scalaOperator HepburnFg1

hi! link scalaTypeDeclaration HepburnYellow
hi! link scalaTypeTypePostDeclaration HepburnYellow

hi! link scalaInstanceDeclaration HepburnFg1
hi! link scalaInterpolation HepburnAqua

" }}}
" Markdown: {{{

call s:HL('markdownItalic', s:fg3, s:none, s:italic)

hi! link markdownH1 HepburnGreenBold
hi! link markdownH2 HepburnGreenBold
hi! link markdownH3 HepburnYellowBold
hi! link markdownH4 HepburnYellowBold
hi! link markdownH5 HepburnYellow
hi! link markdownH6 HepburnYellow

hi! link markdownCode HepburnAqua
hi! link markdownCodeBlock HepburnAqua
hi! link markdownCodeDelimiter HepburnAqua

hi! link markdownBlockquote HepburnGray
hi! link markdownListMarker HepburnGray
hi! link markdownOrderedListMarker HepburnGray
hi! link markdownRule HepburnGray
hi! link markdownHeadingRule HepburnGray

hi! link markdownUrlDelimiter HepburnFg3
hi! link markdownLinkDelimiter HepburnFg3
hi! link markdownLinkTextDelimiter HepburnFg3

hi! link markdownHeadingDelimiter HepburnOrange
hi! link markdownUrl HepburnPurple
hi! link markdownUrlTitleDelimiter HepburnGreen

call s:HL('markdownLinkText', s:gray, s:none, s:underline)
hi! link markdownIdDeclaration markdownLinkText

" }}}
" Haskell: {{{

" hi! link haskellType HepburnYellow
" hi! link haskellOperators HepburnOrange
" hi! link haskellConditional HepburnAqua
" hi! link haskellLet HepburnOrange
"
hi! link haskellType HepburnFg1
hi! link haskellIdentifier HepburnFg1
hi! link haskellSeparator HepburnFg1
hi! link haskellDelimiter HepburnFg4
hi! link haskellOperators HepburnBlue
"
hi! link haskellBacktick HepburnOrange
hi! link haskellStatement HepburnOrange
hi! link haskellConditional HepburnOrange

hi! link haskellLet HepburnAqua
hi! link haskellDefault HepburnAqua
hi! link haskellWhere HepburnAqua
hi! link haskellBottom HepburnAqua
hi! link haskellBlockKeywords HepburnAqua
hi! link haskellImportKeywords HepburnAqua
hi! link haskellDeclKeyword HepburnAqua
hi! link haskellDeriving HepburnAqua
hi! link haskellAssocType HepburnAqua

hi! link haskellNumber HepburnPurple
hi! link haskellPragma HepburnPurple

hi! link haskellString HepburnGreen
hi! link haskellChar HepburnGreen

" }}}
" Json: {{{

hi! link jsonKeyword HepburnGreen
hi! link jsonQuote HepburnGreen
hi! link jsonBraces HepburnFg1
hi! link jsonString HepburnFg1

" }}}


" Functions -------------------------------------------------------------------
" Search Highlighting Cursor {{{

function! HepburnHlsShowCursor()
  call s:HL('Cursor', s:bg0, s:hls_cursor)
endfunction

function! HepburnHlsHideCursor()
  call s:HL('Cursor', s:none, s:none, s:inverse)
endfunction

" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
