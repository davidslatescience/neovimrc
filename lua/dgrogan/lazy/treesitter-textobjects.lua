return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    config = function()
        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                        ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                        -- Can't enable this as it causes a short delay when moving right in visual mode
                        -- ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                        -- ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
                        ["al"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                        ["ar"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                        -- Parameters
                        ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                        -- Conditionals
                        ["ax"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                        ["ixs"] = { query = "@if_statement_condition_inner", desc = "Select inner part of a conditional" },
                        ["ix"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                        -- Loops
                        -- ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                        -- ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                        -- Function calls
                        ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                        ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                        -- Method definitions
                        ["am"] = { query = "@method", desc = "Select outer part of a method/function definition" },
                        ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

                        ["ac"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
                        ["ic"] = { query = "@comment.inner", desc = "Select inner part of a comment" },
                        -- ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                        -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

                        ["ak"] = { query = "@class_constant", desc = "Select outer part of class constant" },
                        -- ["aj"] = { query = "@object", desc = "Select outer part of object" },
                        ["aj"] = { query = "@object", desc = "Select outer part of object" },
                        ["r:"] = { query = "@json_value.inner", desc = "Select the json value" },
                        -- Can't enable this as it causes a short delay when moving right in visual mode
                        -- ["l:"] = { query = "@json_key.inner", desc = "Select the json key" },

                        ["ab"] = { query = "@block.outer", desc = "Block outer" },
                        ["ib"] = { query = "@block.inner", desc = "Block inner" },

                    },
                    include_surrounding_whitespace = false,
                    selection_modes = {
                        ['@object'] = 'V', -- linewise
                        ['@method'] = 'V', -- linewise
                        ['@conditional.outer'] = 'V', -- linewise
                        ['@conditional.inner'] = 'V', -- linewise
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
                    set_jumps = true,     -- whether to set jumps in the jumplist
                    -- Already mapped
                    -- ]c cnext
                    -- ]d next diagnostic
                    -- ]<space> insert line below
                    -- ]i lookup identifier under cursor
                    -- ]e exchange below (from unimpaired)

                    goto_next_start = {
                        -- Class definitions
                        -- TODO: j should be just for objects, classes should be different
                        ["]j"] = { query = "@class_or_object_name", desc = "Class or object start" },
                        -- Class constants
                        ["]k"] = { query = "@class_constant_name", desc = "Class constant" },
                        -- Method definitions
                        ["]m"] = { query = "@method_name", desc = "Method/function definition" },
                        -- Parameters
                        ["]p"] = { query = "@parameter.inner", desc = "Parameter inner" },
                        -- Function calls
                        ["]fcn"] = { query = "@function_call_name", desc = "Function call name" },
                        ["]fco"] = { query = "@call.outer", desc = "Function call outer" },
                        ["]fci"] = { query = "@call.inner", desc = "Function call inner" },
                        -- Types
                        ["]t"] = { query = "@type_identifier", desc = "Type identifier" },
                        -- Assignments
                        ["]l"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["]r"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        -- Folds
                        ["]fs"] = { query = "@section_header_fold", desc = "Fold section header" },
                        -- Statements
                        ["]bs"] = { query = "@statement_block_start", desc = "Statement block start" },
                        ["]bi"] = { query = "@block.inner", desc = "Statement block inner" },
                        ["]bo"] = { query = "@block.outer", desc = "Statement block outer" },
                        -- Conditionals
                        ["]xs"] = { query = "@if_statement_condition_inner", desc = "Conditional statement" },
                        ["]xi"] = { query = "@conditional.inner", desc = "Conditional statement block inner" },
                        -- Comments
                        ["]bci"] = { query = "@comment_inner", desc = "Comment inner" },
                        ["]bco"] = { query = "@comment.outer", desc = "Comment outer" },
                        -- Variables
                        ["]v"] = { query = "@variable_outer", desc = "Variable (identifier) outer" },

                    },
                    goto_next_end = {
                        -- Class definitions
                        -- TODO: j should be just for objects, classes should be different
                        ["]J"] = { query = "@class_or_object_name", desc = "Class or object start" },
                        -- Class constants
                        ["]K"] = { query = "@class_constant_name", desc = "Class constant" },
                        -- Method definitions
                        ["]M"] = { query = "@function.outer", desc = "Method/function definition" },
                        ["]Nm"] = { query = "@method_name", desc = "Method/function name" },
                        -- Parameters
                        ["]P"] = { query = "@parameter.inner", desc = "Parameter inner" },
                        -- Function calls
                        ["]Fcn"] = { query = "@function_call_name", desc = "Function call name" },
                        ["]Fco"] = { query = "@call.outer", desc = "Function call outer" },
                        ["]Fci"] = { query = "@call.inner", desc = "Function call inner" },
                        -- Types
                        ["]T"] = { query = "@type_identifier", desc = "Type identifier" },
                        -- Assignments
                        ["]L"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["]R"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        -- Folds
                        ["]Fs"] = { query = "@section_footer", desc = "Fold section header" },
                        -- Statements
                        ["]Bs"] = { query = "@statement_block_start", desc = "Statement block start" },
                        ["]Bi"] = { query = "@block.inner", desc = "Statement block inner" },
                        ["]Bo"] = { query = "@block.outer", desc = "Statement block outer" },
                        -- Conditionals
                        ["]Xs"] = { query = "@if_statement_condition_inner", desc = "Conditional statement" },
                        ["]Xi"] = { query = "@conditional.inner", desc = "Conditional statement block inner" },
                        -- Comments
                        ["]Bci"] = { query = "@comment_inner", desc = "Comment inner" },
                        ["]Bco"] = { query = "@comment.outer", desc = "Comment outer" },
                        -- Variables
                        ["]V"] = { query = "@variable_outer", desc = "Variable (identifier) outer" },

                    },
                    goto_previous_start = {
                        -- Class definitions
                        -- TODO: j should be just for objects, classes should be different
                        ["[j"] = { query = "@class_or_object_name", desc = "Class or object start" },
                        -- Class constants
                        ["[k"] = { query = "@class_constant_name", desc = "Class constant" },
                        -- Method definitions
                        ["[m"] = { query = "@method_name", desc = "Method/function definition" },
                        -- Parameters
                        ["[p"] = { query = "@parameter.inner", desc = "Parameter inner" },
                        -- Function calls
                        ["[fcn"] = { query = "@function_call_name", desc = "Function call name" },
                        ["[fco"] = { query = "@call.outer", desc = "Function call outer" },
                        ["[fci"] = { query = "@call.inner", desc = "Function call inner" },
                        -- Types
                        ["[t"] = { query = "@type_identifier", desc = "Type identifier" },
                        -- Assignments
                        ["[l"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["[r"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        -- Folds
                        ["[fs"] = { query = "@section_header_fold", desc = "Fold section header" },
                        -- Statements
                        ["[bs"] = { query = "@statement_block_start", desc = "Statement block start" },
                        ["[bi"] = { query = "@block.inner", desc = "Statement block inner" },
                        ["[bo"] = { query = "@block.outer", desc = "Statement block outer" },
                        -- Conditionals
                        ["[xs"] = { query = "@if_statement_condition_inner", desc = "Conditional statement" },
                        ["[xi"] = { query = "@conditional.inner", desc = "Conditional statement block inner" },
                        -- Comments
                        ["[bci"] = { query = "@comment_inner", desc = "Comment inner" },
                        ["[bco"] = { query = "@comment.outer", desc = "Comment outer" },
                        -- Variables
                        ["[v"] = { query = "@variable_outer", desc = "Variable (identifier) outer" },

                    },
                    goto_previous_end = {
                        -- Class definitions
                        -- TODO: j should be just for objects, classes should be different
                        ["[J"] = { query = "@class_or_object_name", desc = "Class or object start" },
                        -- Class constants
                        ["[K"] = { query = "@class_constant_name", desc = "Class constant" },
                        -- Method definitions
                        ["[M"] = { query = "@function.outer", desc = "Method/function definition" },
                        ["[Nm"] = { query = "@method_name", desc = "Method/function name" },
                        -- Parameters
                        ["[P"] = { query = "@parameter.inner", desc = "Parameter inner" },
                        -- Function calls
                        ["[Fcn"] = { query = "@function_call_name", desc = "Function call name" },
                        ["[Fco"] = { query = "@call.outer", desc = "Function call outer" },
                        ["[Fci"] = { query = "@call.inner", desc = "Function call inner" },
                        -- Types
                        ["[T"] = { query = "@type_identifier", desc = "Type identifier" },
                        -- Assignments
                        ["[L"] = { query = "@assignment_lhs_inner", desc = "Left hand side of an assignment" },
                        ["[R"] = { query = "@assignment_rhs_inner", desc = "Right hand side of an assignment" },
                        -- Folds
                        ["[Fs"] = { query = "@section_footer", desc = "Fold section header" },
                        -- Statements
                        ["[Bs"] = { query = "@statement_block_start", desc = "Statement block start" },
                        ["[Bi"] = { query = "@block.inner", desc = "Statement block inner" },
                        ["[Bo"] = { query = "@block.outer", desc = "Statement block outer" },
                        -- Conditionals
                        ["[Xs"] = { query = "@if_statement_condition_inner", desc = "Conditional statement" },
                        ["[Xi"] = { query = "@conditional.inner", desc = "Conditional statement block inner" },
                        -- Comments
                        ["[Bci"] = { query = "@comment_inner", desc = "Comment inner" },
                        ["[Bco"] = { query = "@comment.outer", desc = "Comment outer" },
                        -- Variables
                        ["[V"] = { query = "@variable_outer", desc = "Variable (identifier) outer" },

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
