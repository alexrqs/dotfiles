-- No completion engine: the code here is written by an agent, not typed by hand,
-- so a popup that races the keystrokes has nobody to serve. blink.cmp is
-- LazyVim's default and installs itself once the nvim-cmp extra is gone.
--
-- LSP stays on for reading code (diagnostics, hover, go-to-definition), and
-- dropping cmp-nvim-lsp's capabilities restores the built-in omnifunc, so
-- <C-x><C-o> still completes on demand.
return {
  { "saghen/blink.cmp", enabled = false, optional = true },
}
