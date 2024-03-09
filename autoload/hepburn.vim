" -----------------------------------------------------------------------------
" File: hepburn.vim
" Description: An OLED fork of Gruvbox
" Author: makccr <mackenziegcriswell@gmail.com>
" Source: https://github.com/makccr/hepburn
" Last Modified: 08 Mar 224
" -----------------------------------------------------------------------------0

function! hepburn#invert_signs_toggle()
  if g:hepburn_invert_signs == 0
    let g:hepburn_invert_signs=1
  else
    let g:hepburn_invert_signs=0
  endif

  colorscheme hepburn
endfunction

" Search Highlighting {{{

function! hepburn#hls_show()
  set hlsearch
  call HepburnHlsShowCursor()
endfunction

function! hepburn#hls_hide()
  set nohlsearch
  call HepburnHlsHideCursor()
endfunction

function! hepburn#hls_toggle()
  if &hlsearch
    call hepburn#hls_hide()
  else
    call hepburn#hls_show()
  endif
endfunction

" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
