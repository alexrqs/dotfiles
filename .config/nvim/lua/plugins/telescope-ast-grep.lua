-- file: ~/.config/nvim/lua/plugins/telescope-ast-grep.lua
return {
  "ray-x/telescope-ast-grep.nvim",
  requires = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        ast_grep = {
          command = { "sg", "--json=stream" },
          grep_open_files = false,
          lang = nil,
        },
      },
    })
    -- Correctly load the extension using the actual function name
    require("telescope").load_extension("ast_grep")
  end,
  keys = {
    {
      "<leader>sx",
      function()
        require("telescope").extensions.ast_grep.AST_grep()
      end,
      desc = "Search with AST Grep",
    },
  },
}
