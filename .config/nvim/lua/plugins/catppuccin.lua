return {
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      -- Auto-detection scans every installed plugin on each startup (~6ms) but
      -- only adds dap, dap_ui and render_markdown over catppuccin's defaults,
      -- so name those three instead and skip the scan.
      auto_integrations = false,
      integrations = {
        cmp = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = true,
        dap = true,
        dap_ui = true,
        render_markdown = true,
      },
    },
  },
}
