return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            local ls = require("luasnip")
            ls.filetype_extend("javascript", { "jsdoc" })

            --- TODO: What is expand?
            vim.keymap.set({ "i" }, "<C-s>e", function() ls.expand() end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<C-s>;", function() ls.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-s>,", function() ls.jump(-1) end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<C-E>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true })

            local s = ls.snippet
            local sn = ls.snippet_node
            local t = ls.text_node
            local i = ls.insert_node
            local f = ls.function_node
            local c = ls.choice_node
            local d = ls.dynamic_node
            local r = ls.restore_node
            local l = require("luasnip.extras").lambda
            local rep = require("luasnip.extras").rep
            local p = require("luasnip.extras").partial
            local m = require("luasnip.extras").match
            local n = require("luasnip.extras").nonempty
            local dl = require("luasnip.extras").dynamic_lambda
            local fmt = require("luasnip.extras.fmt").fmt
            local fmta = require("luasnip.extras.fmt").fmta
            local types = require("luasnip.util.types")
            local conds = require("luasnip.extras.conditions")
            local conds_expand = require("luasnip.extras.conditions.expand")

            ls.add_snippets("json", {
                s("parallel (story)", {
                    t({ "{", "\"actionType\": \"Parallel\",", "\"actions\": [", "" }), i(1),
                    t({ "", "]", "}," }),
                }),
                s("serial (story)", {
                    t({ "{", "\"actionType\": \"Serial\",", "\"actions\": [", "" }), i(1),
                    t({ "", "]", "}," }),
                }),
                s("ae animation (story)", {
                    t({ "{", "\"actionType\": \"AfterEffectsAnimation\",", "\"afterEffectsAnimation\": \"" }), i(1),
                    t({ "\",", "\"afterEffectsAnimationClass\": \"AnimationHelper\",", "\"modelDescriptor\": \"" }), i(2),
                    t({ "\"", "}" }),
                }),
                s("obj", {
                    t({ "{", "\"" }), i(1),
                    t({ "\": \"" }), i(2),
                    t({ "\",", "}," }),
                }),
                s("spine animation (story)", {
                    t({ "{", "\"actionType\": \"SpineAnimation\",", "\"entityName\": \"" }), i(1),
                    t({ "\",", "\"daemon\": true,", "\"animation\": \"" }), i(2),
                    t({ "\",", "\"repeats\": -1", "}" }),
                }),
                s("delay (story)", {
                    t({ "{", "\"actionType\": \"Delay\",", "\"duration\": " }), i(1),
                    t({ "", "}" }),
                }),
                s("key", {
                    t({ "\"" }), i(1),
                    t({ "\": \"" }), i(0),
                    t({ "\"," }),
                }),
                s("move animation (story)", {
                    t({ "{", "\"actionType\": \"MoveAnimation\",", "\"entityName\": \"" }), i(1),
                    t({ "\",", "\"duration\": " }), i(2, "0.5"),
                    t({ ",", "\"toX\": " }), i(3),
                    t({ ",", "\"toY\": " }), i(4),
                    t({ "", "}," }),
                }),
                s("scale animation (story)", {
                    t({ "{", "\"actionType\": \"ScaleAnimation\",", "\"entityName\": \"" }), i(1),
                    t({ "\",", "\"duration\": " }), i(2, "0.5"),
                    t({ ",", "\"targetScaleX\": " }), i(3, "1"),
                    t({ ",", "\"targetScaleY\": " }), i(4, "1"),
                    t({ "", "}," }),
                }),
                s("add entity (story)", {
                    t({ "{", "\"actionType\": \"AddEntity\",", "\"entityName\": \"" }), i(1),
                    t({ "\",", "\"parent\": \"" }), i(2, "root"),
                    t({ "\",", "\"placement\": ", "{", "\"x\": " }), i(3, "100"),
                    t({ ",", "\"y\": " }), i(4, "100"),
                    t({ ",", "\"z\": " }), i(5, "1"),
                    t({ "", "}", "}," }),
                }),
            })
            ls.add_snippets("typescript", {
                s("add precondition (Not Nullish)", fmt([[
        //<editor-fold desc="Preconditions" defaultstate="collapsed">
        Precondition.requireNotNullish({value}, "{value} must not be nullish.");
        //</editor-fold>
                ]], {
                        value = i(1, "value"),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
            })
        end,
    }
}
