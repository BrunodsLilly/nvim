# Quick Reference: The Complete Workflow System

## 🎯 The Master Commands (Learn These First)

### The Big 5 - Cover 80% of Your Needs

| Key | Command | Use For | Saves |
|-----|---------|---------|-------|
| `<leader>gF` | **Git Pickaxe** | "Has this been done?" | 30+ min |
| `<leader>gbi` | **Git Bisect** | "When did this break?" | 2+ hours |
| `<leader>zn` | **Quick Note** | "Capture this thought" | Ideas |
| `:TodoWrite` | **Task List** | "What am I doing?" | Focus |
| `<leader>gg` | **LazyGit** | "Commit my work" | Time |

**If you memorize only 5 commands, memorize these.**

---

## ⚡ Workflow Cheat Sheet

### Before Starting ANYTHING
```vim
<leader>gF          " Has someone solved this?
<leader>gfa         " Who's the expert?
:TodoWrite          " Break it down
<leader>zn          " Capture requirements
```

### When Something Breaks
```vim
<leader>gbi         " Bisect to exact commit
<leader>gB          " Understand the change
<leader>zg          " Document the fix
```

### When Confused
```vim
<leader>gb          " Toggle inline blame
<leader>gB          " Read full commit message
<leader>gfF         " Follow file evolution
<C-\>               " Ask Claude
```

### When Learning
```vim
<leader>gfa         " Find expert authors
<leader>gfF         " Study file history
<leader>zn          " Capture insights
<leader>zD          " Public reflection
```

### When Shipping
```vim
<leader>gg          " LazyGit for staging
<leader>cf          " Format code
:TodoWrite          " Check tasks done
<leader>pc          " Check publishable
```

---

## 🔥 The Complete Command Reference

### Git Archaeology (`<leader>g` prefix)
```vim
" ESSENTIAL
<leader>gF          " Pickaxe: Find when code added/removed
<leader>gbi         " Bisect: Find bug-introducing commit
<leader>gB          " Full blame popup with details
<leader>gb          " Toggle inline blame

" INVESTIGATION
<leader>gfa         " Show file contributors
<leader>gfF         " Follow file through renames
<leader>gfm         " Search commit messages
<leader>gft         " Commits since date
<leader>gfr         " Blame selected lines (visual)
<leader>gfh         " Show file at specific commit
<leader>gfR         " Git reflog
<leader>gfM         " Compare with main branch

" BASIC GIT
<leader>gg          " LazyGit TUI
<leader>gd          " Diffview
<leader>gs          " Git status (Fugitive)
<leader>gc          " Git commit
<leader>gp          " Git push
<leader>gP          " Git pull
```

### Knowledge Capture (`<leader>z` prefix)
```vim
" NOTES
<leader>zd          " Daily note (private)
<leader>zn          " New fleeting note
<leader>zg          " Git discovery note
<leader>zD          " Public reflection
<leader>zw          " Weekly review

" NAVIGATION
<leader>zz          " Follow wiki-link
<leader>zf          " Find notes
<leader>zb          " Show backlinks
<leader>zl          " Insert link

" SPACED REPETITION
<leader>zI          " Initialize review
<leader>zr          " Mark as reviewed
<leader>zR          " Show due notes

" ORGANIZATION
<leader>zt          " Show tags
<leader>zL          " Word → Link
<leader>zZ          " Word → Create note
```

### Task & TODO Management (`<leader>t` prefix)
```vim
" CENTRAL TODO.MD
<leader>td          " Open TODO.md
<leader>tD          " TODO.md in split
<leader>tt          " Quick add task
<leader>tm          " Show sprint metrics

" TODO COMMENTS IN CODE
<leader>ft          " Find TODO comments
<leader>fT          " Find TODO/FIX only
]t                  " Next TODO comment
[t                  " Previous TODO comment

" INTERACTIVE TODO
:TodoWrite          " Manage todo list

" CODE NAVIGATION
gd                  " Go to definition
gr                  " Find references
K                   " Hover docs
<leader>ca          " Code actions
<leader>rn          " Rename symbol

" TESTING & DEBUG
<leader>db          " Toggle breakpoint
<leader>dc          " Continue
<leader>dpt         " Debug pytest test
<leader>du          " Toggle DAP UI

" CODE QUALITY
<leader>cf          " Format code
]d / [d             " Next/prev diagnostic
<leader>xx          " Trouble diagnostics

" FILES
-                   " Oil file manager
<leader>ff          " Find files
<leader>fg          " Live grep
<leader>ft          " Find TODOs
```

### Publishing (`<leader>p` prefix)
```vim
<leader>pc          " Check publishable notes
<leader>pp          " Full publish workflow
<leader>pd          " Deploy to GitHub Pages
<leader>pa          " Aggregate content
<leader>pb          " Build & serve locally
```

### Session & UI
```vim
<leader>qs          " Restore session
<leader>qd          " Don't save session
<leader>uz          " Toggle Zen mode
<leader>uZ          " Toggle Zoom
<C-\>               " Toggle terminal
<space>st           " Split terminal
```

### Hunks (Git Changes)
```vim
]h                  " Next hunk
[h                  " Previous hunk
<leader>ghp         " Preview hunk
<leader>ghs         " Stage hunk
<leader>ghr         " Reset hunk
<leader>ghS         " Stage buffer
<leader>ghR         " Reset buffer
```

---

## 📊 The Daily Workflow

### Morning Startup (8:00 AM)
```vim
nvim                " Start Neovim
<leader>qs          " Restore session
<leader>zd          " Daily note
<leader>gft         " What changed overnight?
:TodoWrite          " Today's tasks
```

### Before Each Task
```vim
<leader>gF          " Search existing solutions
<leader>gfa         " Find who to ask
:TodoWrite          " Break down task
<leader>zn          " Capture requirements
```

### During Coding
```vim
<leader>gb          " Inline blame ON
gd                  " Navigate code
K                   " Read docs
<leader>zn          " Capture insights
```

### After Each Task
```vim
<leader>cf          " Format code
<leader>gg          " Stage and commit
<leader>zg          " Document discoveries
:TodoWrite          " Update task status
```

### End of Day (5:00 PM)
```vim
<leader>zd          " Complete daily note
<leader>gg          " Final commit
<leader>pc          " Check publishable
```

---

## 🚀 Power User Patterns

### The Investigation Chain
```vim
<leader>gF → <leader>gB → <leader>gfF → <leader>zg
(search)  → (blame)    → (evolution) → (document)
```

### The Debug Chain
```vim
<leader>gbi → <leader>gB → :Git show → <leader>zg
(bisect)   → (blame)    → (examine)  → (document)
```

### The Learning Chain
```vim
<leader>gfa → <leader>gfF → <leader>zn → <leader>zD
(expert)   → (study)     → (capture)  → (share)
```

### The Shipping Chain
```vim
:TodoWrite → <leader>cf → <leader>gg → <leader>pd
(complete) → (format)   → (commit)   → (publish)
```

---

## 💡 Context-Specific Commands

### "I'm Lost in This Codebase"
```vim
<leader>ff          " Find files by name
<leader>fg          " Search for text
<leader>gF          " Search for patterns
-                   " Browse with Oil
```

### "This Is Taking Too Long"
```vim
<leader>gF          " Find existing solution
<C-\>               " Ask Claude
<leader>gfa         " Ask the expert
```

### "I Keep Forgetting"
```vim
<leader>zn          " Quick capture
<leader>zI          " Add spaced repetition
<leader>zr          " Mark as reviewed
```

### "Ready to Share"
```vim
<leader>zD          " Create reflection
<leader>pc          " Check what's public
<leader>pp          " Preview locally
<leader>pd          " Deploy to world
```

---

## 🎮 Vim Motions Refresher

### Essential Motions
```vim
w/b                 " Word forward/back
0/$                 " Line start/end
gg/G                " File start/end
%                   " Matching bracket
*/#                 " Search word under cursor
```

### Text Objects
```vim
ciw                 " Change in word
di"                 " Delete in quotes
va{                 " Select around braces
```

### Powerful Combos
```vim
ggVG                " Select entire file
:%s/old/new/g       " Replace all
:g/pattern/d        " Delete lines matching
```

---

## 📈 Success Metrics

### Daily Minimums
```
☐ 3+ Git investigations (<leader>gF)
☐ 5+ Tests written
☐ 3+ Commits
☐ 3+ Notes captured
☐ 1+ Pattern extracted
```

### The Productivity Formula
```
Investigation + TDD + Capture = 10x Speed
```

---

## 🔑 The Golden Rules

1. **Investigate Before Coding**: Always `<leader>gF`
2. **Test Before Implementation**: Red → Green → Refactor
3. **Capture Everything**: `<leader>zn` reflexively
4. **Commit Atomically**: Small, focused changes
5. **Learn From History**: Git is your teacher

---

## ⚡ Emergency Commands

### "Neovim Is Broken"
```vim
:Lazy sync          " Update plugins
:checkhealth        " Diagnose issues
:Mason              " Check LSPs
```

### "Git Is Confused"
```vim
:!git status        " Check state
<leader>gg          " Use LazyGit UI
:!git reset --hard  " Nuclear option
```

### "I'm Overwhelmed"
```vim
:TodoWrite          " List everything
<leader>uz          " Zen mode
<leader>zd          " Brain dump to daily note
```

---

## 🎯 The ONE Command

If you remember nothing else:

> **`<leader>gF` - Git Pickaxe Search**

Use it before EVERY coding session. It will change how you work.

---

## 📋 Print This Section

```
MUSCLE MEMORY BUILDERS:
  <leader>gF     Before coding anything
  <leader>gbi    When something breaks
  <leader>zn     When you have a thought
  :TodoWrite     When starting work
  <leader>gg     When ready to commit

DAILY RITUAL:
  Morning:   <leader>zd → :TodoWrite
  Coding:    <leader>gF → Test → Code
  Insights:  <leader>zn → <leader>zg
  Evening:   <leader>gg → <leader>pc

THE SEQUENCE:
  Investigate → Understand → Test → Build → Capture → Share
```

**Tape this to your monitor. Practice until automatic.**

---

*Your fingers know the way. Let muscle memory guide you to mastery.*