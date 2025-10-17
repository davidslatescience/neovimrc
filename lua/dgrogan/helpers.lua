-- Helper functions for Neovim configuration
local M = {}

-- ============================================================================
-- Clipboard Functions
-- ============================================================================

-- Copy from system clipboard to vim clipboard and 's' register
function M.copy_from_system_clipboard()
    vim.cmd("let @\"=@+")
    vim.cmd("let @s=@+")
    print("Copied system clipboard to vim clipboard and 's' register")
end

-- Copy from vim clipboard to system clipboard and 's' register
function M.copy_to_system_clipboard()
    vim.cmd("let @+=@\"")
    vim.cmd("let @s=@\"")
    print("Copied vim clipboard to system clipboard and 's' register")
end

-- Interactive clipboard sync - prompts user to choose direction
function M.custom_system_clipboard_copy()
    print("Copy to system clipboard? (Y(es)/N(o)/C(ancel))")
    local char = vim.fn.getcharstr()
    if char == 'Y' or char == 'y' then
        M.copy_to_system_clipboard()
    elseif char == 'N' or char == 'n' then
        M.copy_from_system_clipboard()
    else
        print("Cancelled")
    end
end

-- ============================================================================
-- Text Editing Functions
-- ============================================================================

-- Delete the line below the cursor without moving cursor position (dot repeatable)
function M.delete_line_below_cursor()
    _G.delete_line_below_cursor_callback = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row, row + 1, false, {})
        vim.api.nvim_win_set_cursor(0, { row, col })
    end
    vim.go.operatorfunc = 'v:lua.delete_line_below_cursor_callback'
    vim.api.nvim_feedkeys('g@l', 'n', false)
end

-- Delete the line above the cursor without moving cursor position (dot repeatable)
function M.delete_line_above_cursor()
    _G.delete_line_above_cursor_callback = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        if row > 1 then
            vim.api.nvim_buf_set_lines(0, row - 2, row - 1, false, {})
            vim.api.nvim_win_set_cursor(0, { row - 1, col })
        else
            print("Cannot delete the first line")
        end
    end
    vim.go.operatorfunc = 'v:lua.delete_line_above_cursor_callback'
    vim.api.nvim_feedkeys('g@l', 'n', false)
end

-- Add a comma to the end of the current line (dot repeatable)
function M.add_comma_to_line()
    _G.add_comma_to_line_callback = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        local new_line = line .. ","
        vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
        vim.api.nvim_win_set_cursor(0, { row, col })
    end
    vim.go.operatorfunc = 'v:lua.add_comma_to_line_callback'
    vim.api.nvim_feedkeys('g@l', 'n', false)
end

-- ============================================================================
-- String Utility Functions
-- ============================================================================

-- Truncate a string to a maximum length
local function truncate_string(str, max_length)
    if #str > max_length then
        return string.sub(str, 1, max_length)
    else
        return str
    end
end

-- Remove prefix from string if it exists
function M.oil_remove_prefix(str, prefix)
    if str:sub(1, #prefix) == prefix then
        return str:sub(#prefix + 1)
    else
        return str
    end
end

-- Remove suffix from string if it exists
function M.oil_remove_suffix(str, suffix)
    if str:sub(-#suffix) == suffix then
        return str:sub(1, -#suffix - 1)
    else
        return str
    end
end

-- ============================================================================
-- Region/Fold Insertion Functions
-- ============================================================================

-- Insert a precondition region fold marker (TypeScript/JavaScript editor-fold)
function M.insert_precondition_region_start()
    local input = "Preconditions"
    local editor_fold_text = '        //<editor-fold desc="' .. input .. '" >'

    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    table.insert(lines, current_line, editor_fold_text)
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { current_line, 1 })
end

-- Insert a custom region start with centered text and editor-fold marker
function M.insert_region_start()
    local input = vim.fn.input('Enter text: ')
    local max_length = math.min(119, vim.o.columns)
    local padding = string.rep('=', ((max_length - #input) / 2) - 4)

    local centered_text = '    //' .. padding .. ' ' .. input .. ' ' .. padding .. string.rep('=', max_length)
    centered_text = truncate_string(centered_text, max_length)
    local editor_fold_text = '    //<editor-fold desc="' .. input .. '" >'

    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    table.insert(lines, current_line, "")
    table.insert(lines, current_line, editor_fold_text)
    table.insert(lines, current_line, "")
    table.insert(lines, current_line, centered_text)

    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { current_line, 1 })
end

-- Insert a region end marker to close an editor-fold
function M.insert_region_end()
    local editor_fold_text = '    //</editor-fold>'
    local current_line = vim.api.nvim_win_get_cursor(0)[1] + 1
    local current_buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    table.insert(lines, current_line, editor_fold_text)
    table.insert(lines, current_line, "")

    vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, { current_line, 1 })
end

-- ============================================================================
-- File Formatting Functions
-- ============================================================================

-- Get the file type based on file extension
local function get_file_type()
    local filename = vim.fn.expand("%:t")
    local ext = string.match(filename, "%.([^%.]+)$")

    local filetype_map = {
        json = "json",
        ts = "ts",
    }

    return filetype_map[ext] or "default"
end

-- Format code using custom formatters (fixjson for JSON, fmtfile.sh for TypeScript)
-- Preserves cursor position and folds
function M.format_code(file_path)
    local filetype = get_file_type()

    if filetype == 'json' then
        local command = '%!fixjson -w -i 4'
        local cursorPosition = vim.api.nvim_win_get_cursor(0)
        vim.cmd("mkview")
        vim.cmd(command)
        vim.cmd("loadview")
        vim.api.nvim_win_set_cursor(0, cursorPosition)
    elseif filetype == 'ts' then
        local cursorPosition = vim.api.nvim_win_get_cursor(0)
        vim.cmd("mkview")
        local command = '%!bash ~/bin/fmtfile.sh ' .. file_path .. ' 2>&1'
        vim.cmd(command)
        vim.api.nvim_win_set_cursor(0, cursorPosition)
    else
        print('FileType not supported. Exiting...')
        return
    end
end

-- ============================================================================
-- TypeScript Import Helper Functions
-- ============================================================================

-- Compute relative path from directory to file
local function compute_relative_path(directory, file)
    directory = directory:gsub("\\", "/")
    file = file:gsub("\\", "/")

    local dir_components = {}
    local file_components = {}
    for component in directory:gmatch("[^/]+") do
        table.insert(dir_components, component)
    end
    for component in file:gmatch("[^/]+") do
        table.insert(file_components, component)
    end

    while #dir_components > 0 and #file_components > 0 and dir_components[1] == file_components[1] do
        table.remove(dir_components, 1)
        table.remove(file_components, 1)
    end

    local relative_path = ""
    for _ = 1, #dir_components do
        relative_path = relative_path .. "../"
    end
    for _, component in ipairs(file_components) do
        relative_path = relative_path .. component .. "/"
    end

    relative_path = relative_path:gsub("/$", "")
    return relative_path
end

-- Extract filename from path without extension
local function extract_filename_without_extension(relative_path)
    local last_slash_index = relative_path:match(".*/()")
    local file_name_with_extension = relative_path:sub(last_slash_index)
    local filename_without_extension = file_name_with_extension:match("(.-)%.[^%.]*$")
    return filename_without_extension
end

-- Remove trailing ".d" from TypeScript declaration file names
local function remove_trailing_d(str)
    if str:sub(-2) == ".d" then
        return str:sub(1, -3)
    else
        return str
    end
end

-- Extract file path without extension
local function extract_file_path_without_extension(directory)
    local last_slash_index = directory:match(".*/()")
    local directory_path = directory:sub(1, last_slash_index - 1)
    local file_name_with_extension = directory:sub(last_slash_index)
    local file_path_without_extension = file_name_with_extension:match("(.-)%.[^%.]*$")
    return directory_path .. file_path_without_extension
end

-- Insert TypeScript import statement at beginning of file
local function insert_import_line_at_beginning(line)
    local module_ref = extract_file_path_without_extension(line)
    local module_name = extract_filename_without_extension(line)

    module_ref = remove_trailing_d(module_ref)
    module_name = remove_trailing_d(module_name)

    local module_ref_line = 'import {' .. module_name .. '} from "' .. module_ref .. '";'
    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.bo.modifiable = true
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { module_ref_line })
    vim.bo.modifiable = true

    vim.api.nvim_win_set_cursor(0, cursor)
end

-- Open telescope file picker for Infrastructure typings and insert import statement
function M.insert_typescript_import_from_typings()
    local current_dir = vim.fn.expand('%:p:h')
    require('telescope.builtin').find_files({
        prompt_title = 'Find File',
        cwd = "/Users/daveg/Dev/SlateRoot/Infrastructure/typings",
        hidden = true,
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local selection = require('telescope.actions.state').get_selected_entry()
                if not selection then
                    return
                end
                local selected_file = selection.path
                local relative_path = compute_relative_path(current_dir, selected_file)
                print('Current Path:', current_dir)
                print('Relative Path:', relative_path)
                require('telescope.actions').close(prompt_bufnr)
                insert_import_line_at_beginning(relative_path)
            end)
            return true
        end,
    })
end

-- Insert filename (without extension) at cursor position
local function insert_file_at_cursor_position(file_path)
    local module_name = extract_filename_without_extension(file_path)
    module_name = remove_trailing_d(module_name)
    local cursor = vim.api.nvim_win_get_cursor(0)

    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local nline = line:sub(0, pos) .. module_name .. line:sub(pos + 1)
    vim.api.nvim_set_current_line(nline)

    vim.api.nvim_win_set_cursor(0, cursor)
end

-- Open telescope file picker for a specific directory and insert filename at cursor
function M.insert_file_from_directory(directory)
    local current_dir = vim.fn.expand('%:p:h')
    require('telescope.builtin').find_files({
        prompt_title = 'Find File',
        cwd = directory,
        hidden = true,
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local selection = require('telescope.actions.state').get_selected_entry()
                if not selection then
                    return
                end
                local selected_file = selection.path
                local relative_path = compute_relative_path(current_dir, selected_file)
                require('telescope.actions').close(prompt_bufnr)
                insert_file_at_cursor_position(relative_path)
            end)
            return true
        end,
    })
end

-- ============================================================================
-- Git Functions
-- ============================================================================

-- Show GV (git commit browser) for current Oil.nvim directory
function M.show_gv_for_current()
    local s = string.format(":GV -- %s",
        M.oil_remove_prefix(M.oil_remove_prefix(vim.fn.expand("%:~:p:h"), "oil://"), "/Users/daveg/Dev/SlateRoot/Content/"),
        "/")
    vim.cmd(s)
end

-- ============================================================================
-- LSP Configuration
-- ============================================================================

-- Setup LSP keymaps when LSP attaches to a buffer
function M.setup_lsp_keymaps(ev)
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
end

-- ============================================================================
-- External Editor Functions
-- ============================================================================

-- Open WebStorm with the Infrastructure project
function M.open_webstorm_infra_project()
    local command = 'webstorm ~/Dev/SlateRoot/Infrastructure'
    vim.system({'sh', '-c', command}, {detach = true})
    print("Executed: " .. command)
end

-- Open WebStorm with current buffer at cursor position
function M.open_webstorm_with_current_buffer()
    local full_path = vim.fn.expand('%:p')
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line_number = cursor_pos[1]
    local column_number = cursor_pos[2] + 1

    local command = string.format('webstorm --line %d --column %d %s',
        line_number, column_number, full_path)

    vim.system({'sh', '-c', command}, {detach = true})
    print("Executed: " .. command)
end

-- Open Cursor editor with current buffer at cursor position (internal helper)
local function open_cursor_with_current_buffer_inner(cursorProjectPath)
    local full_path = vim.fn.expand('%:p')
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line_number = cursor_pos[1]
    local column_number = cursor_pos[2] + 1

    local command = string.format('cursor %s --goto %s:%d:%d',
        cursorProjectPath, full_path, line_number, column_number)

    vim.fn.system(command)
    print("Executed: " .. command)
end

-- Open Cursor editor with current buffer using main workspace
function M.open_cursor_with_current_buffer()
    open_cursor_with_current_buffer_inner('~/Dev/SlateRoot/.vscode/*.code-workspace')
end

-- Open Cursor editor with current buffer using local workspace
function M.open_local_cursor_with_current_buffer()
    open_cursor_with_current_buffer_inner('./.vscode/*.code-workspace')
end

return M
