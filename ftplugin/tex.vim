syntax spell toplevel 

imap \[             \[  \]<++><Esc>6hi
imap \{             \{  \}<++><Esc>6hi
imap $$             \(  \)<++><ESC>6hi

" imap \left(         \left(\right)<++><ESC>10hi


" This is useful for very long lines
" nnoremap j gj
" nnoremap k gk
" vnoremap j gj
" vnoremap k gk

set sw=0
" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

set spell spelllang=en_gb
setlocal spellfile+=oneoff.utf-8.add


nnoremap \\s	 	:!./.compile.sh silent<CR>
nnoremap \\o	 	:call MySynctex()<CR>
nnoremap \b cw\begin{<C-R>"}<CR>\end{<C-R>"}

function! Synctex()
  execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:syncpdf
  redraw!
endfunction
map <C-enter> :call Synctex()<cr>

let g:Tex_SmartKeyQuote=0

" set numbers " (optional - will help to visually verify that it's working)
set textwidth=50
set wrapmargin=0
set formatoptions+=t
set linebreak " (optional - breaks by word rather than character)

""""""""""""""""""""""""
"" latex-suite """""""""
""""""""""""""""""""""""
filetype plugin on
filetype indent on
let g:tex_flavor='latex'

hi clear SpellBad
hi SpellBad cterm=underline ctermbg=red

autocmd FileType * exec("setlocal dictionary+=".$HOME."/.config/nvim/dictionaries/".expand('<amatch>'))
set completeopt=menuone,longest,preview
set complete+=k
