# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration for a macOS development environment, heavily customized for TypeScript/JavaScript development. The configuration is organized using the Lazy.nvim plugin manager and follows a modular structure.

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - loads dgrogan module
├── ftplugin/                   # Filetype-specific configurations
│   ├── json.lua
│   ├── md.lua
│   └── typescript.lua
└── lua/dgrogan/
    ├── init.lua                # Main initialization - loads set, remap, lazy_init
    ├── set.lua                 # Vim options and editor settings
    ├── remap.lua               # Key mappings and custom functions
    ├── lazy_init.lua           # Lazy.nvim plugin manager setup
    └── lazy/                   # Individual plugin configurations (~40 files)
        ├── init.lua
        ├── lsp.lua             # LSP setup with Mason, nvim-cmp
        ├── telescope.lua       # Fuzzy finder configuration
        ├── gp.lua              # AI assistant (gp.nvim) setup
        ├── treesitter.lua
        ├── harpoon.lua
        ├── oil.lua
        └── [other plugins...]
```

## Key Technologies

- **Plugin Manager**: Lazy.nvim
- **LSP**: nvim-lspconfig with Mason for language server management
- **Completion**: nvim-cmp with LuaSnip for snippets
- **Fuzzy Finding**: Telescope with live-grep-args extension
- **Treesitter**: For syntax highlighting and text objects
- **AI Integration**: gp.nvim configured for GitHub Copilot
- **Git**: Fugitive, GV, Gitsigns, Diffview
- **Primary Language**: TypeScript (uses typescript-tools.nvim)

## Architecture Patterns

### Plugin Loading
All plugins are loaded via Lazy.nvim. Each plugin has its own file in `lua/dgrogan/lazy/` that returns a table with:
- Plugin specification
- Dependencies
- Configuration function

### Configuration Flow
1. `init.lua` → requires `dgrogan` module
2. `lua/dgrogan/init.lua` → loads in order: set → remap → lazy_init
3. `lua/dgrogan/lazy_init.lua` → sets up Lazy.nvim to load all files in `lua/dgrogan/lazy/`
4. Each plugin file is loaded and configured independently

### Custom Functions
Many custom Lua functions are defined in `remap.lua`:
- Custom clipboard sync between vim and system clipboard
- Region/fold insertion helpers for TypeScript development
- Telescope-based import helpers for TypeScript modules
- File formatting functions (JSON with fixjson, TS with custom scripts)
- Functions to open files in Webstorm and Cursor editors

## Important Conventions

### Leader Key
- Leader is mapped to `<Space>`
- Most custom commands use `<leader>` prefix
- Telescope commands typically start with `<leader>k`
- AI commands (gp.nvim) use `<C-g>` prefix

### TypeScript Development
This config is heavily optimized for a specific TypeScript project structure:
- Uses `typescript-tools.nvim` instead of tsserver
- Custom import path resolution for infrastructure typings
- ESLint integration with custom shortcuts
- Custom compilation shortcuts that reload Chrome tabs
- TypeScript-specific keymaps for organizing imports: `<leader>ci`

### Project-Specific Paths
Many hardcoded paths exist for personal projects:
- `~/Dev/SlateRoot/Infrastructure` - main TypeScript project
- `~/Dev/SlateRoot/Content/` - content directory with episodes
- Custom shortcuts for navigating these paths

### External Tools Integration
- **fixjson**: Used for JSON formatting (`<leader>ff` for JSON files)
- **fmtfile.sh**: Custom shell script for TypeScript formatting
- **repomix**: Used by gp.nvim to generate codebase summaries
- **eslint**: Custom keymaps populate quickfix with lint results
- **webstorm/cursor**: Functions to open current buffer in external editors

## Development Workflow Features

### LSP Configuration
- Mason auto-installs: lua_ls, jsonls
- TypeScript uses typescript-tools.nvim (not tsserver via Mason)
- LSP keymaps set in `remap.lua` (lines 228-260):
  - `gd` - go to definition (TypeScript-aware)
  - `gD` - go to definition in vsplit
  - `gr` - references
  - `<space>rn` - rename
  - `<space>ca` - code actions
  - `<F1>` - open diagnostic float
  - `<F2>` / `<S-F2>` - next/prev diagnostic

### Telescope Shortcuts
Key telescope commands (all in `telescope.lua`):
- `<leader>kf` - find files (respecting gitignore)
- `<leader>kF` - find files (including ignored)
- `<leader>kg` - live grep with args
- `<leader>kwg` - grep word under cursor
- `<leader>kr` - LSP references
- `<leader>kds` - document symbols
- `<leader><Up>` - buffer switcher (MRU sorted)
- `<leader>q` - resume last search

### Git Workflow
- Fugitive for git commands (`:Tg` opens in new tab)
- GV for commit history (`:GVo` shows history for current oil.nvim directory)
- Custom auto-commit script: `<leader>gc`
- Gitsigns for inline git status

### AI Integration (gp.nvim)
Custom hooks defined in `gp.lua`:
- **Improve**: Improve code with explicit typing requirements
- **Refactor**: Refactor into methods with comments
- **Explain**: Explain selected code
- **GitCommitMessage**: Generate semantic commit messages from staged diff
- **BufferChatNewRepoMix**: Create chat with entire repo using repomix
- Visual mode: `<C-g>dc` - add method comment
- Normal mode: `<C-g>dg` - generate commit message
- Normal mode: `<C-g>db` - new chat with current buffer
- Normal mode: `<C-g>dr` - generate repomix output

### File Navigation
- **oil.nvim**: `-` opens parent directory editor
- **harpoon**: Quick file navigation
- Custom shortcuts to common files and directories in `remap.lua` (lines 198-206)

## Testing

No test framework is configured in this Neovim config. The neotest plugin is installed but may not be actively used.

## Common Operations

### Formatting Code
- `<leader>f` - LSP format current buffer
- `<leader>ff` - Custom format (JSON with fixjson, TS with fmtfile.sh)
- `<leader>ci` - Organize imports (TypeScript)

### Compiling TypeScript
- `<leader>cc` - Save all, run create_infra_declarations.sh, compile with tsc, reload Chrome
- `<leader>cd` - Save all, compile with tsc using quickfix

### Linting
- `<leader>cl` - Run eslint on `./src/**/*.ts` and populate quickfix
- `<leader>cp` - Same but filter out certain warnings
- `]q` / `[q` - Navigate quickfix list

### Working with External Editors
- `<leader>ws` - Open current buffer in Webstorm at cursor position
- `<leader>wp` - Open Infrastructure project in Webstorm
- `<leader>cs` - Open current buffer in Cursor (main workspace)
- `<leader>cx` - Open current buffer in Cursor (local workspace)

### Clipboard Management
- `<leader>y` - Interactive: copy to/from system clipboard
- `<A-y>` - Yank to system clipboard
- `<leader>p` (visual) - Paste without replacing yank buffer
- `<leader>d` - Delete to void register (preserves yank)

## Editor Settings (set.lua)

Key settings:
- Line numbers with relative numbering
- 4-space tabs (expanded)
- No swap files, persistent undo in `~/.vim/undodir`
- Smart case-insensitive search
- Scrolloff of 24 lines
- 120-character color column
- Cursor column highlighting enabled
- Auto-reload files changed externally

## Notes for AI Assistants

1. **Project Context**: This config assumes a specific project structure at `~/Dev/SlateRoot/` - many paths are hardcoded for this.

2. **Custom Scripts**: Several bash scripts are referenced (`create_infra_declarations.sh`, `fmtfile.sh`, `auto_commit.sh`) - these exist outside this config.

3. **Plugin Count**: ~40 plugins are configured. The main ones are documented above. Full list available in `lua/dgrogan/lazy/`.

4. **Filetype Configs**: Check `ftplugin/` directory for language-specific settings.

5. **macOS Specific**: Uses osascript for Chrome integration, assumes macOS paths and tools.

6. **Personal Preferences**: Heavy use of visual mode mappings, custom text objects, and project-specific shortcuts reflecting an individual workflow.
