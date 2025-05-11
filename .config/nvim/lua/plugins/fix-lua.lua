return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Setup keymaps using LazyVim's system
      local Util = require("lazyvim.util")
      local Keys = require("lazyvim.plugins.lsp.keymaps")

      -- On attach function for keymaps
      Util.lsp.on_attach(function(client, buffer)
        Keys.on_attach(client, buffer)
      end)

      -- Setup capabilities for autocompletion
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Setup LSP servers
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      -- Setup function for each server
      local function setup_server(server_name)
        local server_config = {
          capabilities = capabilities,
        }

        -- Special config for tsserver (TypeScript)
        if server_name == "tsserver" then
          server_config.settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          }
        end

        lspconfig[server_name].setup(server_config)
      end

      -- Get all available servers and set them up
      local available_servers = mason_lspconfig.get_available_servers()
      for _, server in ipairs(available_servers) do
        setup_server(server)
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "tsserver", -- For TypeScript/JavaScript
        "jsonls",
        "html",
        "cssls",
        "eslint", -- Added for eslint extra
      },
      automatic_installation = true,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettier", -- Added for prettier extra
        "eslint_d", -- Fast eslint daemon
      },
    },
  },
}
