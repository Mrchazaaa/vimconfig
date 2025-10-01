-- lua/plugins/devstack.lua
return {
    -- ───────────────────────────── Syntax / AST ─────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "lua", "vim", "vimdoc",
                "bash", "json", "yaml", "toml", "markdown",
                "javascript", "typescript", "tsx", "python",
            },
            highlight = { enable = true },
            incremental_selection = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- ───────────────────────────── LSP core stack ───────────────────────────
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v4.x",
        lazy = true,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            "williamboman/mason-lspconfig.nvim",
            -- completion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- lsp-zero: base
            local lsp_zero = require("lsp-zero")

            lsp_zero.on_attach(function(client, bufnr)
                -- default keymaps (gd, gr, K, etc.)
                lsp_zero.default_keymaps({ buffer = bufnr })

                -- enable inlay hints if server provides them (Neovim 0.10+)
                if client.server_capabilities.inlayHintProvider then
                    pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
                end
            end)

            -- Mason
            require("mason").setup({ ui = { border = "rounded" } })

            -- LSP servers via mason-lspconfig
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright", -- or "basedpyright" if you prefer
                    "jsonls",
                    "yamlls",
                    "eslint",
                    "bashls",
                },
                handlers = {
                    -- default handler (recommended by lsp-zero v4)
                    lsp_zero.default_setup,

                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()

                        -- keep your tweaks:
                        lua_opts.settings = lua_opts.settings or {}
                        lua_opts.settings.Lua = lua_opts.settings.Lua or {}
                        lua_opts.settings.Lua.workspace = vim.tbl_deep_extend(
                            "force",
                            lua_opts.settings.Lua.workspace or {},
                            { checkThirdParty = false }
                        )
                        lua_opts.settings.Lua.telemetry = { enable = false }

                        require("lspconfig").lua_ls.setup(lua_opts)
                    end,

                    tsserver = function()
                        require("lspconfig").tsserver.setup({
                            settings = {
                                javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
                                typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
                            },
                        })
                    end,
                },
            })

            -- ───────────── Completion (cmp) ─────────────
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "luasnip" },
                },
            })

            -- diagnostics UI
            vim.diagnostic.config({
                virtual_text = true,
                severity_sort = true,
                float = { border = "rounded" },
                signs = true,
            })
        end,
    },

    -- ───────────────────────────── Format-on-save ───────────────────────────
    {
        "stevearc/conform.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format", "black" }, -- choose one if you like
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                yaml = { "yamlfmt", "prettier" },
                sh = { "shfmt" },
            },
            notify_on_error = true,
            default_format_opts = { lsp_format = "fallback" },
        },
        init = function()
            -- format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function(args)
                    require("conform").format({ bufnr = args.buf })
                end,
            })
        end,
    },

    -- ───────────────────────────── Lint on save/leave insert ────────────────
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "ruff" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                yaml = { "yamllint" },
                sh = { "shellcheck" },
            }

            local function try_lint()
                -- run linters for the current filetype
                lint.try_lint()
            end

            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = try_lint,
            })
        end,
    },
}
