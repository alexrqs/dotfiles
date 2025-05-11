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
                functionLikeReturnTypeHints = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        eslint = {
          settings = {
            -- Enable auto fix on save
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = true,
              mode = "all",
            },
            experimental = {
              useFlatConfig = false,
            },
            format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            problems = {
              shortenToSingleLine = false,
            },
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectory = {
              mode = "location",
            },
          },
        },
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

        -- Special handling for ESLint
        if server_name == "eslint" then
          server_opts.on_attach = function(client, bufnr)
            -- Enable formatting
            client.server_capabilities.documentFormattingProvider = true

            -- Auto fix on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end
        end

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

  -- Mason tools
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- Format and lint setup with autoformat on save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
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
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    opts = {
      linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      -- Create autocommand for linting
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
