-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "yaml" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- `nvim .` should land on an empty buffer, not a directory listing. cd into the
-- directory first so root detection and pickers scope to it.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc(-1) ~= 1 then
      return
    end
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) ~= 1 then
      return
    end
    local dirbuf = vim.api.nvim_get_current_buf()
    vim.cmd.cd(arg)
    vim.cmd.enew()
    if vim.api.nvim_buf_is_valid(dirbuf) then
      vim.api.nvim_buf_delete(dirbuf, { force = true })
    end
  end,
})
