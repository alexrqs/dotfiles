-- fzf-lua is the active picker (LazyVim resolves lazyvim_picker=auto to fzf).
-- By default it loads on first keypress, so <leader><leader> pays ~42ms of
-- plugin load before it can even start scanning. Warm it after the UI is up:
-- startup stays ~98ms and the first picker opens with results already streaming.
return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
}
