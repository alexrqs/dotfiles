-- fzf-lua is the active picker (LazyVim resolves lazyvim_picker=auto to fzf).
-- By default it loads on first keypress, so <leader><leader> pays ~42ms of
-- plugin load before it can even start scanning. Warm it after the UI is up:
-- startup stays ~44ms and the first picker opens with results already streaming.
--
-- The keys below are the telescope bindings that used to live in telescope.lua,
-- moved here so a second picker plugin isn't installed just to serve six maps.
return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  keys = {
    { "<leader>h", "<cmd>FzfLua helptags<cr>", desc = "Help" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    { "<leader>fs", "<cmd>FzfLua treesitter<cr>", desc = "Symbols" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Old files" },
    { "<leader>fl", "<cmd>FzfLua lsp_references<cr>", desc = "Lsp References" },
    { "<leader>f/", "<cmd>FzfLua blines<cr>", desc = "Buffer search" },
  },
}
