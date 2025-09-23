return {
  -- Essential plugins
  { "tpope/vim-sensible" },
  { "tpope/vim-commentary" },

  -- C# Development
  {
    "OmniSharp/omnisharp-vim",
    ft = "cs",
    dependencies = { "nickspoons/vim-sharpenup" }
  },
  {
    "nickspoons/vim-sharpenup",
    ft = "cs"
  },

  -- Linting and diagnostics
  {
    "dense-analysis/ale",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- ALE configuration
      vim.g.ale_linters = { cs = {'OmniSharp'} }
      vim.g.ale_sign_error = '•'
      vim.g.ale_sign_warning = '•'
      vim.g.ale_sign_info = '·'
      vim.g.ale_sign_style_error = '·'
      vim.g.ale_sign_style_warning = '·'
    end
  },

  -- Fuzzy finder
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" }
  },

  -- Autocompletion
  {
    "prabirshrestha/asyncomplete.vim",
    event = "InsertEnter",
    config = function()
      vim.g.asyncomplete_auto_popup = 1
      vim.g.asyncomplete_auto_completeopt = 0
    end
  },

  -- Theme
  {
    "gruvbox-community/gruvbox",
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd('colorscheme gruvbox')
    end
  },

  -- Status line
  {
    "itchyny/lightline.vim",
    dependencies = {
      "shinchu/lightline-gruvbox.vim",
      "maximbaz/lightline-ale"
    },
    config = function()
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
        component_function = {
          sharpenup = 'sharpenup#statusline#Build'
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

      -- ALE indicators for lightline
      vim.g['lightline#ale#indicator_checking'] = " "
      vim.g['lightline#ale#indicator_infos'] = " "
      vim.g['lightline#ale#indicator_warnings'] = " "
      vim.g['lightline#ale#indicator_errors'] = " "
      vim.g['lightline#ale#indicator_ok'] = " "
    end
  },
  { "shinchu/lightline-gruvbox.vim" },
  { "maximbaz/lightline-ale" },

  -- File explorer
  {
    "preservim/nerdtree",
    cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" }
  },

  -- Python support
  {
    "davidhalter/jedi-vim",
    ft = "python"
  }
}