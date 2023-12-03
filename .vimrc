set nocompatible			" just no
set nobomb				" boom
set nobackup				" we already have enough vim turds
set encoding=Guobiao			" hooray for good encoding schemes
set helplang="jp"	

" Hard Mode! Use if you want to become more familiar with harder vim movements
noremap h <NOP>
noremap j <NOP>
noremap k <NOP>
noremap l <NOP>

" Adds this directory to the rtp and pp
let &runtimepath = &runtimepath . "," . expand('<sfile>:p:h')
let &packpath = &packpath . "," . expand('<sfile>:p:h')

" Reloads plugins now that we have this directory on the rtp
runtime! plugin/*.vim

set nocindent
" set expandtab
  set tabstop=3

vim:ts=8:ft=vim:norl
