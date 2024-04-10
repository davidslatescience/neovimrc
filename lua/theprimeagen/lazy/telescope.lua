return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local ts_select_dir_for_grep = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local fb = require("telescope").extensions.file_browser
            local live_grep = require("telescope.builtin").live_grep
            local current_line = action_state.get_current_line()

            fb.file_browser({
                files = false,
                depth = false,
                attach_mappings = function(prompt_bufnr)
                    require("telescope.actions").select_default:replace(function()
                        local entry_path = action_state.get_selected_entry().Path
                        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
                        local relative = dir:make_relative(vim.fn.getcwd())
                        local absolute = dir:absolute()

                        live_grep({
                            results_title = relative .. "/",
                            cwd = absolute,
                            default_text = current_line,
                        })
                    end)

                    return true
                end,
            })
        end
        require('telescope').setup({
            pickers = {
                find_files = {
                    file_ignore_patterns = { "node_modules", ".git", "%.png", "%.mp3", "Dependencies.js" },
                    hidden = true
                },
                live_grep = {
                    file_ignore_patterns = { "node_modules", ".git", "%.png", "%.mp3", "Dependencies.js" },
                    hidden = true,
                    mappings = {
                        i = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                        n = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                    }
                }
            }
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>kF',
            function() builtin.find_files({ no_ignore = true }) end, {})
        vim.keymap.set('n', '<leader>kf',
            function() builtin.find_files({ no_ignore = false }) end, {})
        --vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        -- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>kws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>kWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ks', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>kg', function() builtin.live_grep() end, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>kb', function() builtin.buffers() end, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>kr', function() builtin.lsp_references() end, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>kds', function() builtin.lsp_document_symbols() end,
            { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>kws', function() builtin.lsp_workspace_symbols() end,
            { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>kdg', function() builtin.lsp_definitions() end, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>ki', function() builtin.lsp_implementations() end, { noremap = true, silent = true })
    end
}
