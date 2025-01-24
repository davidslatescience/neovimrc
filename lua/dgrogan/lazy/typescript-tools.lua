return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
        require("typescript-tools").setup({
            settings = {
                tsserver_format_options = {
                    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
                },

                -- typescript = {
                --     tsconfig = "tsconfig.json",
                --     eslint = true,
                --     prettier = true,
                -- },
            },
        })
    end,
}
