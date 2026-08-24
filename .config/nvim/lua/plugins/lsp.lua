return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript 7 (the Go rewrite) speaks LSP natively via `tsc --lsp`.
        -- lspconfig's tsc config prefers a project-local binary, which here is
        -- 5.9.2 and has no --lsp flag, so point at the bun-global 7.x instead.
        -- Editor diagnostics therefore come from TS7 while the repo still
        -- builds with its pinned 5.9.2 -- they can disagree in edge cases.
        tsc = {
          cmd = { vim.fn.expand("~/.bun/bin/tsc"), "--lsp", "--stdio" },
          mason = false,
        },
        -- superseded by tsc above
        vtsls = { enabled = false },

        -- Restores what the removed linting.eslint extra used to set: without
        -- it eslint resolves config from the monorepo root instead of the
        -- package that owns the file.
        eslint = {
          settings = { workingDirectories = { mode = "auto" } },
        },
      },
    },
  },
}
