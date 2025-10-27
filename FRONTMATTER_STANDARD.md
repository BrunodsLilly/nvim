# Frontmatter Standard

All notes now have YAML frontmatter with useful metadata and **`publish: false` by default**.

---

## Standard Frontmatter

Every note includes:

```yaml
---
title: "Note Title"
date: 2025-10-25
type: note-type
tags: [tag1, tag2]
publish: false
---
```

---

## Privacy First

**Default:** `publish: false`

Everything is **private unless explicitly marked public**.

To publish a note:
```yaml
publish: true  # Change false → true
```

---

## Note Types & Templates

### 1. General Note

**Type:** `note`

```yaml
---
title: "My Note"
date: 2025-10-25
type: note
tags: []
publish: false
---
```

**Command:** `<leader>zn`

### 2. Permanent Note (Zettel)

**Type:** `permanent-note`

```yaml
---
title: "Declarative Config Reduces Errors"
date: 2025-10-25
type: permanent-note
tags: [permanent, principle]
publish: false
---
```

**Template:** `permanent.md`

### 3. Fleeting Note (Inbox)

**Type:** `fleeting-note`

```yaml
---
title: "Fleeting: Quick Idea"
date: 2025-10-25
type: fleeting-note
tags: [fleeting, inbox, to-process]
publish: false
---
```

**Template:** `fleeting.md`

### 4. Literature Note

**Type:** `literature-note`

```yaml
---
title: "Literature: Book Name"
date: 2025-10-25
type: literature-note
tags: [literature, reading]
publish: false
source: "Book/Article URL"
author: "Author Name"
---
```

**Template:** `literature.md`

### 5. Project Note

**Type:** `project-note`

```yaml
---
title: "Project: Authentication System"
date: 2025-10-25
type: project-note
tags: [project, active]
publish: false
status: active
started: 2025-10-25
target: "2025-12-01"
---
```

**Template:** `project.md`

### 6. Daily Note

**Type:** `daily-note`

```yaml
---
title: "Daily Note - 2025-10-25"
date: 2025-10-25
type: daily-note
tags: [daily, private]
publish: false
---
```

**Command:** `<leader>zd`

### 7. Weekly Note

**Type:** `weekly-note`

```yaml
---
title: "Week of 2025-10-21"
date: 2025-10-21
type: weekly-note
tags: [weekly, review, private]
publish: false
---
```

**Command:** `<leader>zw`

### 8. Daily Reflection (Public)

**Type:** `reflection`

```yaml
---
title: "Daily Reflection - Learning Journey"
date: 2025-10-25
type: reflection
tags: [public, learning, reflection]
publish: true  # ← Public by default!
---
```

**Command:** `<leader>zD`

---

## Optional Metadata

### Spaced Repetition

Add to notes you want to review:

```yaml
---
title: "Note Title"
publish: false
review_count: 0
last_reviewed: 2025-10-25
next_review: 2025-10-26
---
```

**Commands:**
- `<leader>zI` - Initialize review tracking
- `<leader>zr` - Mark as reviewed
- `<leader>zR` - Show due notes

### Project Metadata

For project notes:

```yaml
---
status: active | on-hold | completed
started: 2025-10-25
target: 2025-12-01
---
```

### Literature Metadata

For literature notes:

```yaml
---
source: "URL or ISBN"
author: "Author Name"
---
```

---

## Publishing Rules

### What Gets Published?

**Only notes with `publish: true`** are published to your digital garden.

### What NEVER Gets Published?

1. **Daily notes** - Always private
2. **Notes in `work/` directory** - Never scanned
3. **Notes in `personal/` directory** - Never scanned
4. **Any note with `publish: false`** - Default

### Publishing Workflow

**1. Mark for publishing:**
```yaml
publish: true  # Change this
```

**2. Verify what will be published:**
```bash
cd ~/zettelkasten
grep -r "^publish: true" . --include="*.md"
```

**3. Run aggregation:**
```bash
cd ~/digital-garden
./scripts/aggregate-content.sh
```

**4. Preview before deploying:**
```bash
cd quartz
npx quartz build --serve
# Check http://localhost:8080
```

**5. Deploy:**
```bash
npx quartz sync --commit "Weekly update"
```

---

## Frontmatter Fields Reference

### Required Fields

```yaml
title: "Note Title"    # Human-readable title
date: 2025-10-25       # Creation date (YYYY-MM-DD)
type: note-type        # See types above
tags: [tag1, tag2]     # List of tags
publish: false         # Privacy control
```

### Optional Fields

```yaml
# Spaced Repetition
review_count: 0
last_reviewed: 2025-10-25
next_review: 2025-10-26

# Project Metadata
status: active
started: 2025-10-25
target: 2025-12-01

# Literature Metadata
source: "URL or ISBN"
author: "Author Name"

# Custom Fields
context: "What triggered this note"
priority: high
```

---

## Adding Frontmatter to Existing Notes

If you have old notes without frontmatter:

### Manual Method

```vim
1. Open note
2. Go to top: gg
3. Insert mode: O (capital O)
4. Type:
---
title: "Note Title"
date: 2025-10-25
type: note
tags: []
publish: false
---
<Esc>
```

### Helper Command

Add to your Neovim config for bulk updates:

```lua
vim.keymap.set("n", "<leader>zF", function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, 5, false)

  -- Check if already has frontmatter
  if lines[1] == "---" then
    print("Already has frontmatter")
    return
  end

  -- Get filename as title
  local filename = vim.fn.expand("%:t:r")
  local title = filename:gsub("-", " "):gsub("^%l", string.upper)
  local date = os.date("%Y-%m-%d")

  -- Insert frontmatter
  local frontmatter = {
    "---",
    string.format('title: "%s"', title),
    string.format("date: %s", date),
    "type: note",
    "tags: []",
    "publish: false",
    "---",
    "",
  }

  vim.api.nvim_buf_set_lines(buf, 0, 0, false, frontmatter)
  print("✅ Frontmatter added")
end, { desc = "Add Frontmatter to Note" })
```

**Usage:** Open old note, press `<leader>zF`

---

## Quick Reference

### Creating New Notes

All new notes automatically get frontmatter with `publish: false`:

```vim
<leader>zn    General note
<leader>zd    Daily note (private)
<leader>zw    Weekly note (private)
<leader>zD    Daily reflection (public by default!)
```

### Publishing Notes

```vim
1. Open note
2. Change: publish: false → publish: true
3. Save
4. Sunday: Run ./aggregate-content.sh
```

### Privacy Check

```bash
# See what you're about to publish
cd ~/zettelkasten
grep -r "^publish: true" . --include="*.md" | wc -l
```

---

## Benefits

1. **Privacy First** - Everything private by default
2. **Metadata Rich** - Easy to query and organize
3. **Consistent** - All notes follow same structure
4. **Searchable** - Find by type, tag, date
5. **Spaced Repetition** - Review tracking built-in
6. **Publishing Control** - Explicit opt-in

---

## Examples

### Publishing a Learning Note

```yaml
---
title: "JWT Token Security Pattern"
date: 2025-10-25
type: permanent-note
tags: [security, authentication, patterns]
publish: true  # ← Make public
---

# JWT Token Security

[Your insights...]
```

### Private Work Note

```yaml
---
title: "Project: Client ABC Integration"
date: 2025-10-25
type: project-note
tags: [project, work, client-abc]
publish: false  # ← Stays private (default)
status: active
---

[Confidential work content...]
```

### Public Blog Post

```yaml
---
title: "My Journey from VS Code to Neovim"
date: 2025-10-25
type: reflection
tags: [public, blog, neovim, journey]
publish: true  # ← Public blog post
---

[Blog content for digital garden...]
```

---

## Your Workflow

**Morning:**
```vim
<leader>zd    Open daily (publish: false)
# Write everything - stays private
```

**During work:**
```vim
<leader>zn    Create zettels (publish: false)
# All private by default
```

**Evening:**
```vim
<leader>zD    Create reflection (publish: true)
# Curated public post
```

**Before publishing:**
```vim
# Open important zettel
# Change: publish: false → publish: true
```

**Sunday:**
```bash
./aggregate-content.sh  # Only publish: true notes copied
```

---

## Remember

- **Default:** Everything private (`publish: false`)
- **Explicit:** Only `publish: true` goes public
- **Control:** You decide what to share
- **Safe:** Daily notes never published (not in script)

**Privacy by default. Sharing by choice.** 🔒
