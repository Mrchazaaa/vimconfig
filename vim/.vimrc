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
set number relativenumber
" Basic settings
set encoding=utf-8
set backspace=indent,eol,start
set expandtab
set shiftround
set shiftwidth=4
set softtabstop=-1
set tabstop=8
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

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

autocmd FileType cs setlocal commentstring=//\ %s

filetype indent plugin on
syntax enable

" remap the * register to copy/paste to the system clipboard
nnoremap "* "+
xnoremap "* "+
onoremap "* "+

set path+=.,**