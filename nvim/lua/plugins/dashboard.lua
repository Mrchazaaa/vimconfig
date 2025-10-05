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

      -- db.setup({
      --     theme = "hyper", -- 'hyper' or 'doom'
      --     change_to_vcs_root = true,
      --     hide = { statusline = true, tabline = true, winbar = true },

      --     config = {
      --         week_header = { enable = true },
      --         shortcut    = {
      --             { desc = "  New file", group = "String", action = "ene | startinsert", key = "e" },
      --             { desc = "  Files", group = "Label", action = "Telescope find_files", key = "f" },
      --             { desc = "  Recent", group = "Label", action = "Telescope oldfiles", key = "r" },
      --             { desc = "  Config", group = "Number", action = "edit $MYVIMRC", key = "c" },
      --             { desc = "󰒲  Plugins", group = "@property", action = "Lazy", key = "l" }
      --         },
      --         packages    = { enable = true },
      --         project     = { enable = true, limit = 6, icon = " ", label = " Projects", action = "Telescope find_files cwd=" },
      --         mru         = { enable = true, limit = 10, icon = " ", label = " Recent", cwd_only = false },
      --         footer      = { footer_line() },
      --     },
      -- })

      local function center_padding()
        local total_height = vim.fn.winheight(0)
        local dashboard_height = 15 -- estimated height of header + menu + footer
        return math.floor((total_height - dashboard_height) / 2)
      end

      db.setup({
        theme = 'doom',
        config = {
          week_header = { enable = true },
          center = {
            { icon = '  ', desc = 'New file', key = "n", action = "ene | startinsert" },
            { icon = '  ', desc = 'Sessions', key = "e", action = "AutoSession search" },
            { icon = '  ', desc = 'Recent', key = "r", action = "Telescope oldfiles" },
            { icon = '  ', desc = 'Find File', key = 'f', action = 'Telescope find_files' },
            { icon = '  ', desc = 'Config', key = 'c', action = 'edit ~/.config/nvim/init.lua' },
            { icon = '󰒲  ', desc = 'Plugins', key = 'p', action = "Lazy" }
          },
          vertical_center = true,
          footer = { footer_line() },
        },
      })

      -- Optional: map <leader>bd to reopen the dashboard any time
      vim.keymap.set("n", "<leader>bd", "<Cmd>Dashboard<CR>", { desc = "Open Dashboard" })
    end,
  },
}
