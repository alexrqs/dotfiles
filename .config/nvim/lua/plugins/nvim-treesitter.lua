return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "elixir",
      "heex",
      "eex",
      "gitignore",
      "go",
      "graphql",
      "html",
      "http",
      "javascript",
      "json",
      "lua",
      "python",
      "query",
      "regex",
      "rust",
      "sql",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}
