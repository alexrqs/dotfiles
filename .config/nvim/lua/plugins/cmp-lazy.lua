-- nvim-cmp is already specced `event = "InsertEnter"`, but it loaded at startup
-- anyway: LuaSnip ships with lazy = false and drags in cmp_luasnip's after/plugin
-- file, which requires cmp and pulls the whole stack. Making LuaSnip lazy drops
-- startup from ~120ms to ~60ms and from 12 loaded plugins to 5.
--
-- cmp-nvim-lsp stays eager: LazyVim registers the LSP completion capabilities
-- inside nvim-cmp's opts, so deferring it to InsertEnter would let servers attach
-- with default capabilities (no snippetSupport). default_capabilities() is a pure
-- table builder that does not require cmp, so this costs nothing at startup.
return {
  { "L3MON4D3/LuaSnip", lazy = true },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = false,
    config = function()
      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
    end,
  },
}
