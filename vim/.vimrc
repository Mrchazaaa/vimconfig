" Show a few lines of context around the cursor.
set scrolloff=5
" Don't use Ex mode, use Q for formatting.
map Q gq
" Allow ESC to enter normal mode in built in terminal
tnoremap <Esc> <C-\><C-n>

set nowrap 
set ignorecase
set smartcase
set incsearch
" Basic settings
set encoding=utf-8
set backspace=indent,eol,start
set expandtab
set shiftround
set shiftwidth=2
set softtabstop=-1
set tabstop=2
set textwidth=80
set title
set hidden
set nofixendofline
set nostartofline
set splitbelow
set splitright
set hlsearch
set laststatus=2
set noruler
set noshowmode
set signcolumn=yes
set mouse=a
set updatetime=1000

set number relativenumber

augroup numbertoggle
  autocmd!
  " Only enable relativenumber when the current window has 'number' on locally.
  autocmd BufEnter,FocusGained,InsertLeave *
        \ if &l:number |
        \   setlocal relativenumber |
        \ else |
        \ endif

  autocmd BufLeave,FocusLost,InsertEnter *
        \ setlocal norelativenumber
augroup END

autocmd FileType cs setlocal commentstring=//\ %s

filetype indent plugin on
syntax enable

" remap the * register to copy/paste to the system clipboard
nnoremap "* "+
xnoremap "* "+
onoremap "* "+

set path+=.,**
 
command! MessagesToBuf
      \ redir => m |
      \ silent messages |
      \ redir END |
      \ new |
      \ put =m
 
" Move the current window to another position
nnoremap <C-S-Up>    <C-w>K
nnoremap <C-S-Down>  <C-w>J
nnoremap <C-S-Left>  <C-w>H
nnoremap <C-S-Right> <C-w>L


" Move between windows with Ctrl + Arrow keys
nnoremap <C-Up>    <C-w>k
nnoremap <C-Down>  <C-w>j
nnoremap <C-Left>  <C-w>h
nnoremap <C-Right> <C-w>l

nnoremap gg gg0
nnoremap G G$


" --- Scroll window with Alt + Arrow keys ---
nnoremap <A-Up>    <C-Y>
nnoremap <A-Down>  <C-E>
nnoremap <A-Left>  zh
nnoremap <A-Right> zl

" --- Scroll window with Alt + hjkl ---
nnoremap <A-h>  zh
nnoremap <A-j>  <C-E>
nnoremap <A-k>  <C-Y>
nnoremap <A-l>  zl


let mapleader = " "