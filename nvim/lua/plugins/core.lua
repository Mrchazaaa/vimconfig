
return {
  { "tpope/vim-sensible" },
  { "tpope/vim-commentary" },

  {
    "rmagatti/auto-session",
    config = function()
      local plain_start = (vim.fn.argc() == 0) and (vim.fn.line2byte("$") == -1)

      require("auto-session").setup {
        log_level = "error",
        auto_restore_enabled = not plain_start, -- ✅ skip restore on plain `nvim`
        auto_save_enabled = true,
        bypass_save_filetypes = {
          "dashboard"
        },
        auto_session_suppress_dirs = {
          "~/",
          "~/Projects",
          "~/Downloads",
          "/",
        },
        post_restore_cmds = {
          function()
            -- Restore nvim-tree after a session is restored
            local nvim_tree_api = require("nvim-tree.api")
            nvim_tree_api.tree.open()
            nvim_tree_api.tree.change_root(vim.fn.getcwd())
            nvim_tree_api.tree.reload()
          end,
        },
      }
    end,
  },
}
