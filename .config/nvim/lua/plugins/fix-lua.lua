return {
  -- Override the default LSP config to avoid the error
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function(_, opts)
      local Util = require("lazyvim.util")
      local lspconfig = require("lspconfig")

      -- Setup keymaps
      Util.lsp.on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- Setup servers
      local servers = {
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        eslint = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        jsonls = {},
        html = {},
        cssls = {},
      }

      -- Skip problematic servers
      local skip_servers = {
        "emmylua_ls",
        "omnisharp_mono",
        "sourcery",
        "harper_ls",
      }

      -- Setup diagnostics
      Util.lsp.setup()
      Util.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

      -- Setup servers manually
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Don't use mason-lspconfig's ensure_installed at all
      require("mason-lspconfig").setup({
        automatic_installation = false,
      })

      -- Just setup the servers that are already installed
      local installed_servers = require("mason-lspconfig").get_installed_servers()

      for _, server_name in ipairs(installed_servers) do
        if vim.tbl_contains(skip_servers, server_name) then
          goto continue
        end

        local server_opts = servers[server_name] or {}
        server_opts.capabilities = capabilities

        if lspconfig[server_name] then
          local ok, err = pcall(function()
            lspconfig[server_name].setup(server_opts)
          end)
          if not ok then
            vim.notify("Error setting up " .. server_name .. ": " .. tostring(err), vim.log.levels.WARN)
          end
        end

        ::continue::
      end
    end,
  },

  -- Mason tools (don't try to ensure_install here either)
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- Format and lint setup
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
  },
}
