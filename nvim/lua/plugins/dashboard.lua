return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local db = require("dashboard")

      -- Compute a nice footer line (works even without lazy.nvim)
      local function footer_line()
        local ok, lazy = pcall(require, "lazy")
        if ok then
          local stats = lazy.stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          return ("⚡ %d/%d plugins in %sms"):format(stats.loaded, stats.count, ms)
        end
        return "Happy hacking ✨"
      end

      db.setup({
        theme = "hyper",                -- 'hyper' or 'doom'
        change_to_vcs_root = true,      -- open MRU relative to git root when possible
        hide = { statusline = true, tabline = true, winbar = true },

        config = {
          week_header = { enable = true },   -- shows “Week xx • <date>” line

          -- Handy shortcuts (letters appear in the dashboard buffer, not keymaps)
          shortcut = {
            { desc = "  New file",       group = "String",       action = "ene | startinsert",        key = "e" },
            { desc = "  Files",          group = "Label",        action = "Telescope find_files",     key = "f" },
            { desc = "  Recent",         group = "Label",        action = "Telescope oldfiles",       key = "r" },
            { desc = "  Grep",           group = "Label",        action = "Telescope live_grep",      key = "g" },
            { desc = "  Config",         group = "Number",       action = "edit $MYVIMRC",            key = "c" },
            { desc = "󰒲  Plugins",        group = "@property",    action = "Lazy",                     key = "l" },
            { desc = "󰑓  Update",         group = "@property",    action = "Lazy update",              key = "u" },
            { desc = "  Quit",           group = "DiagnosticError", action = "qa",                    key = "q" },
          },

          -- Projects & MRU sections (Hyper theme)
          packages = { enable = true }, -- show loaded plugins count (works well with Lazy)
          project  = { enable = true, limit = 6, icon = " ", label = " Projects", action = "Telescope find_files cwd=" },
          mru      = { enable = true, limit = 10, icon = " ", label = " Recent",  cwd_only = false },

          footer = { footer_line() },
        },
      })

      -- Optional: map <leader>bd to reopen the dashboard any time
      vim.keymap.set("n", "<leader>bd", "<Cmd>Dashboard<CR>", { desc = "Open Dashboard" })
    end,
  },
}
