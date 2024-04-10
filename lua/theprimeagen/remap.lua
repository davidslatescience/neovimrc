vim.g.mapleader = " "
vim.keymap.set("n", "<leader>kv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- applies line to previous, but cursor remains in place
vim.keymap.set("n", "J", "mzJ`z")

-- half page jumping cursor remains in the centre
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search terms to stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- NOT NEEDED - Primeagen mappings for twitch
-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)

-- paste without replacing text in buffer (pP would normally replace yank buffer)
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- system clipboard yank
-- can select a paragraph using a p and then paste to the system clip
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete to void register - prevents overwrite of yank text
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- vertical edit mode C-c doesn't work correctly - need to press ESC, so remap it here so they work the same
-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- no operation
vim.keymap.set("n", "Q", "<nop>")

-- switch projects with tmux, allows easy switching via tmux previous session
-- tmux shortcut - Ctrl a L
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quickfix navigation
-- compile navigation
-- https://neovim.io/doc/user/quickfix.html
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- global replace the word that is currently under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- makes a file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- skeleton for inserting quick text
vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- source current file shortcut
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
vim.keymap.set("n", "<leader>inf", "<cmd>e ~/Dev/SlateRoot/Infrastructure<CR>");
vim.keymap.set("n", "<leader>cmd", "<cmd>e ~/Documents/cmds.txt<CR>");
vim.keymap.set("n", "<leader>tod", "<cmd>e ~/Documents/todo.txt<CR>");
vim.keymap.set("n", "<leader>con", "<cmd>e ~/.config/nvim/lua/theprimeagen/remap.lua<CR>");
vim.keymap.set("n", "<leader>not", "<cmd>e ~/Documents/Projects/0001-Setup/notes.txt<CR>");
vim.keymap.set("n", "<leader>inf", "<cmd>e ~/Dev/SlateRoot/Infrastructure<CR>");
vim.keymap.set("n", "<leader>roo", "<cmd>e ~/<CR>");
-- current project directory
vim.keymap.set("n", "<leader>cur", "<cmd>e ~/Dev/SlateRoot/Experiments/Content/episodes/CardsToTen<CR>");

-- shortcut to enter normal mode
vim.keymap.set("i", "kj", "<Esc>", { noremap = true })

-- prefix s will hop to character
vim.keymap.set("n", "s", ":HopChar1<cr>")
-- change copilot completion key
vim.keymap.set('i', '<Right>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- open the LSP error in a floating window
vim.keymap.set("n", "<leader>e", ":lua vim.diagnostic.open_float(0, {scope=\"line\"})<CR>")

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gd', "TSToolsGoToSourceDefinition", opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- loads the file if it has been changed outside of vim
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.keymap.set("n", "<leader>ci", function()
    vim.cmd("TSToolsAddMissingImports")
    -- vim.cmd("TSToolsOrganizeImports")
end, { noremap = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("TS_add_missing_imports", { clear = true }),
--   desc = "TS_add_missing_imports",
--   pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
--   callback = function()
--     vim.cmd([[TSToolsAddMissingImports]])
--     vim.cmd("write")
--   end,
-- })


-- shortcut
--vim.keymap.set("v", "<leader>adq", "'<,'>s/\\w\\+\\ze:/\"&\"", { noremap = true })

vim.keymap.set("n", "<leader>fs", "?public\\|protected\\|private\\|function\\C<CR>Vf(%f{%<CR>", { noremap = true })
vim.keymap.set("n", "N", "/public\\|protected\\|private\\|function\\C<CR>", { noremap = false})
vim.keymap.set("n", "M", "?public\\|protected\\|private\\|function\\C<CR>", { noremap = false})

-- compile shortcut
vim.keymap.set("n", "<leader>cc", ":!clear && tsc -p . ; osascript -e 'tell application \"Google Chrome\" to tell the active tab of its first window to reload'<CR>", { noremap = true })

vim.keymap.set("n", '<C-n>', function()
    require("illuminate").goto_next_reference(true)
end, { noremap = false})
vim.keymap.set("n", '<C-p>', function()
    require("illuminate").goto_prev_reference(true)
end, { noremap = false })
vim.keymap.set("n", '<C-s>', function()
    require("illuminate").textobj_select()
end, { noremap = false })

vim.keymap.set("n", "<leader>cpu", "viwdipublic<ESC>", { noremap = true })
vim.keymap.set("n", "<leader>cpr", "viwdiprivate<ESC>", { noremap = true })


