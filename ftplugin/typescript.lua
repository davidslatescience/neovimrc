vim.opt_local.textwidth = 120
vim.opt_local.colorcolumn = "120"
--vim.opt.com = 'sO:*\\ -,mO:*\\ \\ ,exO:*/,s1:/**,mb:*,ex:*/,://'
-- :set comments="s1:/**,mb:*,ex:*/,://"
-- sO:*\ -,mO:*\ \ ,exO:*/,s1:/**,mb:*,ex:*/,://
-- From the following file:
-- ~/Apps/nvim-macos/share/nvim/runtime/ftplugin/typescript.vim
-- setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

vim.opt.foldmethod = "expr"

function _G.MyFoldExprTypescript()
    if vim.v.lnum == 1 then
        return '>2'
    end
    local line = vim.fn.getline(vim.v.lnum)
    if vim.fn.match(line, '^import') ~= -1 then
        return '2'
    end
  return vim.treesitter.foldexpr()
  -- return vim.fn.getline(vim.v.foldstart)
end
vim.opt.foldexpr = "v:lua.MyFoldExprTypescript()"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "auto"
-- vim.opt.foldlevel = 1000
vim.opt.foldlevel = 1
function _G.MyFoldTextTypescript()
  return vim.fn.getline(vim.v.foldstart)
end
vim.opt.foldtext = 'v:lua.MyFoldTextTypescript()'
