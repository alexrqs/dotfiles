return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup LSP keymaps
      local Keys = require("lazyvim.plugins.lsp.keymaps")
      Keys.on_attach(function(client, buffer)
        local keymaps = Keys.get()
        Keys.resolve(buffer, keymaps)
      end)

      -- Basic LSP setup
      local lspconfig = require("lspconfig")

      -- Setup some common language servers
      -- Add any servers you need here
      local servers = {
        "lua_ls",
        "tsserver",
        "jsonls",
        "html",
        "cssls",
      }

      for _, server in ipairs(servers) do
        -- Check if the server is available
        local ok, _ = pcall(require, "lspconfig.server_configurations." .. server)
        if ok then
          lspconfig[server].setup({})
        end
      end

      -- Setup diagnostic display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
      },
      automatic_installation = true,
    },
  },
}
