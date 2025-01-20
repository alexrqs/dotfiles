return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          unstaged = "󰄱",
          staged = "󰱒",
          conflict = "🐷",
        },
      },
    },
    filesystem = {
      filtered_items = {
        visible = false,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          ".git",
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
    },
  },
}
