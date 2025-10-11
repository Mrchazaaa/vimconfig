call RelativeSource('/CoreConfig/MessagesToBuf.vim')
call RelativeSource('/CoreConfig/CursorHistory.vim')
call RelativeSource('/CoreConfig/WindowNavigation.vim')
call RelativeSource('/CoreConfig/WindowScrolling.vim')
call RelativeSource('/CoreConfig/ConfigVerification.vim')

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

set path+=.,**
 
nnoremap gg gg0
nnoremap G G$

let mapleader = " "

filetype indent plugin on
syntax enable

set foldmethod=indent
set foldenable
set foldlevel=99
set foldlevelstart=99
