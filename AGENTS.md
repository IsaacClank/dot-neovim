# Neovim config (`lua/my/`)

This is a personal Neovim configuration. The entrypoint is `init.lua` → `require("my").setup()`.

## Plugin management

Uses Neovim's native **`vim.pack`** (not lazy.nvim or packer). Lockfile at `nvim-pack-lock.json`. Custom commands:
- `:PackUpdate [name]` — update all or one plugin
- `:PackClean` — remove inactive plugins

New plugins are added via `vim.pack.add({ "https://github.com/..." })` in the relevant module's `setup()`. Plugin declarations are **not centralized** — each feature module declares its own dependencies.

## Architecture

| Module | Purpose |
|---|---|
| `core/ui.lua` | colorscheme (gruvbox-material), mini.notify, diagnostics |
| `core/options.lua` | `mini.basics` + manual `vim.o` settings (2-space indent, signcolumn=number, etc.) |
| `core/editing.lua` | leap.nvim, mini.pairs, mini.surround, mini.splitjoin, treesitter-textobjects (`af`/`if`) |
| `core/pack.lua` | `:PackUpdate`, `:PackClean` commands |
| `core/picker/` | dual picker: fzf-lua (active) + mini.pick (alternative, commented out in navigation) |
| `core/terminal.lua` | toggleterm.nvim (`<C-t>`, `:ToggleTerm`, `:TermNew`, `:TermSelect`) |
| `statusline.lua` | lualine with conditional sections |
| `explorer.lua` | nvim-tree (floating, width=60, `<Leader>ee`, `<Leader>ef`) |
| `session/init.lua` | mini.sessions, session file is `.vim-session` (in `.gitignore`) |
| `session/plugin/auto_restore.lua` | auto-restores local session on `VimEnter` if nvim wasn't started with a file argument |
| `session/plugin/recent_files.lua` | tracks recent files in `_G.my_recent_files`, persists to session file |
| `navigation.lua` | fzf-lua search bindings (`<Leader>s` prefix) |
| `lsp.lua` | `vim.lsp.enable()` for denols, jsonls, lua_ls, rust_analyzer, ts_ls, fish_lsp. Uses `nvim-lspconfig`. |
| `formatting.lua` | conform.nvim — format on save (500ms timeout). TS formatter selects deno_fmt vs prettier based on deno.json presence. |
| `completion.lua` | blink.cmp (requires Rust to build via `cargo build --release`), blink-ripgrep source, friendly-snippets |
| `git.lua` | lazygit (`:GitView`/`<Leader>gg`) + mini.diff (`:GitStage`, `:GitUnstageFile`, `]g`/`[g` hunks) |
| `bindings.lua` | mini.clue leader guide, pane resize bindings (`<Leader>pr`) |
| `agentic.lua` | opencode toggle terminal (`:Agentic`/`<Leader>a`/`<C-a>`) |

## Key mappings

| Prefix | Group |
|---|---|
| `<Leader>e` | Explorer |
| `<Leader>g` | Git |
| `<Leader>l` | LSP / Intellisense |
| `<Leader>s` | Search / Navigation |
| `<Leader>t` | Terminal |
| `<Leader>p` | Pane management |
| `<Leader>pr` | Pane resize |
| `<Leader>o` | Session |
| `<Leader>a` | Agentic (opencode) |
| `gl` | Leap motion |
| `af`/`if` | Treesitter textobjects (function outer/inner) |

## LSP formatter quirks

TS/TSX formatting depends on project root — detects `deno.json[c]` to pick `deno_fmt` vs `prettier`. TypeScript projects without deno.json will **require prettier** to be available.

## Environment detection

- **VSCode** (`v.g.vscode == 1`): skips all setup, wires clipboard
- **WSL** (uname contains "microsoft"): uses `clip.exe` / PowerShell for clipboard

## Style

Formatter is **stylua** at 80 cols. Config at `stylua.toml` (mostly defaults, column_width=80).
