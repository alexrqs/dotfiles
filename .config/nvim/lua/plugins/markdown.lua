-- Markdown: pretty in-buffer rendering while editing comes from
-- render-markdown.nvim (pulled in by the lang.markdown extra). For a
-- side-by-side rendered view, open the file in leaf, a terminal Markdown
-- viewer (brew install leaf-markdown-viewer). `-w` re-renders on every save.
--
-- leaf is view-only, so it takes over <leader>cp from markdown-preview.nvim,
-- which needs a browser and a node build step.
return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>cp",
        function()
          Snacks.terminal.toggle({ "leaf", "-w", vim.api.nvim_buf_get_name(0) }, {
            win = { position = "right", width = 0.5 },
          })
        end,
        ft = "markdown",
        desc = "Preview in leaf",
      },
    },
  },
}
