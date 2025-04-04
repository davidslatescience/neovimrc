return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
                "vimdoc", "javascript", "typescript", "lua",
                "jsdoc", "bash", "json", "gitignore", "markdown"
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                --additional_vim_regex_highlighting = { "markdown" },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    -- init_selection = "<C-space>",
                    -- node_incremental = "<C-space>",
                    -- scope_incremental = false,
                    -- node_decremental = "<bs>",
                    --
                    -- init_selection = "<A-Up>",
                    -- node_incremental = "<A-Up>",
                    -- scope_incremental = "`",
                    -- node_decremental = "<A-Down>",
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "`",
                    node_decremental = "<bs>",
                },
            },

        })
      if require("nvim-treesitter.parsers").has_parser "typescript" then
        local folds_query = [[
  [
    (import_statement)+
    (function_declaration)
    (method_definition)
  ] @fold
  ]]
        require("vim.treesitter.query").set("typescript", "folds", folds_query)
      end
    end
}
