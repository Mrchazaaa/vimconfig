return {
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },

        -- Define the "hide numbers" logic EARLY so it can win races at startup.
        init = function()
            local aug = vim.api.nvim_create_augroup("DashboardNoNumbers", { clear = true })

            local function hide_numbers_in_win(win)
                if not win or not vim.api.nvim_win_is_valid(win) then return end
                local buf = vim.api.nvim_win_get_buf(win)
                if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
                if vim.bo[buf].filetype ~= "dashboard" then return end

                local function apply()
                    -- Window-local options
                    vim.wo[win].number = false
                    vim.wo[win].relativenumber = false
                    -- vim.wo[win].signcolumn = "no"
                    vim.wo[win].foldcolumn = "0"
                    -- If you use a custom statuscolumn plugin (shows numbers even when number=false)
                    pcall(function() vim.wo[win].statuscolumn = "" end)
                end

                -- Apply now, then again after other autocmds for this tick, then once more shortly after.
                apply()
                vim.schedule(apply)
                vim.defer_fn(apply, 25)
            end

            -- When the dashboard filetype is set
            vim.api.nvim_create_autocmd("FileType", {
                group = aug,
                pattern = "dashboard",
                callback = function() hide_numbers_in_win(0) end,
            })

            -- When entering a window / showing a buffer
            vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinNew" }, {
                group = aug,
                callback = function(ev) hide_numbers_in_win(vim.fn.win_getid()) end,
            })

            -- Right after startup, iterate all windows (handles first screen)
            vim.api.nvim_create_autocmd("VimEnter", {
                group = aug,
                callback = function()
                    local wins = vim.api.nvim_list_wins()
                    for _, w in ipairs(wins) do hide_numbers_in_win(w) end
                    vim.schedule(function()
                        for _, w in ipairs(vim.api.nvim_list_wins()) do hide_numbers_in_win(w) end
                    end)
                    vim.defer_fn(function()
                        for _, w in ipairs(vim.api.nvim_list_wins()) do hide_numbers_in_win(w) end
                    end, 25)
                end,
            })

            -- Also handle the current window immediately (in case the dashboard is already visible)
            hide_numbers_in_win(vim.fn.win_getid())
        end,

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
                theme = "hyper", -- 'hyper' or 'doom'
                change_to_vcs_root = true,
                hide = { statusline = true, tabline = true, winbar = true },

                config = {
                    week_header = { enable = true },
                    shortcut    = {
                        { desc = "  New file", group = "String", action = "ene | startinsert", key = "e" },
                        { desc = "  Files", group = "Label", action = "Telescope find_files", key = "f" },
                        { desc = "  Recent", group = "Label", action = "Telescope oldfiles", key = "r" },
                        { desc = "  Grep", group = "Label", action = "Telescope live_grep", key = "g" },
                        { desc = "  Config", group = "Number", action = "edit $MYVIMRC", key = "c" },
                        { desc = "󰒲  Plugins", group = "@property", action = "Lazy", key = "l" },
                        { desc = "󰑓  Update", group = "@property", action = "Lazy update", key = "u" },
                        { desc = "  Quit", group = "DiagnosticError", action = "qa", key = "q" },
                    },
                    packages    = { enable = true },
                    project     = { enable = true, limit = 6, icon = " ", label = " Projects", action = "Telescope find_files cwd=" },
                    mru         = { enable = true, limit = 10, icon = " ", label = " Recent", cwd_only = false },
                    footer      = { footer_line() },
                },
            })

            -- Optional: map <leader>bd to reopen the dashboard any time
            vim.keymap.set("n", "<leader>bd", "<Cmd>Dashboard<CR>", { desc = "Open Dashboard" })
        end,
    },
}
