-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Register all http files to be actual http filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.http",
  command = "set filetype=http",
})

vim.o.number = false
vim.opt.relativenumber = false

-- Set conceallevel
vim.o.conceallevel = 2

vim.cmd([[
  augroup JsConceal
    autocmd!
    " autocmd FileType javascript,typescript syntax keyword jsFunc function conceal cchar=λƒ𝑓
    autocmd FileType javascript,typescript syntax keyword jsFunc function conceal cchar=𝑓
    autocmd FileType javascript,typescript syntax keyword jsFunc for conceal cchar=🌀
    autocmd FileType javascript,typescript syntax keyword jsFunc console conceal 
    autocmd FileType javascript,typescript syntax keyword jsNull null conceal cchar=ø
    autocmd FileType javascript,typescript syntax keyword jsThis this conceal cchar=@
    autocmd FileType javascript,typescript syntax keyword jsReturn return conceal cchar=>
    autocmd FileType javascript,typescript syntax keyword jsSuper super conceal cchar=Ω
    autocmd FileType javascript,typescript syntax keyword jsSuper const conceal cchar=c
    autocmd FileType javascript,typescript syntax match jsAndOperator /&&/ conceal cchar=&
    autocmd FileType javascript,typescript syntax match jsBraces /{\|}/ conceal
    autocmd FileType javascript,typescript syntax match jsParens /(\|)/ conceal cchar= 
    " autocmd FileType javascript syntax match jsEqualsOperator /===/ conceal cchar=≡
  augroup END
]])
