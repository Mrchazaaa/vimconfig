-- lua/plugins/devstack.lua
return {
  -- ───────────────────────────── Syntax / AST ─────────────────────────────
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    opts = {
      ensure_installed = {
        'lua', 'vim', 'vimdoc',
        'bash', 'json', 'yaml', 'toml', 'markdown',
        'javascript', 'typescript', 'tsx', 'python',
        'powershell', 'vue'
      },
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          node_decremental = 'grm',
          scope_incremental = 'grc',
        },
      },
      refactor = {
        smart_rename = { 
          enable = true,
          keymaps = { smart_rename = 'grr' },
        },
        highlight_definitions = { enable = true },
        navigation = { enable = true },
      },
      textobjects = {
        select = { enable = true },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- ───────────────────────────── LSP core stack ───────────────────────────
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v4.x",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- LSP
      "neovim/nvim-lspconfig",
      {
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      "williamboman/mason-lspconfig.nvim",
      
      -- Completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      
      -- Snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      -- Set up default keymaps and capabilities
      lsp_zero.on_attach(function(client, bufnr)
        -- Default keymaps (gd, gr, K, etc.)
        lsp_zero.default_keymaps({ buffer = bufnr })

        -- Enable inlay hints if server provides them (Neovim 0.10+)
        if client.server_capabilities.inlayHintProvider then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
        end
      end)

      -- Mason setup
      require("mason").setup({
        ui = { border = "rounded" },
      })

      -- LSP servers via mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "jsonls",
          "yamlls",
          "eslint",
          "bashls",
          "ts_ls",
          "vuels",
        },
        handlers = {
          -- Default handler (recommended by lsp-zero v4)
          lsp_zero.default_setup,

          -- Custom handler for lua_ls
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()

            -- Additional tweaks for lua_ls
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

          -- Custom handler for TypeScript
          ts_ls = function()
            require("lspconfig").ts_ls.setup({
              filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "vue", -- Add this so ts_ls runs for .vue files
              },
              settings = {
                javascript = {
                  inlayHints = { includeInlayParameterNameHints = "all" },
                },
                typescript = {
                  inlayHints = { includeInlayParameterNameHints = "all" },
                },
              },
            })
          end,

          vuels = function()
            require("lspconfig").volar.setup({
              filetypes = { "vue" },
              init_options = {
                typescript = {
                  tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
                },
              },
            })
          end,
        },
      })

      -- ───────────── Completion (nvim-cmp) ─────────────
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
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

      -- Diagnostics UI configuration
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
        python = { "ruff_format", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "yamlfmt", "prettier" },
        sh = { "shfmt" },
      },
      notify_on_error = true,
      default_format_opts = { lsp_format = "fallback" },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("Format", function(args)
        local format_opts = {
          async = true,
          lsp_fallback = true,
        }

        -- If the command was invoked with a range (e.g. :'<,'>Format), use it
        if args.range > 0 then
          local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
          local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))

          -- Conform expects 0-indexed lines
          format_opts.range = {
            start = { srow - 1, scol },
            ["end"] = { erow - 1, ecol },
          }
        end

        require("conform").format(format_opts)
      end, {
        range = true,
        desc = "Format buffer or selected range with Conform",
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

      -- Uncomment to enable auto-linting
      -- local function try_lint()
      --   lint.try_lint()
      -- end

      -- vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      --   callback = try_lint,
      -- })
    end,
  },
}
