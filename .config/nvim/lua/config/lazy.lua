local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },

    -- NOTE: Neovim plugin for automatically highlighting other uses
    -- of the word under the cursor using either LSP, Tree-sitter, or regex matching.
    { import = "lazyvim.plugins.extras.editor.illuminate" },
    -- {
    --   import = "lazyvim.plugins.extras.editor.mini-move",
    --   config = function()
    --     require("mini.move").setup({
    --       -- Module mappings. Use `''` (empty string) to disable one.
    --       mappings = {
    --         -- Move visual selection in Visual mode. Using Option (Alt) + hjkl.
    --         left = "<M-h>",
    --         right = "<M-l>",
    --         down = "<C-S-j>",
    --         up = "<C-S-k>",
    --
    --         -- Move current line in Normal mode
    --         line_left = "<M-h>",
    --         line_right = "<M-l>",
    --         line_down = "<C-S-j>",
    --         line_up = "<C-S-k>",
    --       },
    --
    --       -- Options for moving visual selection in Visual mode
    --       options = {
    --         -- Automatically reindent selection during linewise vertical move
    --         reindent_linewise = true,
    --       },
    --     })
    --   end,
    -- },
    -- { import = "lazyvim.plugins.extras.editor.leap" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },

  -- NOTE: Initial colorsheme even when lazy is installing packages
  install = { colorscheme = { "catppuccin-mocha" } },

  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
