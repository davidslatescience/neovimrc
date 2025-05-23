vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
-- vim.opt.foldtext = ""
vim.opt.foldcolumn = "auto"
vim.opt.foldlevel = 20
function _G.MyFoldTextJson()
    total_lines = vim.v.foldend - vim.v.foldstart
    line = ""

    for i = 0, total_lines do
        line = line .. vim.fn.getline(vim.v.foldstart + i):gsub("%s+", "")
    end
    return line
end

vim.opt.fillchars = "fold: "
vim.opt.foldtext = 'v:lua.MyFoldTextJson()'

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true
