return {
  "echasnovski/mini.move",
  event = "VeryLazy",
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      -- NOTE: DISABLE rectangle collitions with mappings cotrl + option + hjkl
      left = "<M-h>",
      right = "<A-l>",
      down = "<C-M-j>",
      up = "<C-M-k>",

      -- Move current line in Normal mode
      -- NOTE: DISABLE rectangle collitions with mappings cotrl + option + hjkl
      line_right = "<M-l>",
      line_left = "<M-h>",
      line_down = "<C-M-j>",
      line_up = "<C-M-k>",
    },

    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  },
}
