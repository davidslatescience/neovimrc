return {
    "theprimeagen/harpoon",
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file)
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)


        vim.keymap.set("n", "<M-h>", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<M-j>", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<M-k>", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<M-l>", function() ui.nav_file(4) end)

        --        local harpoon = require("harpoon")

        --        harpoon:setup()

        --        vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
        --        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        --
        --        vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
        --        vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
        --        vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
        --        vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
    end
}
