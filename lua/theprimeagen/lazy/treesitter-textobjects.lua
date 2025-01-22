return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    config = function()
        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                        ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                        ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                        ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
                        --
                        ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                        -- ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                        -- ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
                        --
                        -- ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                        -- ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                        ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                        ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                        -- ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
                        ["am"] = { query = "@method", desc = "Select outer part of a method/function definition" },
                        ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

                        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

                        ["ak"] = { query = "@class_constant", desc = "Select outer part of class constant" },
                        -- ["aj"] = { query = "@object", desc = "Select outer part of object" },
                        ["aj"] = { query = "@object", desc = "Select outer part of object" },
                        ["r:"] = { query = "@json_value.inner", desc = "Select the json value" },
                        ["l:"] = { query = "@json_key.inner", desc = "Select the json key" },

                    },
                    include_surrounding_whitespace = false,
                    selection_modes = {
                        ['@object'] = 'V', -- linewise
                        ['@method'] = 'V', -- linewise
                    },
                },

                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
                        -- ["<leader>nm"] = "@function.outer",  -- swap function with next
                        ["<leader>nj"] = "@object",          -- swae function with next
                        ["<leader>nm"] = "@method",      -- swap function with next
                    },
                    swap_previous = {
                        ["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
                        -- ["<leader>pm"] = "@function.outer",  -- swap function with previous
                        ["<leader>pj"] = "@object",          -- swap function with previous
                        ["<leader>pm"] = "@method",      -- swap function with previous
                    },
                },

                move = {
                    enable = true,
                    -- set_jumps = true,     -- whether to set jumps in the jumplist
                    goto_next_start = {

                        ["]f"] = { query = "@function_call_name", desc = "Next function call start" },
                        ["]m"] = { query = "@method_name", desc = "Next method/function def start" },
                        ["]p"] = { query = "@parameter.inner", desc = "Next parameter start" },
                        ["]j"] = { query = "@class_or_object_name", desc = "Next class name start" },
                        ["]s"] = { query = "@section_header_fold", desc = "Next scope" },
                        ["]k"] = { query = "@class_constant_name", desc = "Next class constant" },
                        ["]l"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["]r"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        ["]t"] = { query = "@type_identifier", desc = "Type identifier" },
                    },
                    goto_next_end = {

                        ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                        ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
                        ["]P"] = { query = "@parameter.inner", desc = "Next parameter end" },
                        ["]S"] = { query = "@section_footer", desc = "Next scope end" },
                        ["]J"] = { query = "@class_or_object_name", desc = "Next class name end" },
                        ["]L"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["]R"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        ["]T"] = { query = "@type_identifier", desc = "Type identifier" },
                    },
                    goto_previous_start = {

                        ["[f"] = { query = "@function_call_name", desc = "Prev function call start" },
                        ["[m"] = { query = "@method_name", desc = "Prev method/function def start" },
                        ["[p"] = { query = "@parameter.inner", desc = "Prev parameter start" },
                        ["[s"] = { query = "@section_header_fold", desc = "Prev scope" },
                        ["[k"] = { query = "@class_constant_name", desc = "Prev class constant" },
                        ["[j"] = { query = "@class_or_object_name", desc = "Prev class name start" },
                        ["[l"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["[r"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        ["[t"] = { query = "@type_identifier", desc = "Type identifier" },
                    },
                    goto_previous_end = {

                        ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
                        ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
                        ["[P"] = { query = "@parameter.inner", desc = "Prev parameter start" },
                        ["[S"] = { query = "@section_footer", desc = "Prev scope end" },
                        ["[J"] = { query = "@class_or_object_name", desc = "Prev class name end" },
                        ["[L"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["[R"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        ["[T"] = { query = "@type_identifier", desc = "Type identifier" },
                    },
                },
            },
        })

        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        -- make sure forward function comes first
        local next_fold_repeat, prev_fold_repeat = ts_repeat_move.make_repeatable_move_pair(
            function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zj", true, false, true), 'n', false)
            end,
            function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zk", true, false, true), 'n', false)
            end
        )
        -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

        vim.keymap.set({ "n", "x", "o" }, "zj", next_fold_repeat)
        vim.keymap.set({ "n", "x", "o" }, "zk", prev_fold_repeat)

        local next_quickfix_repeat, prev_quickfix_repeat = ts_repeat_move.make_repeatable_move_pair(
            function()
                local ok, result = pcall(vim.cmd, 'cnext')
                -- vim.cmd('cn')
            end,
            function()
                local ok, result = pcall(vim.cmd, 'cprev')
                -- vim.cmd('cp')
            end
        )
        -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

        vim.keymap.set({ "n", "x", "o" }, "]q", next_quickfix_repeat)
        vim.keymap.set({ "n", "x", "o" }, "[q", prev_quickfix_repeat)

        -- vim way: ; goes previous.
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_previous)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_next)

        -- These don't work as they are overridden by the plugin
        -- -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
        -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
        -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
        -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
        -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end
}
