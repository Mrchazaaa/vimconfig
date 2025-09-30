
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
        auto_session_suppress_dirs = {
          "~/",
          "~/Projects",
          "~/Downloads",
          "/",
        },
      }
    end,
  },
}
