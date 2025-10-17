local helpers = require("dgrogan.helpers")

-- ============================================================================
-- Leader Key
-- ============================================================================

vim.g.mapleader = " "

-- ============================================================================
-- Core Navigation & Editing
-- ============================================================================

vim.keymap.set("n", "<leader>kv", vim.cmd.Ex, { desc = "Open netrw" })

-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Join line but keep cursor in place
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line, cursor stays" })

-- Half page jumping with cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })

-- Search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search, centered" })

-- Select entire file
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select entire file" })

-- Save all buffers
vim.keymap.set("n", '<C-s>', ":wa<CR>", { desc = "Save all buffers" })

-- ============================================================================
-- Clipboard Operations
-- ============================================================================

-- Paste without replacing yank buffer
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without replacing yank" })

-- System clipboard operations
vim.keymap.set({ "n", "v" }, "<A-y>", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>y", helpers.custom_system_clipboard_copy, { desc = "Interactive clipboard sync" })

-- Delete to void register (preserves yank)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- ============================================================================
-- LSP & Diagnostics
-- ============================================================================

-- Format current buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP format buffer" })

-- Open diagnostic float
vim.keymap.set("n", "<F1>", ":lua vim.diagnostic.open_float(0, {scope=\"line\"})<CR>", { desc = "Open diagnostic float" })

-- LSP keymaps (set on LspAttach)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', ":vsplit | TSToolsGoToSourceDefinition<CR>", opts)
        vim.keymap.set('n', 'gd', "TSToolsGoToSourceDefinition", opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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

-- ============================================================================
-- Quickfix Navigation
-- ============================================================================

vim.keymap.set("n", ']q', ':cn<CR>', { desc = "Next quickfix" })
vim.keymap.set("n", '[q', ':cp<CR>', { desc = "Previous quickfix" })

-- ============================================================================
-- Search & Replace
-- ============================================================================

-- Global replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Global replace word under cursor" })

-- ============================================================================
-- File Operations
-- ============================================================================

-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- ============================================================================
-- TypeScript/JavaScript Specific
-- ============================================================================

-- Text skeletons for quick insertion
vim.keymap.set("n", "<leader>es", "O/** @inheritDoc */<ESC>", { desc = "Insert @inheritDoc comment" })
vim.keymap.set("n", "<leader>ee", "O/**\n<ESC>0i     * [TODO]\n<ESC>0i     */<ESC>?\\[TODO\\]<CR>gn", { desc = "Insert TODO comment block" })

-- Region/fold insertion
vim.keymap.set("n", "<leader>erp", helpers.insert_precondition_region_start, { desc = "Insert precondition region" })
vim.keymap.set("n", "<leader>ers", helpers.insert_region_start, { desc = "Insert region start" })
vim.keymap.set("n", "<leader>ere", helpers.insert_region_end, { desc = "Insert region end" })

-- TypeScript imports and organization
vim.keymap.set("n", "<leader>ci", function()
    vim.cmd("TSToolsAddMissingImports")
    vim.cmd("TSToolsOrganizeImports")
end, { noremap = true, desc = "Organize imports" })

vim.keymap.set("n", "<leader>in", helpers.find_file_and_compute_relative_path, { noremap = true, desc = "Insert import from typings" })

-- Insert file from specific directories
vim.keymap.set("n", "<leader>is",
    function() helpers.insert_file_from_directory("/Users/daveg/Dev/SlateRoot/Content/MathEpisodes/episodes/HistoryTimeline/audio/Main") end,
    { noremap = true, desc = "Insert sound file" })
vim.keymap.set("n", "<leader>ii",
    function() helpers.insert_file_from_directory("/Users/daveg/Dev/SlateRoot/Content/MathEpisodes/episodes/NumberLineInequalities/images") end,
    { noremap = true, desc = "Insert image file" })

-- Change visibility modifiers
vim.keymap.set("n", "<leader>cpu", "viwdipublic<ESC>", { noremap = true, desc = "Change to public" })
vim.keymap.set("n", "<leader>cpr", "viwdiprivate<ESC>", { noremap = true, desc = "Change to private" })

-- Custom file formatting
vim.keymap.set("n", "<leader>ff", function()
    helpers.format_code(vim.fn.expand("%:p"))
end, { noremap = true, desc = "Format file (custom)" })

-- Navigate illuminate references
vim.keymap.set("n", '<C-n>', function()
    require("illuminate").goto_next_reference(true)
end, { desc = "Next reference (illuminate)" })
vim.keymap.set("n", '<C-p>', function()
    require("illuminate").goto_prev_reference(true)
end, { desc = "Previous reference (illuminate)" })

-- TypeScript compilation shortcuts
vim.keymap.set("n", "<leader>cc",
    ":wa<CR>:!clear && ~/bin/create_infra_declarations.sh && tsc -p . ; osascript -e 'tell application \"Google Chrome\" to tell the active tab of its first window to reload'<CR>",
    { noremap = true, silent = true, desc = "Compile and reload Chrome" })

vim.keymap.set("n", "<leader>cd",
    ":wa<CR>:compiler tsc<CR>:make<CR>",
    { noremap = true, silent = true, desc = "Compile with tsc (quickfix)" })

-- ESLint shortcuts
vim.keymap.set("n", '<leader>cl',
    ':cex system("eslint \\\"./src/**/*.ts\\\" --config ~/Dev/SlateRoot/Infrastructure/.eslintrc.json --format compact")<CR>',
    { noremap = false, desc = "ESLint to quickfix" })

vim.keymap.set("n", '<leader>cp',
    ':cex system("eslint \\\"./src/**/*.ts\\\" --config ~/Dev/SlateRoot/Infrastructure/.eslintrc.json --format compact | grep -v -e \\\"no-explicit-any\\\" -e \\\"no-generic-types\\\" -e \\\"typescript-eslint/typedef\\\"")',
    { noremap = false, desc = "ESLint filtered to quickfix" })

-- ============================================================================
-- Git Operations
-- ============================================================================

vim.keymap.set("n", '<leader>gv', helpers.show_gv_for_current, { noremap = false, desc = "Git history for current directory" })
vim.keymap.set("n", "<leader>gc",
    ":wa<CR>:!clear && ~/bin/auto_commit.sh --all --quiet .<CR>",
    { noremap = true, silent = true, desc = "Auto commit" })

-- ============================================================================
-- External Editor Integration
-- ============================================================================

vim.keymap.set('n', '<leader>wp', helpers.open_webstorm_infra_project, { desc = "Open WebStorm infra project" })
vim.keymap.set('n', '<leader>ws', helpers.open_webstorm_with_current_buffer, { desc = "Open WebStorm with current buffer" })
vim.keymap.set('n', '<leader>cs', helpers.open_cursor_with_current_buffer, { desc = "Open Cursor with current buffer" })
vim.keymap.set('n', '<leader>cx', helpers.open_local_cursor_with_current_buffer, { desc = "Open local Cursor with current buffer" })

-- ============================================================================
-- File Navigation & Quick Access
-- ============================================================================

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)" })
vim.keymap.set("n", "<leader>ma", ":<C-u>marks<CR>:normal! `", { desc = "List marks" })

-- Quick file shortcuts
vim.keymap.set("n", "<leader>inf", "<cmd>e ~/Dev/SlateRoot/Infrastructure<CR>", { desc = "Open Infrastructure" })
vim.keymap.set("n", "<leader>rmd", "<cmd>e ~/Documents/cmds.txt<CR>", { desc = "Open cmds.txt" })
vim.keymap.set("n", "<leader>tod", "<cmd>e ~/Documents/todo.txt<CR>", { desc = "Open todo.txt" })
vim.keymap.set("n", "<leader>rmp", "<cmd>e ~/.config/nvim/lua/dgrogan/remap.lua<CR>", { desc = "Open remap.lua" })
vim.keymap.set("n", "<leader>not", "<cmd>e ~/Documents/Projects/0002-OrthodontistDecimals/docs/notes.txt<CR>", { desc = "Open notes.txt" })
vim.keymap.set("n", "<leader>roo", "<cmd>e ~/<CR>", { desc = "Open home directory" })
vim.keymap.set("n", "<leader>cur", "<cmd>e ~/Dev/SlateRoot/Experiments/Content/episodes/CardsToTen<CR>", { desc = "Open current project" })

-- ============================================================================
-- Advanced Text Editing
-- ============================================================================

-- Delete lines without moving cursor (dot repeatable)
vim.keymap.set("n", '[<del>', helpers.delete_line_above_cursor, { noremap = true, silent = true, desc = "Delete line above" })
vim.keymap.set("n", ']<del>', helpers.delete_line_below_cursor, { noremap = true, silent = true, desc = "Delete line below" })

-- Add space under cursor
vim.keymap.set("n", '<M-Space>', [[i <esc>i]], { noremap = true, silent = true, desc = "Add space at cursor" })

-- Add comma to end of line
vim.keymap.set("n", '<leader>,', helpers.add_comma_to_line, { noremap = true, silent = true, desc = "Add comma to line end" })

-- Surround mapping
vim.cmd [[vmap <Space>r <Plug>VSurround]]

-- ============================================================================
-- Terminal
-- ============================================================================

vim.keymap.set("n", "<leader>ter", "::let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>Acd $VIM_DIR<CR>", { noremap = true, desc = "Open terminal in file directory" })

-- ============================================================================
-- Custom Commands
-- ============================================================================

vim.cmd [[command! -nargs=0 Tg :tab G]]
vim.cmd [[command! -nargs=0 Q :q]]
vim.cmd [[command! -nargs=0 X :x]]
vim.cmd [[command! -nargs=0 GVo :lua require("dgrogan.helpers").show_gv_for_current()]]
vim.api.nvim_create_user_command('OpenWebstormProject', helpers.open_webstorm_infra_project, {})
vim.api.nvim_create_user_command('OpenWebstorm', helpers.open_webstorm_with_current_buffer, {})
vim.api.nvim_create_user_command('OpenCursor', helpers.open_cursor_with_current_buffer, {})

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Auto-reload files changed externally
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
    desc = "Auto-reload files changed externally"
})

-- Save and load folds automatically
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = { "*.*" },
    desc = "Save view (folds) when closing file",
    command = "mkview",
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = { "*.*" },
    desc = "Load view (folds) when opening file",
    command = "silent! loadview"
})

-- ============================================================================
-- Copilot Configuration
-- ============================================================================

vim.g.copilot_no_tab_map = false
