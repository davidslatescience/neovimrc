return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
    },

    config = function()
        require('telescope').setup({
            defaults = {
                layout_config = {
                    horizontal = { width = 0.99 }
                },
                path_display = {
                    shorten = 1
                },
                dynamic_preview_title = true,
            },
            pickers = {
                find_files = {
                    file_ignore_patterns = { "node_modules", ".git", "%.jpg", "%.png", "%.mp3", "Dependencies.js" },
                    hidden = true,
                },
            },
            extensions = {
                live_grep_args = {
                    auto_quoting = true,
                    file_ignore_patterns = { "node_modules", ".git", "%.jpg", "%.png", "%.mp3", "Dependencies.js" },
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                        },
                    },
                }
            }
        })

        require('telescope').load_extension('refactoring')
        vim.keymap.set(
            { "n", "x" },
            "<leader>rr",
            function() require('telescope').extensions.refactoring.refactors() end
        )
        require('telescope').load_extension('live_grep_args')
        local lga = require('telescope').extensions.live_grep_args
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>kF',
            function() builtin.find_files({ no_ignore = true }) end, {})
        vim.keymap.set('n', '<leader>kf',
            function() builtin.find_files({ no_ignore = false }) end, {})
        -- vim.keymap.set('n', '<leader>kws', function()
        --     local word = vim.fn.expand("<cword>")
        --     builtin.grep_string({ search = word })
        -- end)
        vim.keymap.set('n', '<leader>kin',
            function() builtin.find_files({ cwd = "/Users/daveg/Dev/SlateRoot/Infrastructure" }) end, {})
        -- telescope.find_files({
        --    prompt_title = 'Find File',
        --    cwd = "/Users/daveg/Dev/SlateRoot/Infrastructure",
        --    -- cwd = vim.fn.expand('%:p:h'), -- Set the current working directory to the directory of the current file
        --    hidden = true, -- Include hidden files

        vim.keymap.set('n', '<leader>kWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>kg', function() lga.live_grep_args() end, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader><Up>', function()
            builtin.buffers(
                {
                    sort_mru = true,
                    ignore_current_buffer = true
                })
        end, { noremap = true, silent = true })
        -- LSP References
        vim.keymap.set('n', '<leader>kr', function() builtin.lsp_references() end, { noremap = true, silent = true })
        -- Property document symbols
        vim.keymap.set('n', '<leader>kdp',
            function() builtin.lsp_document_symbols({ symbol_width = 80, symbols = { "property" } }) end,
            { noremap = true, silent = true })
        -- Method document symbols
        vim.keymap.set('n', '<leader>kdf',
            function() builtin.lsp_document_symbols({ symbol_width = 80, symbols = { "method" } }) end,
            { noremap = true, silent = true })
        -- All document symbols
        vim.keymap.set('n', '<leader>kds', function() builtin.lsp_document_symbols() end,
            { noremap = true, silent = true })
        -- Workspace symbols
        vim.keymap.set('n', '<leader>kws', function() builtin.lsp_workspace_symbols() end,
            { noremap = true, silent = true })
        -- Definitions
        vim.keymap.set('n', '<leader>kdg', function() builtin.lsp_definitions() end, { noremap = true, silent = true })
        vim.keymap.set('n', '<leader>ki', function() builtin.lsp_implementations() end, { noremap = true, silent = true })
        -- Resume current search
        vim.keymap.set('n', '<leader>q', function() builtin.resume() end, { noremap = true, silent = true })
        -- grep in the current file
        vim.keymap.set('n', '<leader>kG', function() builtin.live_grep({ search_dirs = { vim.fn.expand("%:p") } }) end,
            { noremap = true, silent = true })
        -- vim.keymap.set('n', '<leader>kD', function() builtin.live_grep({ search_dirs = { string.match(vim.fn.expand("%:h"), "^oil:\\/\\/(.*)") } }) end,
        --     { noremap = true, silent = true })
        -- Grep in the current directory
        vim.keymap.set('n', '<leader>kD', function() builtin.live_grep({ search_dirs = { vim.fn.expand("%:p:h") } }) end,
            { noremap = true, silent = true })
        -- vim.keymap.set('n', '<leader>ks', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)
        -- vim.keymap.set('n', '<leader>ks',
        --     function()
        --         builtin.grep_string({
        --             search_dirs = { vim.fn.expand("%:p") },
        --             use_regex = true,
        --             disable_coordinates = true,
        --             search =
        --             "^    //<editor-fold desc=",
        --             only_sort_text = true
        --         })
        --     end)
        -- View all Actions
        vim.keymap.set('n', '<leader>ka',
            function()
                builtin.grep_string({
                    search_dirs = { vim.fn.expand("%:p") },
                    use_regex = true,
                    disable_coordinates = true,
                    search =
                    "\"actionType\": ",
                    only_sort_text = true
                })
            end)
        -- All Templates and Placements
        vim.keymap.set('n', '<leader>kt',
            function()
                builtin.grep_string({
                    search_dirs = { vim.fn.expand("%:p") },
                    use_regex = true,
                    disable_coordinates = true,
                    search =
                    "^        \"[a-zA-Z0-9]*\": \\{$",
                    only_sort_text = true
                })
            end)

        -- Story shortcuts
        vim.keymap.set('n', '<leader>kss',
            function() builtin.find_files({ cwd = "config/storyline/episode_variants/elgar_orthodontist_burnt_storyline/stories" }) end, {})
        vim.keymap.set('n', '<leader>ksc',
            function() builtin.find_files({
                cwd = "config/storyline/episode_variants/elgar_orthodontist_burnt_storyline/conversation_configs" }) end, {})
        vim.keymap.set('n', '<leader>ksd',
            function() builtin.find_files({
                cwd = "config/scenes/story" }) end, {})
    end
}
