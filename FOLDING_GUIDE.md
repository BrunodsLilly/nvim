# Folding Quick Reference

Your Neovim is configured with smart folding using Treesitter. All folds start open, so you control when to fold.

---

## 🎯 Most Useful Commands

| Key | Action | Use Case |
|-----|--------|----------|
| **`za`** | Toggle fold under cursor | Most common - quick open/close |
| **`zM`** | Close ALL folds | Get overview of file structure |
| **`zR`** | Open ALL folds | See everything |
| **`zc`** | Close fold | Close current section |
| **`zo`** | Open fold | Open current section |

---

## Quick Actions

### Working with One Fold

```
za    Toggle fold (open if closed, close if open)
zc    Close fold
zo    Open fold
```

**Example**: Cursor on a function, press `za` to collapse it, `za` again to expand.

### Working with All Folds

```
zM    Close ALL folds (see file outline)
zR    Open ALL folds (see everything)
```

**Example**: Open large file, press `zM` to see just the structure, then `zo` on sections you want to read.

### Progressive Folding

```
zm    Fold MORE (close one level deeper)
zr    Reduce folding (open one level)
```

**Example**: In nested code, press `zm` repeatedly to progressively collapse deeper levels.

---

## Common Workflows

### 1. Navigate Large File

```
1. Open file
2. Press zM (close all folds)
3. See just top-level structure
4. Move to interesting section
5. Press zo or za to open that section
```

### 2. Focus on One Function

```
1. Move to function
2. Press zM (close everything)
3. Press zo (open just this function)
4. Work without distraction
```

### 3. Review Code Structure

```
1. Press zM (close all)
2. Press zr repeatedly (open level by level)
3. See hierarchy emerge
```

### 4. Hide Completed Sections

```
1. Finish working on a function
2. Press zc (close it)
3. Move to next section
4. Work stays visible, completed stays hidden
```

---

## Folding in Your Daily Workflow

### Morning Daily Note (`<leader>zd`)

```markdown
# Daily Note - 2025-10-25

## 🎯 Today's Focus        ← Press zc here to hide
- Primary problem
...

## 🤔 Questions I Have     ← Press zc here to hide
...

## 📊 Yesterday           ← Press zc here to hide
...
```

**Workflow:**
- Press `zM` - See just section headers
- Navigate to section you want
- Press `zo` - Work on that section

### Long Zettel Notes

```markdown
# Big Idea Note

## Summary               ← Fold to hide when reviewing
...

## Content               ← Fold when not editing
...

## Connections           ← Fold to focus on content
...

## References            ← Usually folded
...
```

### Code Files

```python
class UserAuth:              ← Press za to fold entire class
    def __init__(self):      ← Press za to fold just this method
        pass

    def login(self):         ← Press za to fold just this method
        # Implementation
        pass
```

---

## Advanced Patterns

### Recursive Folding

```
zA    Toggle fold recursively (folds within folds)
zC    Close all folds recursively
zO    Open all folds recursively
```

**Use case**: Nested classes or deeply nested sections.

### Visual Folding

```
1. Select text in visual mode (V)
2. Press zf (create fold)
3. Now za works on that fold
```

**Use case**: Temporarily fold arbitrary sections.

---

## Folding with Which-Key

When you press `z`, Which-Key shows you all fold commands:

```
z
├─ a → Toggle fold
├─ c → Close fold
├─ o → Open fold
├─ M → Close ALL
├─ R → Open ALL
└─ ...
```

You can also use `<leader>z`:
- `<leader>za` → Toggle fold
- `<leader>zM` → Close all
- `<leader>zR` → Open all

---

## Markdown-Specific Folding

In markdown files (like your zettels), folding works by heading level:

```markdown
# Level 1 Heading           ← Fold includes everything under this
## Level 2 Heading          ← Fold includes this section
### Level 3 Heading         ← Fold includes this subsection
Content here...
```

**Example workflow:**
```
1. Open zettel note
2. Press zM (close all)
3. See just headings: # Summary, ## Content, ## Connections
4. Navigate to ## Content
5. Press zo (open just that section)
6. Read or edit
```

---

## Tips & Tricks

### 1. Navigate Between Folds

```
zj    Move to next fold
zk    Move to previous fold
```

Jump between sections quickly!

### 2. Fold Everything Except Current

```
1. zM (close all)
2. zo (open current)
```

Focus mode!

### 3. Quick Overview

```
zM    Close all folds
zr    Open one level
zr    Open another level
```

Progressively reveal structure.

### 4. Check Fold Level

```
:set foldlevel?
```

Shows current fold depth.

---

## When to Use Folding

### ✅ Good Use Cases

- **Large files**: Navigate structure quickly
- **Daily notes**: Hide completed sections
- **Zettels**: Focus on one section at a time
- **Code review**: Hide boilerplate, focus on logic
- **Documentation**: Collapse sections you've read

### ❌ Don't Need Folding

- Small files (< 100 lines)
- Simple, flat structure
- When you need to see everything

---

## Your Fold Settings

```lua
-- Your config (init.lua:88-92)
foldmethod = 'expr'          -- Smart folding with Treesitter
foldexpr = treesitter        -- Uses code structure
foldlevel = 99               -- Start with all open
foldlevelstart = 99          -- Always start unfolded
foldenable = true            -- Folding is on
```

**What this means:**
- Files open with no folds (you decide what to fold)
- Treesitter makes folds smart (functions, classes, sections)
- You're in control

---

## Quick Muscle Memory

Practice this sequence:

```
1. Open DAILY_STRUCTURE.md
2. Press zM    (close all - see outline)
3. Press j     (move down)
4. Press zo    (open section)
5. Read
6. Press zc    (close section)
7. Press j     (next section)
8. Press zo    (open next)
```

After 5 minutes, `za`, `zM`, `zR` will be automatic!

---

## The Fold Mindset

Think of folding like:
- **Zoom out** (`zM`) - See the forest
- **Zoom in** (`zo`) - See the tree
- **Toggle** (`za`) - Quick switch

Your files are origami. Fold and unfold as needed.

---

## Cheat Sheet

```
MOST COMMON:
  za     Toggle fold (⭐ use this 90% of the time)
  zM     Close all folds
  zR     Open all folds

ONE FOLD:
  zc     Close fold
  zo     Open fold
  zA     Toggle recursively

PROGRESSIVE:
  zm     Fold more (one level deeper)
  zr     Fold less (one level open)

NAVIGATE:
  zj     Next fold
  zk     Previous fold

REMEMBER:
  z = fold command
  a = all/toggle
  c = close
  o = open
  M = MORE (close all)
  R = REDUCE (open all)
```

---

## Try It Now!

1. Open `DAILY_STRUCTURE.md`
2. Press `zM` - See the outline
3. Press `zo` on "Morning Ritual"
4. Read the section
5. Press `za` - Toggle it closed
6. Press `zR` - Open everything

**After 10 uses, it becomes automatic!**

Happy folding! 📁
