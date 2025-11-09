# Mason.nvim Quick Reference

## 🚀 Getting Started

```bash
# Just start Neovim - servers auto-install!
nvim
```

## 📋 Common Commands

### View & Manage Servers

```vim
:Mason              " Open Mason UI (interactive)
:MasonLog           " View installation log
:MasonUpdate        " Update all servers
:LspInfo            " Show active LSP servers
:LspRestart         " Restart LSP
```

### Install/Uninstall

```vim
:MasonInstall gopls         " Install specific server
:MasonUninstall gopls       " Remove a server
:MasonUpdateAll             " Update Mason + all tools
```

## 📦 Installed Servers

| Server | Language | Status |
|--------|----------|--------|
| lua_ls | Lua | ✅ Auto |
| basedpyright | Python (types) | ✅ Auto |
| ruff | Python (lint/import) | ✅ Auto |
| gopls | Go | ✅ Auto |
| ts_ls | TypeScript/JS | ✅ Auto |
| rust-analyzer | Rust | ✅ Auto |
| clangd | C/C++ | ✅ Auto |
| elixir-ls | Elixir | ✅ Auto |
| gleam | Gleam | ✅ Auto |
| jdtls | Java | ✅ Auto |
| sourcekit-lsp | Swift | ⚠️ Manual (Xcode) |

## 🔧 Configuration Locations

```
~/.config/nvim/
├── lua/plugins/
│   ├── mason.lua       " Server list & install options
│   └── lsp.lua         " Server-specific configuration
```

## ⚙️ Server Configuration

### Python (Ruff + basedpyright)

**Ruff** (linting & imports):
```lua
-- Automatic import organization
-- Auto-fix issues like unused imports
-- Fast, modern linter
```

**basedpyright** (type checking):
```lua
-- Type checking only (doesn't duplicate Ruff work)
-- Disabled: reportUnusedImport, reportUnusedVariable, etc.
-- Enabled: reportGeneralTypeIssues, reportOptionalMemberAccess
```

### Other Languages

Most servers use default configuration. See `lua/plugins/lsp.lua` for customizations.

## 🐛 Troubleshooting

### Servers not installing?

```vim
" Check what went wrong
:MasonLog

" Try manual install
:MasonInstall gopls
```

### LSP not working for a file?

```vim
" Check if server is installed
:Mason

" Check if active for this filetype
:LspInfo

" Might need to set filetype
:set filetype=python
```

### Format on save not working?

```vim
" Check server supports formatting
:LspInfo
" Look for "formatting" in capabilities

" If not supported, server doesn't have it
" Some servers only offer formatting via external tools
```

## 📝 Managing Servers

### Add a New Server

1. Edit `lua/plugins/mason.lua`:
```lua
ensure_installed = {
  'new-server',  -- Add here
  ...
}
```

2. If custom config needed, edit `lua/plugins/lsp.lua`:
```lua
local server_configs = {
  new_server = {
    settings = { /* your config */ }
  },
}
```

3. Restart Neovim or run `:MasonInstall new-server`

### Remove a Server

1. Remove from `ensure_installed` in `lua/plugins/mason.lua`
2. Optionally: `:MasonUninstall server-name`

## 🎯 Common Use Cases

### I just cloned the dotfiles

```bash
nvim
# Servers auto-install - just wait a minute
:Mason  # Check progress (optional)
```

### I want to update all servers

```vim
:MasonUpdate    " That's it!
```

### A specific server is broken

```vim
:MasonUninstall broken-server
:MasonInstall broken-server
:LspRestart
```

### I want to add Prettier (JS formatter)

```lua
" In lua/plugins/mason.lua ensure_installed:
'prettier',  " Add this line
```

Restart Neovim and `:Mason` will install it.

### Disable auto-format for a language

Create/edit `after/ftplugin/python.lua`:
```lua
vim.b.disable_autoformat = true
```

## 💡 Tips

- **Slow first startup?** Mason is installing servers - normal, happens once
- **Want to see progress?** Run `:Mason` in a split window
- **Need specific version?** Mason can pin versions (see documentation)
- **Multi-machine setup?** Works automatically on all machines!

## 📚 See Also

- `MASON_MIGRATION_GUIDE.md` - Complete guide
- `MASON_BEFORE_AFTER.md` - What changed
- `MASON_REFACTORING_SUMMARY.md` - Full details

## 🔗 Resources

- Mason Documentation: https://github.com/mason-org/mason.nvim
- Supported Servers: https://mason-registry.dev
- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
