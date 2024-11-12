-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Register all http files to be actual http filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.http",
  command = "set filetype=http",
})

vim.o.number = false
vim.opt.relativenumber = false
