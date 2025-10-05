return {
  -- Inline git signs + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function()
      vim.opt.signcolumn = "yes"
    end,
  },

  -- Full git porcelain commands
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gsplit", "Gread", "Gwrite", "Gdiffsplit", "Gvdiffsplit", "Ggrep", "Gclog", "GBrowse" },
    init = function()
      -- Open :Git status in a new tab by default (nice for larger views)
      vim.g.fugitive_dynamic_colors = 1
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = false,
      use_icons = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      default_args = {
        DiffviewOpen = { "--unfold-all" },
      },
    },
  },
}
