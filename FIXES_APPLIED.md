# Fixes Applied

## Issue 1: Messages Getting Cut Off

**Problem:** Error messages and notifications were truncated and couldn't be read fully.

**Solution:** Added keybinding to view full message history.

**Command:**
- `<leader>m` - Show full messages window (no truncation)

**Usage:**
When you see a truncated message, press `<leader>m` to see the complete message history in a scrollable buffer.

---

## Issue 2: Ruff Doesn't Support Go-to-Definition

**Problem:** Ruff is only a linter/formatter, not a full language server. Missing features:
- ❌ Go-to-definition (`gd`)
- ❌ Completions
- ❌ Type checking
- ❌ Hover documentation

**Root Cause:** Ruff alone can't provide IDE features like go-to-definition.

**Solution:** Added **basedpyright** alongside Ruff for complete Python support.

### Python LSP Setup (Dual Server)

Now you have **TWO** Python language servers working together:

| Server | Purpose | Features |
|--------|---------|----------|
| **Ruff** | Linting & Formatting | Fast linting, auto-fixes, import sorting |
| **basedpyright** | Language Intelligence | Go-to-definition, completions, type checking, hover docs |

### Configuration Details

**Ruff handles:**
- ✅ Code linting (style issues, errors)
- ✅ Auto-fixing violations
- ✅ Import sorting and organization
- ✅ Code formatting

**Basedpyright handles:**
- ✅ Go-to-definition (`gd`)
- ✅ Auto-completions
- ✅ Type checking
- ✅ Hover documentation (`K`)
- ✅ Find references (`gr`)
- ✅ Rename (`<leader>rn`)

**Configured to avoid conflicts:**
- Basedpyright import organizing is disabled (Ruff handles it)
- Basedpyright style/linting diagnostics are disabled (unused imports, variables, etc.)
- Type checking diagnostics are ENABLED (wrong parameters, type mismatches, etc.)
- Type checking is set to "basic" mode

---

## Installation

### Install basedpyright

Via Mason (in Neovim):
```vim
:Mason
" Search for "basedpyright" and install
```

Or via command line:
```bash
npm install -g @basedpyright/pyright
```

### Verify It Works

1. Open a Python file
2. Press `gd` on a function/class → should jump to definition ✅
3. Press `K` on a function → should show hover docs ✅
4. Press `<leader>cf` → should format and organize imports ✅

---

## Commands Summary

### View Messages
- `<leader>m` - Show full message history

### Python LSP Features
- `gd` - Go to definition (basedpyright)
- `K` - Hover documentation (basedpyright)
- `gr` - Find references (lspsaga + basedpyright)
- `<leader>ca` - Code actions (both servers)
- `<leader>rn` - Rename (lspsaga + basedpyright)
- `<leader>cf` - Format and organize imports (Ruff)
- `<leader>cF` - Format only (Ruff)

### LSP Management
- `:LspInfo` - Check which servers are attached
- `:Mason` - Manage LSP servers
- `:LspRestart` - Restart LSP servers if needed

---

## Why Basedpyright Instead of Pyright?

**Basedpyright** is a community fork of Pyright that:
- ✅ Faster and more configurable
- ✅ Better defaults
- ✅ More actively maintained
- ✅ Works perfectly with Ruff

Both are from Microsoft's Pyright project, basedpyright is just enhanced.

---

## Troubleshooting

### Go-to-definition Still Not Working?

1. Check LSP is attached:
   ```vim
   :LspInfo
   ```
   Should show both `ruff` and `basedpyright` attached.

2. Check basedpyright is installed:
   ```vim
   :Mason
   ```
   Search for basedpyright, ensure it's installed.

3. Restart LSP:
   ```vim
   :LspRestart
   ```

### Messages Still Cut Off?

Press `<leader>m` to see full history. If you want to increase the visible lines in the command area:

```lua
-- Add to init.lua
vim.opt.cmdheight = 2  -- Show 2 lines instead of 1
```

### Ruff and Basedpyright Conflicting?

They shouldn't conflict with the current config. You should see:
- **Ruff diagnostics**: Style issues, unused imports, formatting problems
- **Basedpyright diagnostics**: Type errors, wrong parameters, undefined names

If you see duplicate diagnostics:

1. Check `:LspInfo` - both should be attached
2. Check which server is reporting what: hover over diagnostic and it shows the source
3. Adjust `diagnosticSeverityOverrides` in lua/plugins/lsp.lua:60

If you want to disable type checking entirely:
```lua
-- In lua/plugins/lsp.lua, in basedpyright config:
analysis = {
  typeCheckingMode = "off",  -- Turn off all type checking
}
```

---

## Best Practices

### Python Development Workflow

1. **Write code** - basedpyright provides completions
2. **Check issues** - Ruff shows linting errors inline
3. **Format** - `<leader>cf` to format and organize imports
4. **Navigate** - `gd` to jump to definitions
5. **Refactor** - `<leader>rn` to rename symbols
6. **Debug** - `<leader>dpt` to debug tests

### Performance Tips

- Both servers are fast, but if Python files are huge (10k+ lines):
  - Disable treesitter for that file: `:TSDisable highlight`
  - Consider splitting large files

### Configuration Files

You can configure both tools with:

**pyproject.toml** (Ruff):
```toml
[tool.ruff]
line-length = 88
select = ["E", "F", "I"]  # Errors, pyflakes, isort

[tool.ruff.isort]
known-first-party = ["myapp"]
```

**pyrightconfig.json** (Basedpyright):
```json
{
  "typeCheckingMode": "basic",
  "reportMissingTypeStubs": false
}
```

---

---

## Issue 3: Dual Documentation Script Hanging

**Problem:** The `<leader>DD` keybinding would hang after entering a feature name because the script tried to launch Neovim from within Neovim (nested instance).

**Root Causes:**
1. Shell scripts using `read` for input don't work properly with Neovim's `:!` command execution
2. The script tried to execute `nvim -O` at the end, causing a nested Neovim instance hang

**Solution Applied:**
1. Updated the Lua keybinding to use `vim.ui.input()` to prompt for the feature name
2. Modified the script to accept the feature name as a command-line argument
3. Removed the `nvim -O` call from the script - it now just creates the files and outputs paths
4. The Lua function parses the script output and opens both files in splits directly

**Usage:**
```vim
<leader>DD  " Prompts for feature name, creates files, opens in splits
```

**What Happens:**
1. Prompts you for feature name (e.g., "user-authentication")
2. Creates both DDR and Zettelkasten files
3. Opens them in vertical splits automatically
4. Left pane: Project DDR, Right pane: Your Zettelkasten

**Technical Details:**
- File: `lua/plugins/development-algorithm.lua:16-41`
- Script: `scripts/dual-doc.sh`
- Uses `vim.fn.system()` to run script and capture output
- Parses output to extract file paths
- Opens files with `vsplit` and `edit` commands

---

## Issue 4: Glow Archived - Replaced with render-markdown.nvim

**Problem:** Glow repository was archived and is no longer maintained.

**Solution:** Replaced with `render-markdown.nvim` which provides superior in-buffer markdown rendering.

**Benefits:**
- In-buffer rendering (no separate preview window)
- Obsidian-like appearance
- Wiki-link support for Zettelkasten
- Beautiful checkboxes, callouts, and code blocks
- No external dependencies

**Usage:**
```vim
<leader>mr  " Toggle markdown rendering
```

---

## Status: ✅ ALL FIXED

All issues are now resolved:
- ✅ Full messages available with `<leader>m`
- ✅ Go-to-definition works with basedpyright + Ruff
- ✅ Dual documentation workflow works with `<leader>DD`
- ✅ Beautiful markdown rendering with `<leader>mr`

Restart Neovim and test it out!
