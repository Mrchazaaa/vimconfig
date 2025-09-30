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
}
