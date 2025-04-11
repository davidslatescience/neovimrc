return {
    "mfussenegger/nvim-lint",
    event = {
        "BufWritePre",
        "BufNewFile"
    },
    config = function()
        -- Following is a good tutorial: https://www.youtube.com/watch?v=ybUE4D80XSk
        local lint = require("lint");

        require('lint').linters.matific_linter = {
            cmd = 'eslint',
            append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
            args = {
                '--config',
                '/Users/daveg/Dev/SlateRoot/Infrastructure/.eslintrc.json',
                -- '.eslintrc.json',
                -- '../../../../../../Dev/SlateRoot/Infrastructure/.eslintrc.json',
                -- '~/Dev/SlateRoot/Infrastructure/.eslintrc.json',
                '--format',
                'json',
                '--stdin',
                '--stdin-filename',
                function() return vim.api.nvim_buf_get_name(0) end,
            },
            stdin = true,            -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
            stream = 'both',       -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
            ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
            env = nil,               -- custom environment table to use with the external process. Note that this             replaces the *entire* environment, it is not additive.
            parser = function(output, bufnr)
                return require("lint.linters.eslint").parser(output, bufnr)
            end
        }
        lint.linters_by_ft = {
            javascript = { "matific_linter" },
            typescript = { "matific_linter" }
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", {
            clear = true,
        })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" },
            {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end
            })

        -- vim.keymap.set("n", "<leader>l", function()
        --     lint.try_lint()
        -- end, {
        --     desc = "Lint"
        -- })

        -- local eslint_d = require('lint').linters.eslint_d
        -- eslint_d.args = {
            -- '--config',
            -- '~/Dev/SlateRoot/Infrastructure/.eslintrc.json',
            -- '--format',
            -- 'json',
            -- '--stdin',
            -- '--stdin-filename',
            -- function() return vim.api.nvim_buf_get_name(0) end,
            -- '../../../../../../Dev/SlateRoot/Infrastructure/.eslintrc.json',
        -- }
        -- local eslint = require('lint').linters.eslint
        -- eslint.args = {
        --     '--config',
        --     '~/Dev/SlateRoot/Infrastructure/.eslintrc.json',
        --     '--format',
        --     'json',
        --     '--stdin',
        --     '--stdin-filename',
        --     function() return vim.api.nvim_buf_get_name(0) end,
        --     -- '../../../../../../Dev/SlateRoot/Infrastructure/.eslintrc.json',
        -- }
    end
}
