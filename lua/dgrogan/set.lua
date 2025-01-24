--vim.opt.guicursor = ""


vim.opt.autoread = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 24
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

-- error formats for eslint
vim.opt.errorformat = {'%f: line %l\\, col %c\\, %trror - %m', '%f: line %l\\, col %c\\, %tarning - %m'}

-- cursor will move up and down vertically in the same column
vim.opt.virtualedit = "all"

-- show the column the cursor is on
vim.opt.cursorcolumn = true

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- -- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
-- -- vim.opt.foldtext = ""
-- vim.opt.foldcolumn = "auto"
-- vim.opt.foldlevel = 1
-- function _G.MyFoldText()
--   return vim.fn.getline(vim.v.foldstart)
-- end
-- vim.opt.foldtext = 'v:lua.MyFoldText()'
--
