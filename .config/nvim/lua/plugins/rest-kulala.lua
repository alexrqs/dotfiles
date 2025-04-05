return {
  "mistweaverco/kulala.nvim",
  opts = {
    global_keymaps = {
      ["Select environment"] = {
        "<leader>Re", -- You can change this to your preferred shortcut
        function()
          require("kulala").set_selected_env()
        end,
        ft = { "http", "rest" },
        desc = "Select HTTP request environment",
      },
    },
  },
}
