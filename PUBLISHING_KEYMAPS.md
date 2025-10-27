# Publishing Keymaps

Quick keymaps for publishing your digital garden with Quartz.

---

## Keymaps

| Key | Action | What It Does |
|-----|--------|--------------|
| `<leader>pa` | **Aggregate** | Run `aggregate-content.sh` to copy notes to Quartz |
| `<leader>pb` | **Build & Serve** | Build Quartz and start local server at http://localhost:8080 |
| `<leader>pd` | **Deploy** | Deploy to GitHub Pages (asks for commit message) |
| `<leader>pp` | **Publish** | Full workflow: Aggregate + Build + Preview |
| `<leader>pc` | **Check** | Show all notes marked with `publish: true` |

---

## Workflows

### Quick Preview (No Publishing)

```vim
<leader>pp
" Aggregates content + builds + serves locally
" Preview at: http://localhost:8080
```

### Publish to Internet

```vim
" 1. Check what will be published
<leader>pc

" 2. Aggregate content
<leader>pa

" 3. Preview locally (optional)
<leader>pb
" Visit http://localhost:8080

" 4. Deploy to GitHub Pages
<leader>pd
" Enter commit message when prompted
```

### Sunday Publishing Ritual

```vim
" Sunday evening: Review and publish your week's learnings

" Step 1: Check publishable notes
<leader>pc

" Step 2: Run full workflow
<leader>pp
" Preview at http://localhost:8080

" Step 3: If everything looks good, deploy
<leader>pd
" Commit message: "Week of Oct 21-25 learnings"
```

---

## What Each Command Does

### `<leader>pa` - Aggregate Content
- Runs `~/digital-garden/scripts/aggregate-content.sh`
- Copies notes from `~/zettelkasten/` to `~/digital-garden/quartz/content/`
- **Only copies notes with `publish: true`**
- Opens terminal split to show progress

### `<leader>pb` - Build & Serve
- Changes to Quartz directory
- Runs `npx quartz build --serve`
- Starts local server at http://localhost:8080
- Opens terminal split
- **Use this to preview before deploying**

### `<leader>pd` - Deploy to GitHub Pages
- Asks for confirmation
- Asks for commit message (default: "Weekly update")
- Runs `npx quartz sync --commit "message"`
- Pushes to GitHub Pages
- **Your site goes live after this!**

### `<leader>pp` - Full Publish Workflow
- Runs aggregation script
- Builds Quartz
- Starts local preview server
- **One command for the whole workflow**
- Perfect for quick preview before deploying

### `<leader>pc` - Check Publishable Notes
- Searches for all notes with `publish: true`
- Shows count and file list
- **Use this before publishing to verify what goes public**

---

## Example Session

**Scenario**: You wrote 3 zettels this week and want to publish them.

```vim
" 1. Open your zettels and change frontmatter
" Change: publish: false → publish: true

" 2. Check what will be published
<leader>pc
" Output:
" Total: 3 notes
" permanent/202510221300-declarative-config.md
" permanent/202510231500-temporal-patterns.md
" reflections/202510251600-daily-reflection.md

" 3. Run full workflow to preview
<leader>pp
" Terminal opens showing:
" ✅ Permanent notes: 2 copied
" ✅ Reflections: 1 copied
" Building Quartz...
" Serving at http://localhost:8080

" 4. Open browser to http://localhost:8080
" Verify everything looks good

" 5. Deploy to GitHub Pages
<leader>pd
" Prompt: Deploy to GitHub Pages? (y/N): y
" Prompt: Commit message: Week of Oct 21-25: Temporal + DDD learnings
" Terminal shows git push...
" ✅ Deployed!

" 6. Visit your live site!
```

---

## Terminal Splits

All commands open a terminal split showing progress:
- **Auto-resizes** to 15 lines for easy viewing
- **Shows real-time output** from scripts
- **Auto-closes** after completion (aggregate only)

To close a terminal split:
```vim
:q
" or
<C-w>q
```

---

## Privacy Check Before Publishing

**Always run `<leader>pc` first!**

```vim
<leader>pc
```

This shows:
1. **Count** of notes with `publish: true`
2. **List** of files that will be published
3. **Verify** no work/personal notes are included

**Remember**:
- Daily notes (`daily/`) - Never published (not in script)
- Work notes (`work/`) - Never scanned
- Personal notes (`personal/`) - Never scanned
- Only `publish: true` notes are copied

---

## Troubleshooting

### "Aggregate script not found"
```bash
# Check if script exists
ls ~/digital-garden/scripts/aggregate-content.sh

# If missing, recreate it from COMPREHENSIVE_PUBLISHING.md
```

### "Quartz directory not found"
```bash
# Check if Quartz is installed
ls ~/digital-garden/quartz/

# If missing, set up Quartz:
cd ~/digital-garden
git clone https://github.com/jackyzha0/quartz.git
cd quartz
npm i
```

### Preview not working
```bash
# Kill any running instances
pkill -f "quartz"

# Try again
<leader>pb
```

---

## Integration with Weekly Review

Add to your weekly note template:

```markdown
# Week of 2025-10-21

## 📊 Publishing Stats

Notes published this week:
- [[permanent/202510221300-declarative-config]]
- [[reflections/202510251600-daily-reflection]]

Total public notes: 45
Total private notes: 203

## 📝 Publishing Checklist

- [ ] Review notes for privacy (`<leader>pc`)
- [ ] Mark important zettels as `publish: true`
- [ ] Aggregate and preview (`<leader>pp`)
- [ ] Verify at http://localhost:8080
- [ ] Deploy to GitHub Pages (`<leader>pd`)
- [ ] Tweet/share new content

Published to: https://yourusername.github.io
```

---

## Quick Reference

```vim
PUBLISHING COMMANDS:
  <leader>pa    Aggregate content
  <leader>pb    Build & serve (preview)
  <leader>pd    Deploy to GitHub
  <leader>pp    Full workflow (aggregate + build + preview)
  <leader>pc    Check publishable notes

WORKFLOW:
  1. <leader>pc  (check what will be published)
  2. <leader>pp  (preview locally)
  3. <leader>pd  (deploy to internet)

WEEKLY RITUAL:
  Sunday: Review week → Mark notes public → Preview → Deploy
```

---

**Restart Neovim to load the new keymaps!** 🚀

After restart, try:
```vim
<leader>pc  " Check what's publishable
<leader>pp  " Run full preview workflow
```
