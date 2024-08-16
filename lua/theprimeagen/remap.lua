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
    -- "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
    "O/**<CR> * [TODO]<CR>*/<ESC>?\\[TODO\\]<CR>gn"
)
-- skeleton for inserting quick text
-- vim.keymap.set(
--     "n",
--     "<leader>es",
--     "O//================================================= [TODO] ====================================================================================<CR><BS><BS><BS><CR>//<editor-fold desc=\"[TODO]\" ><ESC>?\\[TODO\\]<CR>gn"
-- )

function truncateString(str, maxLength)
    if #str > maxLength then
        return string.sub(str, 1, maxLength)
    else
        return str
    end
end

function InsertPreconditionRegionStart()
    -- Prompt user for input
    local input = "Preconditions"

    local editor_fold_text = '        //<editor-fold desc=\"' .. input .. '\" >'

    -- Get the line number of the current cursor position
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    -- Get the current buffer
    local current_buf = vim.api.nvim_get_current_buf()

    -- Get all lines from the buffer
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    -- Insert the centered text into the previous line
    table.insert(lines, current_line, editor_fold_text)

    -- Update the buffer with the modified lines
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)

    -- Move cursor to the start of the newly inserted line
    vim.api.nvim_win_set_cursor(0, { current_line, 1 })
end

function InsertRegionStart()
    -- Prompt user for input
    local input = vim.fn.input('Enter text: ')

    -- Calculate the maximum length for the centered text
    local max_length = math.min(119, vim.o.columns)

    -- Calculate padding for centering
    local padding = string.rep('=', ((max_length - #input) / 2) - 4)

    -- Construct the centered text surrounded by '=' signs
    local centered_text = '    //' .. padding .. ' ' .. input .. ' ' .. padding .. string.rep('=', max_length)
    centered_text = truncateString(centered_text, max_length)
    local editor_fold_text = '    //<editor-fold desc=\"' .. input .. '\" >'

    -- Get the line number of the current cursor position
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    -- Get the current buffer
    local current_buf = vim.api.nvim_get_current_buf()

    -- Get all lines from the buffer
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    -- Insert the centered text into the previous line
    table.insert(lines, current_line, "")
    table.insert(lines, current_line, editor_fold_text)
    table.insert(lines, current_line, "")
    table.insert(lines, current_line, centered_text)

    -- Update the buffer with the modified lines
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)

    -- Move cursor to the start of the newly inserted line
    vim.api.nvim_win_set_cursor(0, { current_line, 1 })
end

function InsertRegionEnd()
    local editor_fold_text = '    //</editor-fold>'

    -- Get the line number of the current cursor position
    local current_line = vim.api.nvim_win_get_cursor(0)[1] + 1

    -- Get the current buffer
    local current_buf = vim.api.nvim_get_current_buf()

    -- Get all lines from the buffer
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    -- Insert the centered text into the previous line
    table.insert(lines, current_line, editor_fold_text)
    table.insert(lines, current_line, "")

    -- Update the buffer with the modified lines
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)

    -- Move cursor to the start of the newly inserted line
    vim.api.nvim_win_set_cursor(0, { current_line, 1 })
end

vim.keymap.set("n", "<leader>erp", InsertPreconditionRegionStart)
vim.keymap.set("n", "<leader>ers", InsertRegionStart)
vim.keymap.set("n", "<leader>ere", InsertRegionEnd)

vim.keymap.set("n", "<leader>inf", "<cmd>e ~/Dev/SlateRoot/Infrastructure<CR>");
vim.keymap.set("n", "<leader>rmd", "<cmd>e ~/Documents/cmds.txt<CR>");
vim.keymap.set("n", "<leader>tod", "<cmd>e ~/Documents/todo.txt<CR>");
vim.keymap.set("n", "<leader>rmp", "<cmd>e ~/.config/nvim/lua/theprimeagen/remap.lua<CR>");
vim.keymap.set("n", "<leader>not", "<cmd>e ~/Documents/Projects/0002-OrthodontistDecimals/docs/notes.txt<CR>");
vim.keymap.set("n", "<leader>inf", "<cmd>e ~/Dev/SlateRoot/Infrastructure<CR>");
vim.keymap.set("n", "<leader>roo", "<cmd>e ~/<CR>");
-- current project directory
vim.keymap.set("n", "<leader>cur", "<cmd>e ~/Dev/SlateRoot/Experiments/Content/episodes/CardsToTen<CR>");

-- shortcut to enter normal mode
vim.keymap.set("i", "kj", "<Esc>", { noremap = true })

-- change copilot completion key
vim.keymap.set('i', '<Right>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- open the LSP error in a floating window
vim.keymap.set("n", "<leader>e", ":lua vim.diagnostic.open_float(0, {scope=\"line\"})<CR>")

-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

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
-- vim.o.autoread = true
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
--     command = "if mode() != 'c' | checktime | endif",
--     pattern = { "*" },
-- })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})

vim.keymap.set("n", "<leader>ci", function()
    vim.cmd("TSToolsAddMissingImports")
    vim.cmd("TSToolsOrganizeImports")
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

-- Not needed due to treesitter text objects
-- vim.keymap.set("n", "<leader>fs", "?public\\|protected\\|private\\|function\\C<CR>Vf(%f{%<CR>", { noremap = true })
-- vim.keymap.set("n", "N", "/public\\|protected\\|private\\|function\\C<CR>", { noremap = false})
-- vim.keymap.set("n", "M", "?public\\|protected\\|private\\|function\\C<CR>", { noremap = false})

-- compile shortcut
vim.keymap.set("n", "<leader>cc",
    ":!clear && tsc -p . ; osascript -e 'tell application \"Google Chrome\" to tell the active tab of its first window to reload'<CR>",
    { noremap = true, silent = true })

vim.keymap.set("n", '<C-n>', function()
    require("illuminate").goto_next_reference(true)
end, { noremap = false })
vim.keymap.set("n", '<C-p>', function()
    require("illuminate").goto_prev_reference(true)
end, { noremap = false })
vim.keymap.set("n", '<C-s>', function()
    require("illuminate").textobj_select()
end, { noremap = false })

vim.keymap.set("n", "<leader>cpu", "viwdipublic<ESC>", { noremap = true })
vim.keymap.set("n", "<leader>cpr", "viwdiprivate<ESC>", { noremap = true })
-- fix json
-- vim.keymap.set("n", "<leader>fj", ":!fixjson -w %<CR>", { noremap = true, silent = true })
-- format file
local function getFileType()
    local filename = vim.fn.expand("%:t")             -- Get the filename without path
    local ext = string.match(filename, "%.([^%.]+)$") -- Extract the file extension

    -- Map file extensions to file types
    local filetype_map = {
        json = "json",
        ts = "ts",
        -- Add more mappings as needed
    }

    return filetype_map[ext] or "default"
end
-- Define the Lua function
function FormatCode(file_path)
    -- get the file type
    local filetype = getFileType()

    print("Formatting file: " .. file_path .. " with filetype: " .. filetype)

    local result = ""

    if filetype == 'json' then
        local command = '!fixjson -w ' .. file_path .. ''
        -- vim.cmd("!fixjson -w %<CR>")
        vim.cmd(command)

        -- reload the current buffer
        vim.cmd("e")

        -- Print the output to the Neovim console
        print(result)
    elseif filetype == 'ts' then
        -- local a = require 'plenary.async'
        -- local tx, rx = a.control.channel.oneshot()
        --
        -- a.run(function()
        --     local command = 'bash ~/bin/fmtfile.sh ' .. file_path .. ' 2>&1'
        --     local handle = io.popen(command)
        --     local result = handle:read('*a')
        --     handle:close()
        --
        --     --local ret = long_running_fn()
        --     tx(result)
        -- end)

        --local ret = rx()


        -- local Job = require 'plenary.job'
        -- Job:new({
        --     command = 'bash',
        --     args = { '-c', '~/bin/fmtfile.sh ' .. file_path .. ' 2>&1' },
        --     -- cwd = '/usr/bin',
        --     -- env = { ['a'] = 'b' },
        --     on_exit = function(j, return_val)
        --         -- vim.api.nvim_command('checktime')
        --         -- checktime()
        --         -- vim.checktime()
        --         -- vim.cmd("e")
        --         print(return_val)
        --         print(j:result())
        --     end,
        -- -- }):sync() -- or start()
        -- }):sync() -- or start()

        -- vim.api. u
        -- vim.cmd("checktime")
        -- vim.cmd("redo")

        -- vim.cmd("e!")
        -- vim.api.nvim_command('checktime')
        -- local function on_done()
        -- end
        -- vim.api.nvim_create_autocmd("'bash ~/bin/fmtfile.sh ' .. file_path .. ' 2>&1'", { callback = on_done })

        -- Execute the Bash script synchronously and capture its output
        -- local command = 'bash ~/bin/fmt.sh 2>&1'
        local command = 'bash ~/bin/fmtfile.sh ' .. file_path .. ' 2>&1'
        local handle = io.popen(command)
        local result = handle:read('*a')
        handle:close()
        -- reload the current buffer
        -- vim.wait(2000, function() end)
        -- vim.cmd("e")

        -- Print the output to the Neovim console
        print(result)
    else
        print('FileType not supported. Exiting...')
        return
    end

    -- Reload the current buffer
    vim.cmd("checktime")
    vim.cmd("redo")
    vim.cmd("LspRestart")
end

vim.keymap.set("n", "<leader>ff", '<cmd>lua FormatCode(vim.fn.expand("%:p"))<CR>', { noremap = true })
-- vim.keymap.set("n", "<leader>ff", ":!~/bin/fmtfile.sh %<CR>", { noremap = true, silent = true })

-- open terminal in files directory
vim.keymap.set("n", "<leader>ter", "::let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>Acd $VIM_DIR<CR>", { noremap = true })


local function compute_relative_path(directory, file)
    -- Normalize directory and file paths
    directory = directory:gsub("\\", "/") -- Convert backslashes to forward slashes
    file = file:gsub("\\", "/")           -- Convert backslashes to forward slashes

    -- Split paths into components
    local dir_components = {}
    local file_components = {}
    for component in directory:gmatch("[^/]+") do
        table.insert(dir_components, component)
    end
    for component in file:gmatch("[^/]+") do
        table.insert(file_components, component)
    end

    -- Remove common components
    while #dir_components > 0 and #file_components > 0 and dir_components[1] == file_components[1] do
        table.remove(dir_components, 1)
        table.remove(file_components, 1)
    end

    -- Build relative path
    local relative_path = ""
    for _ = 1, #dir_components do
        relative_path = relative_path .. "../"
    end
    for _, component in ipairs(file_components) do
        relative_path = relative_path .. component .. "/"
    end

    -- Remove trailing slash
    relative_path = relative_path:gsub("/$", "")

    return relative_path
end
local function extract_filename_without_extension(relative_path)
    -- Find the last occurrence of '/' in the relative path
    local last_slash_index = relative_path:match(".*/()")

    -- Extract the file name with extension
    local file_name_with_extension = relative_path:sub(last_slash_index)

    -- Remove the extension
    local filename_without_extension = file_name_with_extension:match("(.-)%.[^%.]*$")

    return filename_without_extension
end
local function remove_trailing_d(str)
    if str:sub(-2) == ".d" then
        return str:sub(1, -3) -- Remove last two characters
    else
        return str            -- No trailing '.d', return original string
    end
end
local function extract_file_path_without_extension(directory)
    -- Find the last occurrence of '/' in the directory string
    local last_slash_index = directory:match(".*/()")

    -- Extract the directory path
    local directory_path = directory:sub(1, last_slash_index - 1)

    -- Extract the file name
    local file_name_with_extension = directory:sub(last_slash_index)

    -- Remove the extension
    local file_path_without_extension = file_name_with_extension:match("(.-)%.[^%.]*$")

    -- Concatenate the directory path and file name
    return directory_path .. file_path_without_extension
end

local function insert_import_line_at_beginning(line)
    local module_ref = extract_file_path_without_extension(line)
    local module_name = extract_filename_without_extension(line)

    module_ref = remove_trailing_d(module_ref)
    module_name = remove_trailing_d(module_name)

    local module_ref_line = 'import {' .. module_name .. '} from \"' .. module_ref .. '\";'
    -- Save current cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)

    -- Move cursor to the beginning of the buffer
    vim.api.nvim_buf_set_option(0, 'modifiable', true)
    -- vim.api.nvim_buf_set_lines(0, 0, 0, false, {module_ref_line, ''})
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { module_ref_line })
    vim.api.nvim_buf_set_option(0, 'modifiable', true)

    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor)
end
function find_file_and_compute_relative_path()
    local current_dir = vim.fn.expand('%:p:h')
    require('telescope.builtin').find_files({
        prompt_title = 'Find File',
        cwd = "/Users/daveg/Dev/SlateRoot/Infrastructure/src/typings",
        -- cwd = vim.fn.expand('%:p:h'), -- Set the current working directory to the directory of the current file
        hidden = true, -- Include hidden files
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local selection = require('telescope.actions.state').get_selected_entry()
                if not selection then
                    return
                end
                local selected_file = selection.path
                local relative_path = compute_relative_path(current_dir, selected_file)
                -- print('Selected File:', normalized_selected_file)
                print('Current Path:', current_dir)
                print('Relative Path:', relative_path)
                -- print('Current Path:', normalized_cwd)
                -- vim.cmd('edit ' .. selected_file)
                require('telescope.actions').close(prompt_bufnr)
                insert_import_line_at_beginning(relative_path)
            end)
            return true
        end,
    })
end

vim.keymap.set("n", "<leader>in", '<cmd>lua find_file_and_compute_relative_path()<CR>', { noremap = true })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- select selection
-- select left
-- select Right
-- move to next
-- move to previous
--

vim.keymap.set("n", "<C-a>", "ggVG", { desc = "select entire file" })

vim.keymap.set("n", "<leader>ma", ":<C-u>marks<CR>:normal! `", { desc = "list marks" })


