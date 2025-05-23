return {
    --
    -- Not sure if this plugin is actually used, could possibly be removed, or replaced with vim-sandwich.
    --
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            keymaps = {
                insert = "<C-g>s",
                insert_line = "<C-g>S",
                normal = "ys",
                normal_cur = "yss",
                normal_line = "yS",
                normal_cur_line = "ySS",
                visual = "H",
                visual_line = "gS",
                delete = "ds",
                change = "cs",
                change_line = "cS",
            }
        })
    end
}
