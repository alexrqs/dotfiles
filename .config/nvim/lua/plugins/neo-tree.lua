return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  -- LazyVim's spec registers a BufEnter hook that opens the tree when nvim starts
  -- on a directory (`nvim .`), front-loading a full tree scan into startup.
  -- A later spec's `init` replaces the earlier one, so an empty body cancels it.
  -- <leader>e / :Neotree still open it on demand.
  init = function() end,
  opts = {
    -- neo-tree's status job hardcodes `--ignored=traditional`, which walks every
    -- file inside all 30 node_modules of the monorepos here: ~2s warm, ~5s cold.
    -- hide_gitignored still hides them via `git ls-files --ignored` (~176ms).
    -- Buffer-level git marks come from gitsigns, which is unaffected.
    enable_git_status = false,
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
