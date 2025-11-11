# Markdown Rendering Fix - render-markdown.nvim

## Issue
`<leader>mr` doesn't do anything - the markdown rendering toggle isn't working.

## Likely Causes

### 1. Plugin Not Installed
The plugin might not be synced/installed yet.

**Fix:**
```vim
:Lazy sync
```
Wait for installation to complete, then restart Neovim.

### 2. Not in a Markdown File
The plugin only activates for markdown files.

**Check:**
```vim
:set filetype?
```
Should show: `filetype=markdown` or `filetype=vimwiki`

**If not markdown:**
```vim
:set filetype=markdown
```

### 3. Plugin Hasn't Loaded
Check if the plugin is loaded:

```vim
:Lazy
```
Search for "render-markdown" - it should show as loaded.

### 4. Command Not Registered
Try the command directly:

```vim
:RenderMarkdown toggle
:RenderMarkdown enable
```

If you get "Not an editor command", the plugin isn't loaded properly.

## Quick Test

1. **Create a test markdown file:**
   ```bash
   nvim ~/test.md
   ```

2. **Add some content:**
   ```markdown
   # Heading 1
   ## Heading 2

   - [ ] Checkbox
   - [x] Done

   **Bold** and *italic*

   ```code
   print("hello")
   ```
   ```

3. **Try to enable rendering:**
   ```vim
   :RenderMarkdown enable
   ```

4. **Or use the keybinding:**
   ```vim
   <leader>mr
   ```

## Alternative: Manual Plugin Check

Run this in Neovim to see if the plugin is available:
```vim
:lua print(vim.inspect(require('render-markdown')))
```

If you get an error like "module 'render-markdown' not found", the plugin isn't installed.

## Solution Steps

### Step 1: Sync Plugins
```vim
:Lazy sync
```

### Step 2: Check Installation
```vim
:Lazy
" Look for "render-markdown.nvim" in the list
" Status should be "Loaded" or "Not Loaded"
```

### Step 3: If Not Loaded
The plugin loads on `ft = { "markdown", "vimwiki" }`, so it only loads when you open a markdown file.

Open a markdown file:
```vim
:e ~/test.md
```

### Step 4: Force Load (Debug)
```vim
:Lazy load render-markdown.nvim
```

### Step 5: Check for Errors
```vim
:messages
```
Look for any errors related to render-markdown.

## Expected Behavior

When working correctly:

1. **Open markdown file** → Plugin loads automatically
2. **Press `<leader>mr`** → Rendering toggles on/off
3. **Beautiful rendering** → Headers have backgrounds, code blocks have borders, checkboxes are visual

## Alternative Commands

If `<leader>mr` doesn't work, try:
```vim
:RenderMarkdown toggle    " Toggle rendering
:RenderMarkdown enable    " Force enable
:RenderMarkdown disable   " Force disable
:lua require('render-markdown').toggle()  " Lua version
```

## Fallback: Browser Preview

If render-markdown doesn't work, you can still use browser preview:

1. **Fix markdown-preview.nvim:**
   ```bash
   ~/.config/nvim/scripts/fix-markdown-preview.sh
   ```

2. **Use browser preview:**
   ```vim
   <leader>mp
   ```

## Debug Checklist

- [ ] Ran `:Lazy sync`
- [ ] Restarted Neovim
- [ ] Confirmed I'm in a markdown file (`:set ft?`)
- [ ] Checked `:Lazy` shows plugin loaded
- [ ] Tried `:RenderMarkdown enable` directly
- [ ] Checked `:messages` for errors
- [ ] Confirmed plugin file exists: `lua/plugins/markdown-preview-alternative.lua`

## Next Steps

1. **Run `:Lazy sync`** right now
2. **Restart Neovim**
3. **Open a markdown file**: `nvim ~/test.md`
4. **Try**: `:RenderMarkdown enable`
5. **If it works**, then `<leader>mr` will work too
6. **Report back** what you see!

---

*This is a new plugin - it might just need to be installed. Try `:Lazy sync` first!*