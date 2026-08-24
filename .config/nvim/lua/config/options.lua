-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Spanish alongside English so mixed-language notes don't flag either one
vim.opt.spelllang = { "en", "es" }

-- With neo-tree no longer claiming directory args, netrw would hijack `nvim .`
-- and render its own listing. Must be set before the plugin loads.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Unused language providers; skipping their host lookup saves ~5ms.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
