-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_eslint_auto_format = true

-- Spanish alongside English so mixed-language notes don't flag either one
vim.opt.spelllang = { "en", "es" }

-- With neo-tree no longer claiming directory args, netrw would hijack `nvim .`
-- and render its own listing. Must be set before the plugin loads.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
