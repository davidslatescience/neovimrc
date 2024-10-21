return {
    {
        'nvim-pack/nvim-spectre',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()

            function remove_prefix(str, prefix)
                if str:sub(1, #prefix) == prefix then
                    return str:sub(#prefix + 1)
                else
                    return str
                end
            end

            vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
                desc = "Toggle Spectre"
            })
            vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
                desc = "Search current word"
            })
            vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
                desc = "Search current word"
            })
            vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
                desc = "Search on current file"
            })
            vim.keymap.set('n', '<leader>sP', '<cmd>lua require("spectre").open({cwd=remove_prefix(vim.fn.expand("%:h"), "oil://")})<CR>', {
                desc = "Search on current file"
            })
        end
    }
}
