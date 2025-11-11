# Reflection Frontmatter Fix

## Issues Fixed

### 1. Snacks Dashboard Error ✅
**Problem**: Error on Neovim startup about `attempt to call a nil value` in dashboard.lua

**Fix**: Disabled Snacks dashboard in `lua/plugins/snacks.lua`
```lua
dashboard = { enabled = false }
```

### 2. Keybinding Conflict ✅
**Problem**: `<leader>zI` was mapped to both "Paste Image" and "Initialize review tracking"

**Fix**: Changed image paste keybinding
- **Old**: `<leader>zI` → Paste Image
- **New**: `<leader>zP` → Paste Image
- **Now**: `<leader>zI` → Initialize review tracking (spaced repetition)

### 3. Reflection Frontmatter Missing ✅
**Problem**: Reflections created with `<leader>zD` didn't have frontmatter

**Root cause**: Vimwiki's `auto_header = 1` setting was creating a header (`# filename`) before our template code could check if the file was empty.

**Fix**: Updated `<leader>zD` to detect auto-generated headers and replace entire buffer:
```lua
-- Check if file is new or only has auto-generated header
local is_new = (line_count == 1 and first_line == '') or
               (line_count <= 4 and first_line:match("^# %d+%-"))
```

Now detects files with only the auto-generated header pattern (e.g., `# 202510251416-...`) and replaces them with the full template.

---

## Testing After Restart

**1. Restart Neovim completely**
```bash
# Close Neovim and restart
```

**2. Test reflection creation**
```vim
<leader>zD
# Enter title or leave blank
```

**Expected result**:
```yaml
---
title: "Daily Reflection - 2025-10-25"
date: 2025-10-25
type: reflection
tags: [public, learning, reflection]
publish: true
---

# Daily Reflection - 2025-10-25

## What I Built/Learned Today
...
```

**3. Test spaced repetition**
```vim
# Open any note with frontmatter
<leader>zI  # Initialize review tracking
<leader>zr  # Mark as reviewed
<leader>zR  # Show due notes
```

**4. Test image paste (new key)**
```vim
# Copy an image
<leader>zP  # Changed from <leader>zI
```

---

## Updated Keybindings

| Key | Action | Notes |
|-----|--------|-------|
| `<leader>zD` | Create public reflection | ✅ Now has frontmatter |
| `<leader>zd` | Create private daily note | Already had frontmatter |
| `<leader>zI` | Initialize review tracking | ✅ No longer conflicts |
| `<leader>zr` | Mark as reviewed | Spaced repetition |
| `<leader>zR` | Show due notes | Spaced repetition |
| `<leader>zP` | Paste image | ✅ Changed from `<leader>zI` |

---

## Files Modified

1. `/Users/L021136/.config/nvim/lua/plugins/snacks.lua`
   - Disabled dashboard

2. `/Users/L021136/.config/nvim/lua/plugins/zettelkasten.lua`
   - Changed `<leader>zI` → `<leader>zP` for image paste
   - Updated `<leader>zD` to handle auto-generated headers

3. `/Users/L021136/zettelkasten/reflections/202510251416-temporal-workers-as-ddd-adapters.md`
   - Added missing frontmatter to existing reflection

---

## Why This Happened

**Vimwiki auto-header behavior**: When `vim.g.vimwiki_auto_header = 1` is set, Vimwiki automatically creates a header matching the filename when you open a new file. This happens BEFORE our custom Lua code runs, so the buffer is no longer empty when we check.

**Solution**: Detect the auto-generated header pattern and treat those files as "new" so we replace them with our template including frontmatter.

---

## Next Steps

✅ Restart Neovim
✅ Test `<leader>zD` to create a new reflection
✅ Verify frontmatter appears correctly
✅ Test spaced repetition with `<leader>zI`
✅ Use `<leader>zP` for image pasting

**Everything should work now!** 🎉
