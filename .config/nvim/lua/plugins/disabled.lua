-- Everything switched off, in one place.
--
-- These are all LazyVim *core* plugins. Core plugins aren't controlled by the
-- extras list in lazyvim.json, so `enabled = false` is the only lever; that is
-- why turning things off needs a spec rather than deleting a line.
--
-- completion: the code here is written by an agent, not typed by hand, so a
--   popup racing the keystrokes has nobody to serve. Dropping cmp-nvim-lsp's
--   capabilities also restores built-in omnifunc, so <C-x><C-o> still works.
-- formatting/linting: the repo's husky pre-commit runs lint-staged
--   (prettier --write, eslint --fix, biome check), so commits are formatted
--   regardless of editor. Doing it again on :w is duplicate work.
return {
  { "saghen/blink.cmp", enabled = false, optional = true },
  { "stevearc/conform.nvim", enabled = false, optional = true },
  { "mfussenegger/nvim-lint", enabled = false, optional = true },
}
