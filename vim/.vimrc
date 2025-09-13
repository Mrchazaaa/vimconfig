" Show a few lines of context around the cursor.
set scrolloff=5

" Don't use Ex mode, use Q for formatting.
map Q gq

set ignorecase
set smartcase
set incsearch

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

autocmd FileType cs setlocal commentstring=//\ %s
