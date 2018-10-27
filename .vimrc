"==================================basic settings====================================="
colorscheme ron
"needed for ctags plugin
nmap <F8> :TagbarToggle<CR>
"required by vundle, automatically set but just in case
set nocompatible 
"required by vundle
filetype off
"add line numbers 
set relativenumber 
"turn hybrid line numbers on
set number
"basic command line completion provided by vim
set wildmenu 
"basic command line completion setting provided by vim
set wildmode=longest,list:longest
"basic command line completion setting provided by vim
set completeopt=menu,preview
"basic comand line completion setting provided by vim
set complete=.,b,u,]
"set number of spaces that vim indents when pressing '>'
set shiftwidth=4 
"remap keys to make creating/switching vim windows easier:
"move to vim split down
nnoremap <C-Down> <C-W><C-J>
nnoremap <C-j> <C-W><C-J>
"move to vim split up 
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-k> <C-W><C-J>
"move to vim split right 
nnoremap <C-Right> <C-W><C-L>
nnoremap <C-l> <C-W><C-J>
"move to vim split left 
nnoremap <C-Left> <C-W><C-H>
nnoremap <C-h> <C-W><C-J>
"place newly opened horizontal splits below the current window
set splitbelow
"place newly opened vertical splits to the right of the current window
set splitright
"do not wrap long lines of text
set nowrap
"fuzzy filepath completion provided by vim (activated by <TAB> after a "filepath)
set path+=**
"Display currently typed command
:set showcmd
"remapping to allow importing of snippets *NOT CURRENTLY IMPLEMENTED*
"nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a
"map better auto completion to shift-tab in insert mode
inoremap <S-Tab> <C-N>
"needed for code folding
set foldmethod=indent
set foldlevel=20 "should mean all folds are open when opening a file
set foldcolumn=2
"==================================basic settings====================================="


"=======================================vundle========================================"
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

"begin Vundle's Plugin list
call vundle#begin()

"code completion
Plugin 'valloric/youcompleteme'

"auto closing brackets
Plugin 'https://github.com/jiangmiao/auto-pairs'

"speedy html and css
Plugin 'mattn/emmet-vim'

"ctags
Plugin 'https://github.com/majutsushi/tagbar'

"replace words witth register values
Plugin 'https://github.com/vim-scripts/ReplaceWithRegister'

"change surrounding characters (quote marks, tags etc)
Plugin 'https://github.com/tpope/vim-surround'
"change, append and delete surrounding characters (repeatable with '.')

"Operation to comment lines out (commeent lines, blocks)
Plugin 'https://github.com/tpope/vim-commentary'

"let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"file explorer
Plugin 'https://github.com/scrooloose/nerdtree'

"status line
Plugin 'vim-airline/vim-airline'

"Syntatic checker
Plugin 'https://github.com/vim-syntastic/syntastic'

"typescript syntactic stuff
Plugin 'https://github.com/leafgarland/typescript-vim'

"All of your Plugins must be added before the following line
call vundle#end()

"Brief help
":PluginList       - lists configured plugins
":PluginInstall    - installs plugins; append `!` to update or just
":PluginUpdate
":PluginSearch foo - searches for foo; append `!` to refresh local cache
":PluginClean      - confirms removal of unused plugins; append `!` to
"auto-approve removal
"
"see :h vundle for more details or wiki for FAQ
"=======================================vundle========================================"

filetype plugin indent on
"basic syntax highlighting provided by vim
syntax on
"change tab to 4 (spaces instead of 8)
set tabstop=4
set shiftwidth=4
set expandtab

"====================================syntastic========================================"
"Syntastic has numerous options that can be configured, and the defaults are
"not particularly well suitable for new users. It is recommended that you
"start by adding the following lines to your vimrc file, and return to them
"after reading the manual (see :help syntastic in Vim):

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_typescript_checkers=['tslint', 'tsc']
let g:syntastic_javascript_checkers=['eslint']
"====================================syntastic========================================""

"==========================inner indent custon texto object==========================="
"place in vimrc
onoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR>
onoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-U>cal <SID>IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-U>cal <SID>IndTxtObj(1)<CR><Esc>gv

function! s:IndTxtObj(inner)
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") !~ "^\\s*$"
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p > 0 && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      -
      let p = line(".") - 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, 0)
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
    while p <= lastline && ((i == 0 && !nextblank) || (i > 0 && ((indent(p) >= i && !(nextblank && a:inner)) || (nextblank && !a:inner))))
      +
      let p = line(".") + 1
      let nextblank = getline(p) =~ "^\\s*$"
    endwhile
    normal! $
  endif
endfunction

"for youcompleteme
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'

" for vim comments on c sharp files
autocmd FileType cs setlocal commentstring=//\ %s


"==========================inner indent custon texto object==========================="
"
"====================================helpful tips====================================="
" command line completion:
" ^P basic tab completion (foward search) [suggestion: "imap <Tab> <C-P>"]
" ^N basic tab completion (back search)
" ^X ^L whole line completion
" ^X ^O syntax-aware omnicompletion
" 
" ":h complete-functions" - help page for omnifunct, which uses smarter auto
" completion for specific languages
"
" Text objects:
" c change (delete and enter inster mode) (I.E: <c><w> = 'change word') 
" i can be used to describe operations 'in'
" 'diw' = "delete in word" | 'di(' = "delete in brackets"
" '<ip' = "indent in paragraph"
" 
" a '.' after using c command to "change" something will replicate that
" change on another world
" 
" 'cit' = "change inner tag" (can be used to edit text between html
" tags < and >)
"
" 'f' find until character (including character)
" 't' find until character (not including character)
"
" 'Y' copy line
" 'p' paste after line
" 'P' paste before line
" 
" vim-surround:
" cs"> = "change surrounding double quotes to tags" 
" ds" = "delete surrounding double quotes"
" ysiw] = "wrap word with square brackets" (iw is a text object)
"
" vim-comment:
" cml = "toggle comments line"
" cmj = "toggle comments down a line"
" cmip = "toggle comments whole paragraph"
" 
" Inner Indent 
" '<ii" = "Indent inner indent"
" 'cmai' = "comment around indent"
" 
" Replace with register:
" used to replace text objects with register values: https://github.com/vim-scripts/ReplaceWithRegister
"
"====================================helpful tips====================================="
