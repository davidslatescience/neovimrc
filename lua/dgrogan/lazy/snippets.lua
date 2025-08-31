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

            vim.keymap.set({ "i", "s" }, "<C-s>;", function() ls.jump(-1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-s>,", function() ls.jump(1) end, { silent = true })

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
                s("sound (story add sound to existing action)", {
                    t({ ",\"soundName\": \"" }) , i(0), t({ "\"" }),
                }),
                s("sound delay (story add sound to existing action)", {
                    t({ ",\"soundDelay\": " }) , i(0), t({ "" }),
                }),
                s("play sound (story action)", fmt([[
    {{
      "actionType": "PlaySound",
      "soundName": "{value}"
    }},
                ]], {
                        value = i(1),
                    }
                )),
                s("stop sound (story action)", fmt([[
    {{
      "actionType": "StopSound",
      "soundName": "{value}"
    }},
                ]], {
                        value = i(1),
                    }
                )),
                s("rect (Template)", fmt([[
        "{TemplateName}Template": {{
            "type": "Rect",
            "fillColor": "#ffff00",
            "z": 0,
            "width": 100,
            "height": 100,
            "originX": 0,
            "originY": 0,
            "opacity": 1,
            "radius": 5
        }},
                ]], {
                        TemplateName = i(1),
                    }
                )),
                s("image (Template)", fmt([[
        "{TemplateName}Template": {{
            "name": "{TemplateName}",
            "resource": "",
            "type": "Image",
            "z": 0,
            "originX": 0,
            "originY": 0,
            "anchorX": 0,
            "anchorY": 0,
            "scaleY": 1,
            "scaleX": 1
        }},
                ]], {
                        TemplateName = i(1),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("New config file", fmt([[
{{
    "descriptorName": "{Name}Config",
    "descriptorSchema": "I{Name}Config"
}}
                ]], {
                        Name = i(1),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
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
                s("play sound (script)", fmt([[script.playSound("{value}");]], {
                        value = i(1),
                    }
                )),
                s("New Display Class", fmt([[
import {{RenderingContext}} from "../../../../../../Infrastructure/typings/slate/rendering/RenderingContext";
import {{ISlateEntity}} from "../../../../../../Infrastructure/typings/slate/entities/ISlateEntity";
import {{IEntityTemplatesDescriptor}} from "../../../../../../Infrastructure/typings/slate/entities/manipulation/IEntityTemplatesDescriptor";
import {{IWidgetContainer}} from "../../../../../../Infrastructure/typings/slate/widgets/IWidgetContainer";

/**
 * Handles display of the {Name} for the MainScene.
 */
export class MainScene{Name}Display {{

    //=================================================== Constants ===================================================

    //<editor-fold desc="Constants" >

    //</editor-fold>

    //===================================================== State =====================================================

    //<editor-fold desc="State" >

    private readonly root: ISlateEntity;

    private readonly context: RenderingContext;

    private descriptor: IEntityTemplatesDescriptor;

    private widgetContainer: IWidgetContainer;

    //</editor-fold>

    //===================================================== Setup =====================================================

    //<editor-fold desc="Setup" >

    /**
     * Creates a new instance of the display class.
     */
    public constructor(
        root: ISlateEntity,
        context: RenderingContext,
        descriptor: IEntityTemplatesDescriptor,
        widgetContainer: IWidgetContainer) {{

        this.root = root;
        this.context = context;
        this.descriptor = descriptor;
        this.widgetContainer = widgetContainer;
    }}

    //</editor-fold>

    //====================================================== API ======================================================

    //<editor-fold desc="API" >

    /**
     * Shows the {Name} display.
     */
    public show(): void {{
    }}

    /**
     * Hides the {Name} display.
     */
    public hide(): void {{
    }}

    //</editor-fold>

    //================================================== Details ==================================================

    //<editor-fold desc="Details" >

    /**
     * Returns the root entity of the display clsss.
     */
    private getRootEntity(): ISlateEntity {{
        return this.root;
    }}

    /**
     * Returns the context of this display class.
     */
    private getContext(): RenderingContext {{
        return this.context;
    }}

    //</editor-fold>
}}
                ]], {
                        Name = i(1, "Name"),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("Create Text Label", fmt([[Rendering.createLabel(this.getContext(), "{Text}", {{
            name: "{Text}Label",
            textColor: "#094550",
            font: "bold 26px Ubuntu",
            hAlign: "center",
            vAlign: "center",
            opacity: 1,
            anchorX: 0.5,
            anchorY: 0.5,
            x: 0,
            y: 164,
            width: 286,
            height: 32
        }});
                ]], {
                        Text = i(1, "Text"),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("Get/Create/Remove Entity Method", fmt([[
    /**
     * Creates the {EntityName} entity.
     */
    private create{EntityName}Entity(): {EntityType} {{
        return Construction.createEntityFromRelativeTemplate(this.descriptor, "{EntityName}Template") as {EntityType};
    }}

    /**
     * Removes the {EntityName} entity.
     */
    private remove{EntityName}Entity(): void {{
        let entity: {EntityType} = Lookup.findFirstByName(this.getRootEntity(), "{EntityName}", true) as {EntityType};
        Parenthood.removeSubEntity(this.getRootEntity(), entity);
    }}

    /**
     * Returns the {EntityName} entity.
     */
    private get{EntityName}Entity(): {EntityType} {{
        let entity: {EntityType} = Lookup.findFirstByName(this.getRootEntity(), "{EntityName}", true) as {EntityType};
        //<editor-fold desc="Preconditions" defaultstate="collapsed">
        Precondition.requireNotNullish(entity, "Could not find entity with name '{EntityName}'.");
        //</editor-fold>
        return entity;
    }}

                ]], {
                        EntityName = i(1, "EntityName"),
                        EntityType = c(2, {
                            t("ILabelEntity"),
                            t("IRectEntity"),
                            t("IImageEntity"),
                            t("ISlateEntity"),
                        }),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("Create entity and add to scene root", fmt([[
        let {EntityName}: {EntityType} = this.create{EntityNameCapitalized}Entity();
        Parenthood.addSubEntity(this.getRootEntity(), {EntityName});
                ]], {
                        EntityName = i(1, "entityName"),
                        EntityType = c(2, {
                            t("ILabelEntity"),
                            t("IRectEntity"),
                            t("IImageEntity"),
                            t("ISlateEntity"),
                        }),
                        EntityNameCapitalized = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1)
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("Find/Get Widget Methods", fmt([[
    /**
     * Returns {WidgetName} if it exists otherwise null.
     */
    private find{WidgetName}(): {WidgetName} | null {{
        return this.getWidget("{WidgetName}") as {WidgetName} | null;
    }}

    /**
     * Returns {WidgetName}. {WidgetName} must exist.
     */
    private get{WidgetName}(): {WidgetName} {{
        let widget: Widget | null = this.getWidget("{WidgetName}");
        //<editor-fold desc="Preconditions" defaultstate="collapsed">
        Precondition.requireNotNullish(widget, "{WidgetName} must not be null.");
        //</editor-fold>
        return widget! as {WidgetName};
    }}

                ]], {
                        WidgetName = i(1, "WidgetName"),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("New Static Helper Class", fmt([[
/**
 * Helper methods for {Name}.
 */
export class {Name}Helpers {{

    //====================================================== API ======================================================

    //<editor-fold desc="API" >

    public static Method(): void {{
    }}

    //</editor-fold>
}}
                ]], {
                        Name = i(1, "Name"),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
                s("Dynamically Resolved Animation", fmt([[
        script.addDynamicallyResolvedAnimation(() => {{
            let script: AnimationScript = new AnimationScript(this.getContext());
            script.{addTask}
            return script.getAnimation();
        }});
                ]], {
                        addTask = i(1, "addTask"),
                    },
                    {
                        repeat_duplicates = true
                    }
                )),
            })
        end,
    }
}
