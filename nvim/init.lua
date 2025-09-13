local vimrcDirectory = vim.fn.fnamemodify(vim.env.MYVIMRC .. ':p', ':p:h')
function ImportConfigFile(fileName)
    local fileLocation = vim.g.vimrcDirectory .. '/' .. fileName
    vim.cmd('source ' .. fileLocation)
end

vim.opt.relativenumber = true

-- Set this to 1 to use ultisnips for snippet handling
local using_snippets = 0

-- vim-plug
vim.cmd([[
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'OmniSharp/omnisharp-vim'
Plug 'nickspoons/vim-sharpenup'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'
Plug 'preservim/nerdtree'
Plug 'davidhalter/jedi-vim'
]] .. (using_snippets == 1 and "Plug 'sirver/ultisnips'" or "") .. [[

call plug#end()
]])

-- Settings
vim.cmd('filetype indent plugin on')
if not vim.g.syntax_on then
    vim.cmd('syntax enable')
end

vim.opt.encoding = 'utf-8'
vim.opt.backspace = {'indent', 'eol', 'start'}
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.tabstop = 8
vim.opt.textwidth = 80
vim.opt.title = true
vim.opt.hidden = true
vim.opt.fixendofline = false
vim.opt.startofline = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.number = false
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.mouse = 'a'
vim.opt.updatetime = 1000

-- Colors
local colorscheme_group = vim.api.nvim_create_augroup('ColorschemePreferences', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    group = colorscheme_group,
    pattern = '*',
    callback = function()
        vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
        vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE')
        vim.cmd('highlight Todo ctermbg=NONE guibg=NONE')
        vim.cmd('highlight link ALEErrorSign WarningMsg')
        vim.cmd('highlight link ALEWarningSign ModeMsg')
        vim.cmd('highlight link ALEInfoSign Identifier')
    end
})

-- Use truecolor in the terminal, when it is supported
if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end

vim.opt.background = 'dark'
vim.cmd('colorscheme gruvbox')

-- ALE
vim.g.ale_sign_error = '•'
vim.g.ale_sign_warning = '•'
vim.g.ale_sign_info = '·'
vim.g.ale_sign_style_error = '·'
vim.g.ale_sign_style_warning = '·'
vim.g.ale_linters = { cs = {'OmniSharp'} }

-- Asyncomplete
vim.g.asyncomplete_auto_popup = 1
vim.g.asyncomplete_auto_completeopt = 0

-- Sharpenup
-- All sharpenup mappings will begin with `<Space>os`, e.g. `<Space>osgd` for
-- :OmniSharpGotoDefinition
vim.g.sharpenup_map_prefix = '<Space>os'
vim.g.sharpenup_statusline_opts = { Text = '%s (%p/%P)' }
vim.g.sharpenup_statusline_opts.Highlight = 0

local omnisharp_group = vim.api.nvim_create_augroup('OmniSharpIntegrations', { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = omnisharp_group,
    pattern = {'OmniSharpProjectUpdated', 'OmniSharpReady'},
    command = 'call lightline#update()'
})

-- Lightline
vim.g.lightline = {
    colorscheme = 'gruvbox',
    active = {
        right = {
            {'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'},
            {'lineinfo'}, {'percent'},
            {'fileformat', 'fileencoding', 'filetype', 'sharpenup'}
        }
    },
    inactive = {
        right = {{'lineinfo'}, {'percent'}, {'sharpenup'}}
    },
    component = {
        sharpenup = vim.fn['sharpenup#statusline#Build']()
    },
    component_expand = {
        linter_checking = 'lightline#ale#checking',
        linter_infos = 'lightline#ale#infos',
        linter_warnings = 'lightline#ale#warnings',
        linter_errors = 'lightline#ale#errors',
        linter_ok = 'lightline#ale#ok'
    },
    component_type = {
        linter_checking = 'right',
        linter_infos = 'right',
        linter_warnings = 'warning',
        linter_errors = 'error',
        linter_ok = 'right'
    }
}

-- Use unicode chars for ale indicators in the statusline
vim.g['lightline#ale#indicator_checking'] = " "
vim.g['lightline#ale#indicator_infos'] = " "
vim.g['lightline#ale#indicator_warnings'] = " "
vim.g['lightline#ale#indicator_errors'] = " "
vim.g['lightline#ale#indicator_ok'] = " "

-- OmniSharp
vim.g.OmniSharp_popup_position = 'peek'
if vim.fn.has('nvim') == 1 then
    vim.g.OmniSharp_popup_options = {
        winhl = 'Normal:NormalFloat'
    }
else
    vim.g.OmniSharp_popup_options = {
        highlight = 'Normal',
        padding = {0, 0, 0, 0},
        border = {1}
    }
end

vim.g.OmniSharp_popup_mappings = {
    sigNext = '<C-n>',
    sigPrev = '<C-p>',
    pageDown = {'<C-f>', '<PageDown>'},
    pageUp = {'<C-b>', '<PageUp>'}
}

if using_snippets == 1 then
    vim.g.OmniSharp_want_snippet = 1
end

vim.g.OmniSharp_highlight_groups = {
    ExcludedCode = 'NonText'
}

-- Allow ESC to enter normal mode in built in terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
