return {
  -- {
  --   "preservim/nerdtree",
  --   dependencies = { 
  --       "tiagofumo/vim-nerdtree-syntax-highlight",
  --   },
  --   lazy = false,
  --   cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
  --   init = function()
  --     vim.g.NERDTreeHijackNetrw = 1
  --   end,
  --   config = function()
  --     vim.g.NERDTreeShowHidden = 1
  --   end
  -- },


  {
    "nvim-tree/nvim-tree.lua",
    version = "*", -- use latest stable release
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- for file icons
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          highlight_git = true
        },
        filters = {
          dotfiles = false,
        },
        diagnostics = {
          enable = true, -- show LSP diagnostics in the tree
        },
        git = {
          enable = true, -- show git status
        },
      })

      -- optional keymaps
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
    end,
  }
}