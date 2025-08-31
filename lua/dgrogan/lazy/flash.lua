return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        jump = {
            -- autojump = true,
        },
        label = {
            after = false,
            before = true,
            rainbow = {
                enabled = true,
            },
        },
        modes = {
            search = {
                enabled = true,
            },
            char = {
                enabled = false
            }
        }
    },
    -- stylua: ignore
    keys = {
        -- Vim doesn't recognize <C-;> as a keybinding, so we use <M-;> instead
        -- { "<C-;>",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "<M-;>", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "\\",    mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<m-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
}
