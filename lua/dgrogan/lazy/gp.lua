return {
    "robitx/gp.nvim",
    config = function()
        local conf = {
            -- For customization, refer to Install > Configuration in the Documentation/Readme
            providers = {
                openai = {},
                copilot = {
                    endpoint = "https://api.githubcopilot.com/chat/completions",
                    secret = {
                        "bash",
                        "-c",
                        "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
                    },
                },
                -- ollama = {
                --     endpoint = "http://localhost:11434/v1/chat/completions",
                -- },
            },
            -- default command agents (model + persona)
            -- name, model and system_prompt are mandatory fields
            -- to use agent for chat set chat = true, for command set command = true
            -- to remove some default agent completely set it like:
            -- agents = {  { name = "ChatGPT3-5", disable = true, }, ... },
            agents = {
                {
                    provider = "copilot",
                    name = "ChatCopilot",
                    chat = true,
                    command = false,
                    -- string with model name or table with model name and parameters
                    model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = require("gp.defaults").chat_system_prompt,
                },
            },

            hooks = {
                Improve = function(gp, params)
                    local template = "I have the following code from {{filename}}:\n\n"
                        .. "```{{filetype}}\n{{selection}}\n```\n\n"
                        .. "Please respond by improving the code above."
                        .. "ALL VARIABLES AND PARAMETERS MUST BE EXPLICITY TYPED."
                        .. "DO NOT ADD ANY FEATURES THAT ARE NOT JAVASCRIPT ES5 COMPATIBLE. "
                        .. "ADD METHOD COMMENTS FOR EACH METHOD, BUT DO NOT COMMENT EACH METHOD PARAMETER. "
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.popup, agent, template)
                end,
                Refactor = function(gp, params)
                    local template = "I have the following code from {{filename}}:\n\n"
                        .. "```{{filetype}}\n{{selection}}\n```\n\n"
                        .. "Please respond by refactoring the code above into neat "
                        .. "methods with comments. "
                        .. "ALL VARIABLES AND PARAMETERS MUST BE EXPLICITY TYPED."
                        .. "DO NOT COMMENT EACH METHOD PARAMETER. "
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.popup, agent, template)
                end,
                -- example of adding command which explains the selected code
                Explain = function(gp, params)
                    local template = "I have the following code from {{filename}}:\n\n"
                        .. "```{{filetype}}\n{{selection}}\n```\n\n"
                        .. "Please respond by explaining the code above."
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.popup, agent, template)
                end,
                BufferChatNew = function(gp, _)
                    -- call GpChatNew command in range mode on whole buffer
                    vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
                end,
                BufferChatNewSplit = function(gp, _)
                    -- call GpChatNew command in range mode on whole buffer
                    vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew split")
                end,

                -- example of adding command which explains the selected code
                GitCommitMessage = function(gp, params)
                    local command = 'git diff --staged'
                    local handle = io.popen(command)
                    local diff = handle:read('*a')
                    handle:close()
                    local template = "I have the following git diff:\n\n"
                        .. "Please respond with a suitable git commit message."
                        .. "Generate a git commit message following this structure:\n"
                        .. "1. First line: conventional commit format (type: concise description) (remember to use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.)\n"
                        .. "2. Optional bullet points if more context helps:\n"
                        .. "   - Keep the second line blank\n"
                        .. "   - Keep them short and direct\n"
                        .. "   - Focus on what changed\n"
                        .. "   - Always be terse\n"
                        .. "   - Don't overly explain\n"
                        .. "   - Drop any fluffy or formal language\n"
                        .. "\n"
                        .. "Return ONLY the commit message - no introduction, no explanation, no quotes around it.\n"
                        .. "\n"
                        .. "Examples:\n"
                        .. "feat: add user auth system\n"
                        .. "\n"
                        .. "- Add JWT tokens for API auth\n"
                        .. "- Handle token refresh for long sessions\n"
                        .. "\n"
                        .. "fix: resolve memory leak in worker pool\n"
                        .. "\n"
                        .. "- Clean up idle connections\n"
                        .. "- Add timeout for stale workers\n"
                        .. "\n"
                        .. "Simple change example:\n"
                        .. "fix: typo in README.md\n"
                        .. "\n"
                        .. "Very important: Do not respond with any of the examples. Your message must be based off the diff that is about to be provided\n"
                        .. "\n"
                        .. "Here is the diff:\n"
                        .. "\n"
                        .. "```" .. diff .. "\n```\n\n"
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.prepend, agent, template)
                end,
            }
        }
        require("gp").setup(conf)

        local rewordTextPrompt = "Please respond with reworded text to improve readability."

        local methodCommentPrompt = "Please respond with a concise method comment for this method. "
                        .. "DO NOT ADD COMMENT FOR ANY METHOD PARAMETERS. "
                        .. "Wrap long lines when they exceed 117 characters. "
                        .. "Follow this structure: "
                        .. "1. First line: Concise description. "
                        .. "2. Optional bullet points if more context helps: "
                        .. "   - Keep the second line blank"
                        .. "   - Keep them short and direct"
                        .. "   - Always be terse"
                        .. "   - Don't overly explain"
                        .. "   - Drop any fluffy or formal language"

        -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
        require("which-key").add({
            -- VISUAL mode mappings
            -- s, x, v modes are handled the same way by which_key
            {
                mode = { "v" },
                nowait = true,
                remap = false,
                { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
                { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
                { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>",  desc = "ChatNew split" },
                { "<C-g>a",     ":<C-u>'<,'>GpAppend<cr>",         desc = "Visual Append (after)" },
                { "<C-g>b",     ":<C-u>'<,'>GpPrepend<cr>",        desc = "Visual Prepend (before)" },
                { "<C-g>c",     ":<C-u>'<,'>GpChatNew<cr>",        desc = "Visual Chat New" },
                { "<C-g>g",     group = "generate into new .." },
                { "<C-g>ge",    ":<C-u>'<,'>GpEnew<cr>",           desc = "Visual GpEnew" },
                { "<C-g>gn",    ":<C-u>'<,'>GpNew<cr>",            desc = "Visual GpNew" },
                { "<C-g>gp",    ":<C-u>'<,'>GpPopup<cr>",          desc = "Visual Popup" },
                { "<C-g>gt",    ":<C-u>'<,'>GpTabnew<cr>",         desc = "Visual GpTabnew" },
                { "<C-g>gv",    ":<C-u>'<,'>GpVnew<cr>",           desc = "Visual GpVnew" },
                { "<C-g>i",     ":<C-u>'<,'>GpImplement<cr>",      desc = "Implement selection" },
                { "<C-g>n",     "<cmd>GpNextAgent<cr>",            desc = "Next Agent" },
                { "<C-g>p",     ":<C-u>'<,'>GpChatPaste<cr>",      desc = "Visual Chat Paste" },
                { "<C-g>r",     ":<C-u>'<,'>GpRewrite<cr>",        desc = "Visual Rewrite" },
                { "<C-g>s",     "<cmd>GpStop<cr>",                 desc = "GpStop" },
                { "<C-g>t",     ":<C-u>'<,'>GpChatToggle<cr>",     desc = "Visual Toggle Chat" },
                { "<C-g>w",     group = "Whisper" },
                { "<C-g>wa",    ":<C-u>'<,'>GpWhisperAppend<cr>",  desc = "Whisper Append" },
                { "<C-g>wb",    ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend" },
                { "<C-g>we",    ":<C-u>'<,'>GpWhisperEnew<cr>",    desc = "Whisper Enew" },
                { "<C-g>wn",    ":<C-u>'<,'>GpWhisperNew<cr>",     desc = "Whisper New" },
                { "<C-g>wp",    ":<C-u>'<,'>GpWhisperPopup<cr>",   desc = "Whisper Popup" },
                { "<C-g>wr",    ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite" },
                { "<C-g>wt",    ":<C-u>'<,'>GpWhisperTabnew<cr>",  desc = "Whisper Tabnew" },
                { "<C-g>wv",    ":<C-u>'<,'>GpWhisperVnew<cr>",    desc = "Whisper Vnew" },
                { "<C-g>ww",    ":<C-u>'<,'>GpWhisper<cr>",        desc = "Whisper" },
                { "<C-g>x",     ":<C-u>'<,'>GpContext<cr>",        desc = "Visual GpContext" },
                { "<C-g>d",     group = "David's commands.." },
                { "<C-g>dc",    ":'<,'>GpPrepend \"" .. methodCommentPrompt .. "\"<cr>", desc = "Add method comment for selection" },
                { "<C-g>dr",    ":'<,'>GpRewrite \"" .. rewordTextPrompt .. "\"<cr>", desc = "Reword selection" },
            },

            -- NORMAL mode mappings
            {
                mode = { "n" },
                nowait = true,
                remap = false,
                { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>",   desc = "New Chat tabnew" },
                { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>",   desc = "New Chat vsplit" },
                { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",    desc = "New Chat split" },
                { "<C-g>a",     "<cmd>GpAppend<cr>",           desc = "Append (after)" },
                { "<C-g>b",     "<cmd>GpPrepend<cr>",          desc = "Prepend (before)" },
                { "<C-g>c",     "<cmd>GpChatNew<cr>",          desc = "New Chat" },
                { "<C-g>f",     "<cmd>GpChatFinder<cr>",       desc = "Chat Finder" },
                { "<C-g>g",     group = "generate into new .." },
                { "<C-g>ge",    "<cmd>GpEnew<cr>",             desc = "GpEnew" },
                { "<C-g>gn",    "<cmd>GpNew<cr>",              desc = "GpNew" },
                { "<C-g>gp",    "<cmd>GpPopup<cr>",            desc = "Popup" },
                { "<C-g>gt",    "<cmd>GpTabnew<cr>",           desc = "GpTabnew" },
                { "<C-g>gv",    "<cmd>GpVnew<cr>",             desc = "GpVnew" },
                { "<C-g>n",     "<cmd>GpNextAgent<cr>",        desc = "Next Agent" },
                { "<C-g>r",     "<cmd>GpRewrite<cr>",          desc = "Inline Rewrite" },
                { "<C-g>s",     "<cmd>GpStop<cr>",             desc = "GpStop" },
                { "<C-g>t",     "<cmd>GpChatToggle<cr>",       desc = "Toggle Chat" },
                { "<C-g>w",     group = "Whisper" },
                { "<C-g>wa",    "<cmd>GpWhisperAppend<cr>",    desc = "Whisper Append (after)" },
                { "<C-g>wb",    "<cmd>GpWhisperPrepend<cr>",   desc = "Whisper Prepend (before)" },
                { "<C-g>we",    "<cmd>GpWhisperEnew<cr>",      desc = "Whisper Enew" },
                { "<C-g>wn",    "<cmd>GpWhisperNew<cr>",       desc = "Whisper New" },
                { "<C-g>wp",    "<cmd>GpWhisperPopup<cr>",     desc = "Whisper Popup" },
                { "<C-g>wr",    "<cmd>GpWhisperRewrite<cr>",   desc = "Whisper Inline Rewrite" },
                { "<C-g>wt",    "<cmd>GpWhisperTabnew<cr>",    desc = "Whisper Tabnew" },
                { "<C-g>wv",    "<cmd>GpWhisperVnew<cr>",      desc = "Whisper Vnew" },
                { "<C-g>ww",    "<cmd>GpWhisper<cr>",          desc = "Whisper" },
                { "<C-g>x",     "<cmd>GpContext<cr>",          desc = "Toggle GpContext" },
                { "<C-g>d",     group = "David's commands.." },
                { "<C-g>dc",    ":normal vam<cr>:<C-u>'<,'>GpPrepend \"" .. methodCommentPrompt .. "\"<cr>", desc = "Add method comment" },
                { "<C-g>dg",    "<cmd>GpGitCommitMessage<cr>", desc = "Generate a Git commit message" },
                { "<C-g>db",    "<cmd>GpBufferChatNew<cr>", desc = "New chat with this buffer" },
            },

            -- INSERT mode mappings
            {
                mode = { "i" },
                nowait = true,
                remap = false,
                { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>",   desc = "New Chat tabnew" },
                { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>",   desc = "New Chat vsplit" },
                { "<C-g><C-x>", "<cmd>GpChatNew split<cr>",    desc = "New Chat split" },
                { "<C-g>a",     "<cmd>GpAppend<cr>",           desc = "Append (after)" },
                { "<C-g>b",     "<cmd>GpPrepend<cr>",          desc = "Prepend (before)" },
                { "<C-g>c",     "<cmd>GpChatNew<cr>",          desc = "New Chat" },
                { "<C-g>f",     "<cmd>GpChatFinder<cr>",       desc = "Chat Finder" },
                { "<C-g>g",     group = "generate into new .." },
                { "<C-g>ge",    "<cmd>GpEnew<cr>",             desc = "GpEnew" },
                { "<C-g>gn",    "<cmd>GpNew<cr>",              desc = "GpNew" },
                { "<C-g>gp",    "<cmd>GpPopup<cr>",            desc = "Popup" },
                { "<C-g>gt",    "<cmd>GpTabnew<cr>",           desc = "GpTabnew" },
                { "<C-g>gv",    "<cmd>GpVnew<cr>",             desc = "GpVnew" },
                { "<C-g>n",     "<cmd>GpNextAgent<cr>",        desc = "Next Agent" },
                { "<C-g>r",     "<cmd>GpRewrite<cr>",          desc = "Inline Rewrite" },
                { "<C-g>s",     "<cmd>GpStop<cr>",             desc = "GpStop" },
                { "<C-g>t",     "<cmd>GpChatToggle<cr>",       desc = "Toggle Chat" },
                { "<C-g>w",     group = "Whisper" },
                { "<C-g>wa",    "<cmd>GpWhisperAppend<cr>",    desc = "Whisper Append (after)" },
                { "<C-g>wb",    "<cmd>GpWhisperPrepend<cr>",   desc = "Whisper Prepend (before)" },
                { "<C-g>we",    "<cmd>GpWhisperEnew<cr>",      desc = "Whisper Enew" },
                { "<C-g>wn",    "<cmd>GpWhisperNew<cr>",       desc = "Whisper New" },
                { "<C-g>wp",    "<cmd>GpWhisperPopup<cr>",     desc = "Whisper Popup" },
                { "<C-g>wr",    "<cmd>GpWhisperRewrite<cr>",   desc = "Whisper Inline Rewrite" },
                { "<C-g>wt",    "<cmd>GpWhisperTabnew<cr>",    desc = "Whisper Tabnew" },
                { "<C-g>wv",    "<cmd>GpWhisperVnew<cr>",      desc = "Whisper Vnew" },
                { "<C-g>ww",    "<cmd>GpWhisper<cr>",          desc = "Whisper" },
                { "<C-g>x",     "<cmd>GpContext<cr>",          desc = "Toggle GpContext" },
            },
        })
    end,
}
