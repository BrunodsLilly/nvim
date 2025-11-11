# Mason.nvim LSP Refactoring Guide

## Overview

Your LSP installation has been refactored to use **Mason.nvim** as a centralized package manager. This provides:

- ✅ **Automatic Installation**: LSP servers install automatically when first needed
- ✅ **Centralized Management**: One place to manage all language servers
- ✅ **Easy Updates**: All servers update together with `:MasonUpdate`
- ✅ **Better Error Handling**: Clear feedback when servers fail to install
- ✅ **Version Pinning**: Lock servers to specific versions if needed
- ✅ **Cleaner Code**: No hardcoded paths or manual configurations

## What Changed

### Before (Manual Setup)
```lua
-- Old approach: Direct vim.lsp.config() and vim.lsp.enable()
local servers = { 'lua_ls', 'ruff', 'basedpyright', 'gopls', ... }
for _, name in ipairs(servers) do
  vim.lsp.config(name, custom[name])
  vim.lsp.enable(name)
end
```

### After (Mason-Based Setup)
```lua
-- New approach: Automatic installation and setup via Mason
ensure_installed = {
  'lua-language-server',
  'basedpyright',
  'ruff',
  'gopls',
  ...
}

-- Then setup_handlers() in lsp.lua configures everything
```

## New File Structure

### `lua/plugins/mason.lua` (NEW)
- Manages Mason.nvim configuration
- Specifies `ensure_installed` list of all servers
- Configures Mason UI and installation options
- Handles automatic installation

### `lua/plugins/lsp.lua` (REFACTORED)
- Uses `mason-lspconfig.setup_handlers()` instead of manual loops
- Server-specific configurations in `server_configs` table
- Clean handler setup with fallback for unknown servers
- Special handling for sourcekit-lsp (not in Mason)

## Installation & Usage

### First Time Setup

When you start Neovim, Mason will automatically:

1. **Detect missing servers** from the `ensure_installed` list
2. **Install them** (this may take a minute on first launch)
3. **Setup** each server with its configuration
4. **Enable formatting** on save for all formatting-capable servers

### Managing Servers

```vim
:Mason                  " Open Mason UI
:MasonInstall <name>    " Install a specific tool
:MasonUninstall <name>  " Remove a tool
:MasonUpdate            " Update all installed tools
:MasonUpdateAll         " Update Mason and all tools
:MasonLog               " View Mason installation log
```

### Checking Server Status

```vim
:LspInfo                " Show active LSP servers
:Mason                  " View all installed tools in Mason UI
```

## Server Configuration Details

### Configured Servers (Auto-Installed via Mason)

| Server | Purpose | Config |
|--------|---------|--------|
| **lua_ls** | Lua development | Recognizes `vim` global |
| **basedpyright** | Python type checking | Delegates imports to Ruff |
| **ruff** | Python linting & imports | Organizes imports, fixes issues |
| **gopls** | Go support | Default setup |
| **ts_ls** | TypeScript/JavaScript | Default setup |
| **rust-analyzer** | Rust support | Default setup |
| **clangd** | C/C++ support | Default setup |
| **elixirls** | Elixir support | Dialyzer disabled |
| **gleam** | Gleam support | Default setup |
| **jdtls** | Java support | Default setup |

### Special Cases

#### Python (Ruff + basedpyright)
- **Ruff** handles: linting, import organization, auto-fixing
- **basedpyright** handles: type checking only
- Configuration prevents conflicts between the two

#### Elixir (elixirls)
- **Dialyzer** disabled (can be slow)
- **Dependency fetching** disabled
- Can be re-enabled in `lsp.lua` if needed

#### Swift (sourcekit-lsp)
- **Not available in Mason** (comes with Xcode)
- Automatically detected if available
- Only setup if `sourcekit-lsp` executable exists

## Troubleshooting

### Servers Not Installing

**Check Mason log:**
```vim
:MasonLog
```

**Common issues:**
- Network connectivity (required for downloads)
- Disk space (some servers are large)
- Incompatible OS (some servers only work on Linux/macOS/Windows)

### Specific Server Failed

**Try manual installation:**
```vim
:MasonInstall <server-name>
```

**Then check what went wrong:**
```vim
:MasonLog
```

### LSP Not Working for a File Type

**First verify the server is installed:**
```vim
:LspInfo
```

**Then check if LSP attached:**
- Open a file of that type
- Run `:LspInfo` again
- Should show active server for that filetype

**If still not working:**
1. Check server-specific configuration in `lua/plugins/lsp.lua`
2. Verify the filetype is correct (`:set filetype?`)
3. Check for diagnostic errors: `<leader>qf`

### Auto-Format Not Working

**Verify the client supports formatting:**
```vim
:LspInfo
```
Look for "formatting" in the capabilities list.

**If missing:**
1. The server doesn't support formatting
2. Add a formatter instead (see Formatters section below)

**To disable auto-format for specific files:**
Add to `after/ftplugin/<filetype>.lua`:
```lua
vim.b.disable_autoformat = true
```

### Port Already in Use (rare)

Some servers might try to use the same port. If you see connection errors:

```vim
:Mason
" Uninstall the problematic server, reinstall it
:MasonUninstall <server>
:MasonInstall <server>
```

## Adding New Servers

### To Add a Server

1. Add to `ensure_installed` in `lua/plugins/mason.lua`:
```lua
ensure_installed = {
  'new-server',  -- Add here
  ...
}
```

2. If custom configuration needed, add to `lua/plugins/lsp.lua`:
```lua
local server_configs = {
  new_server = {
    settings = {
      -- Your configuration here
    }
  },
  ...
}

-- And add a handler:
mason_lspconfig.setup_handlers({
  new_server = function()
    lspconfig.new_server.setup(server_configs.new_server)
  end,
})
```

3. Restart Neovim or run `:MasonInstall new-server`

## Optional: Adding Formatters

While formatters aren't required (LSP formatting works), you can add them:

```lua
-- In lua/plugins/mason.lua ensure_installed:
ensure_installed = {
  'prettier',     -- JavaScript/TypeScript/JSON
  'stylua',       -- Lua
  'black',        -- Python (alternative to Ruff)
  'google-java-format',  -- Java
}
```

Then use them with null-ls or conform.nvim if desired.

## Optional: Adding Debuggers

Debuggers are installed but not configured. Currently supporting:

```lua
ensure_installed = {
  'debugpy',      -- Python debugging (used by nvim-dap-python)
}
```

Already configured in `lua/plugins/dap.lua`.

## Migration Checklist

- [x] Created `lua/plugins/mason.lua`
- [x] Refactored `lua/plugins/lsp.lua` to use mason-lspconfig
- [x] Moved all server definitions to `ensure_installed`
- [x] Preserved all custom server configurations
- [x] Maintained auto-format on save behavior
- [x] Added special handling for sourcekit-lsp
- [x] Removed hardcoded paths (except sourcekit)

## Benefits of This Refactoring

### For Maintenance
- **Single source of truth**: All servers defined in one place
- **Easier updates**: `:MasonUpdate` updates everything
- **Clear dependencies**: `ensure_installed` list is explicit
- **Better error reporting**: Mason provides detailed feedback

### For Performance
- **Lazy loading**: Servers only loaded when needed
- **Efficient setup**: Mason handles caching efficiently
- **Smaller config**: Less code duplication

### For New Setup
- **Automatic installation**: New machines install servers on first run
- **No manual setup needed**: Just start Neovim and servers auto-install
- **Version consistency**: Everyone gets the same versions

## What Stayed the Same

✅ All custom server configurations preserved
✅ Python dual LSP strategy (Ruff + basedpyright)
✅ Auto-format on save behavior
✅ All language support (Lua, Python, Go, TypeScript, Rust, C++, Elixir, etc.)
✅ `gd` (go to definition), `<leader>cf` (format), etc. all work
✅ Diagnostic navigation with `]d` and `[d`

## Quick Reference

```vim
" Mason Commands
:Mason              " Open Mason UI
:MasonInstall foo   " Install specific tool
:MasonUninstall foo " Remove tool
:MasonUpdate        " Update all tools
:MasonLog           " View installation log

" LSP Commands
:LspInfo            " Show active servers
:LspRestart         " Restart LSP
:LspStart <name>    " Start a specific server
:LspStop <name>     " Stop a specific server
```

## Next Steps

1. **Start Neovim** - Mason will install missing servers
2. **Check installation**: `:MasonLog` if any issues
3. **Verify setup**: `:LspInfo` should show all servers
4. **Test formatting**: `:set filetype=python` then edit a Python file
5. **Enjoy!** Everything should work as before, but cleaner

---

For more Mason documentation, visit: https://github.com/mason-org/mason.nvim
