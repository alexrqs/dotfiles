local select = require("CopilotChat.select")
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  lazy = true,
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" },
    { "nvim-lua/plenary.nvim" },
  },
  build = "make tiktoken",
  config = function()
    -- Pre-load buffer list
    vim.g.copilot_chat_buffers = {}
    vim.schedule(function()
      vim.g.copilot_chat_buffers = vim.tbl_filter(function(b)
        return vim.api.nvim_buf_is_loaded(b) and vim.fn.buflisted(b) == 1
      end, vim.api.nvim_list_bufs())
    end)

    require("CopilotChat").setup({
      context = "buffers",
      selection = function(source)
        -- Use the cached buffer list
        source.buffers = vim.g.copilot_chat_buffers
        return select.visual(source) or select.buffer(source)
      end,
      -- Update buffer list when buffers change
      window = {
        callback = function()
          vim.schedule(function()
            vim.g.copilot_chat_buffers = vim.tbl_filter(function(b)
              return vim.api.nvim_buf_is_loaded(b) and vim.fn.buflisted(b) == 1
            end, vim.api.nvim_list_bufs())
          end)
        end,
      },
    })
  end,
}
