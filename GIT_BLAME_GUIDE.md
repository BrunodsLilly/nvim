# Git Blame Guide

Complete guide to inline git blame and git operations in Neovim.

---

## Git Blame (Inline)

### Quick Start

Inline git blame is **enabled by default**! You'll see blame info at the end of each line:

```
const foo = bar;  // John Doe, 2025-10-25 - feat: add foo feature
```

### Blame Keymaps

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gb` | **Toggle Inline Blame** | Show/hide blame on all lines |
| `<leader>gB` | **Show Full Blame** | Show complete commit info in popup |
| `<leader>gbt` | **Toggle Virtual Text Blame** | Alternative blame display (git-blame.nvim) |
| `<leader>gbo` | **Open Commit URL** | Open commit in GitHub/GitLab browser |
| `<leader>gbc` | **Copy Commit SHA** | Copy commit hash to clipboard |
| `<leader>gbf` | **Copy File URL** | Copy file URL to clipboard |

### Blame Format

**Inline format**: `<author>, <date> - <summary>`

Example:
```
Jane Smith, 2025-10-24 - refactor: improve performance
```

**Full blame popup** (`<leader>gB`):
- Commit SHA
- Author & email
- Date & time
- Full commit message
- Changed files

---

## Git Hunk Navigation

Work with changed sections of code:

| Key | Action | Description |
|-----|--------|-------------|
| `]h` | **Next Hunk** | Jump to next changed section |
| `[h` | **Previous Hunk** | Jump to previous changed section |
| `<leader>ghp` | **Preview Hunk** | Show diff in floating window |
| `ih` | **Select Hunk** | Text object for hunk (in visual/operator mode) |

### Hunk Actions

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ghs` | **Stage Hunk** | Stage current hunk (or visual selection) |
| `<leader>ghr` | **Reset Hunk** | Discard changes in current hunk |
| `<leader>ghS` | **Stage Buffer** | Stage all changes in file |
| `<leader>ghR` | **Reset Buffer** | Discard all changes in file |
| `<leader>ghu` | **Undo Stage Hunk** | Unstage previously staged hunk |

**Visual mode**: Select lines and use `<leader>ghs` or `<leader>ghr` to stage/reset selection.

---

## Advanced Git Operations (Fugitive)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gs` | **Git Status** | Interactive git status window |
| `<leader>gc` | **Git Commit** | Open commit editor |
| `<leader>gp` | **Git Push** | Push to remote |
| `<leader>gP` | **Git Pull** | Pull from remote |
| `<leader>gl` | **Git Log** | Full git log |
| `<leader>gL` | **Git Log (Oneline)** | Compact git log |
| `<leader>gf` | **Git Fetch** | Fetch from remote |
| `<leader>gD` | **Git Diff Split** | Split view of changes |
| `<leader>gw` | **Git Write** | Stage current file |
| `<leader>gr` | **Git Read** | Checkout current file (discard changes) |

---

## Workflows

### 1. Review Changes Before Committing

```vim
" Open a changed file
" Inline blame is already showing who changed what

" Navigate through hunks
]h                    " Next change
[h                    " Previous change
<leader>ghp          " Preview hunk diff

" Stage hunks selectively
<leader>ghs          " Stage this hunk
<leader>ghu          " Undo if you change your mind

" Or stage entire file
<leader>ghS          " Stage all changes in file

" Commit when ready
<leader>gc           " Git commit
```

### 2. Understanding a Line of Code

```vim
" Cursor on the line you want to understand
<leader>gB           " Show full blame popup

" See:
" - Who wrote it
" - When it was added
" - Why (commit message)
" - What else changed in that commit

<leader>gbo          " Open commit in browser for full context
```

### 3. Finding Recent Changes

```vim
" See who changed what recently
<leader>gl           " Git log (full)
<leader>gL           " Git log (oneline, easier to scan)

" In git status
<leader>gs           " Interactive git status
" Press 's' on a file to stage
" Press 'u' to unstage
" Press '=' to see diff
```

### 4. Comparing Versions

```vim
<leader>gD           " Git diff split
" Left: Current working copy
" Right: Last committed version
" Navigate with <C-w>w between splits

" Or for specific file
:Gdiffsplit HEAD~3   " Compare with 3 commits ago
```

### 5. Quick Staging

```vim
" Visual mode: Select exact lines to stage
V5j                  " Select 5 lines
<leader>ghs          " Stage only those lines

" Or stage by hunk
]h                   " Jump to next change
<leader>ghp          " Preview what will be staged
<leader>ghs          " Stage it
```

---

## Git Blame Display Options

### Option 1: Inline Blame (Gitsigns) - Default

**Always visible** at end of line:
```lua
local foo = "bar";  // John Doe, 2025-10-25 - feat: add feature
```

**Toggle**: `<leader>gb`

**Customization** (in git.lua):
- `virt_text_pos = "eol"` - Position: end of line
- `delay = 500` - Show after 500ms
- Format: `<author>, <date> - <summary>`

### Option 2: Virtual Text Blame (git-blame.nvim)

**Shows at column 80**:
```lua
local foo = "bar";
                                                    John Doe • 2025-10-25 14:30 • feat: add feature
```

**Toggle**: `<leader>gbt`

**Benefits**:
- Doesn't shift text
- Fixed position (column 80)
- Can copy commit SHA
- Can open commit in browser

### Option 3: Full Blame Popup (Gitsigns)

**Floating window** with complete info:
```
Commit: abc123def456
Author: John Doe <john@example.com>
Date:   2025-10-25 14:30:00

feat: add feature for user authentication

This commit adds JWT authentication to the login flow
and improves security by hashing passwords with bcrypt.

Changed files:
  src/auth.js
  src/middleware.js
```

**Show**: `<leader>gB`

---

## Signs in Gutter

Visual indicators in the gutter (left of line numbers):

| Sign | Meaning |
|------|---------|
| `│` (green) | Line added |
| `│` (blue) | Line changed |
| `_` (red) | Line deleted |
| `┆` (gray) | Untracked file |

These update in real-time as you edit!

---

## Tips & Tricks

### Hide Blame Temporarily
```vim
<leader>gb           " Toggle off when it's distracting
<leader>gb           " Toggle back on when you need it
```

### Blame on Cursor Line Only
In `git.lua`, change:
```lua
current_line_blame = true,
current_line_blame_opts = {
  virt_text_pos = "eol",
  delay = 0,  -- Show immediately
}
```

### Blame Position Options
Change `virt_text_pos` in git.lua:
- `"eol"` - End of line (default)
- `"overlay"` - On top of text
- `"right_align"` - Right-aligned in window

### Custom Blame Format
In git.lua, change `current_line_blame_formatter`:
```lua
-- Default
"<author>, <author_time:%Y-%m-%d> - <summary>"

-- Just author and date
"<author> • <author_time:%Y-%m-%d>"

-- Include commit hash
"<author> (<abbrev_sha>) - <summary>"

-- Relative time
"<author>, <author_time:%R> - <summary>"
```

Available placeholders:
- `<abbrev_sha>` - Short commit hash
- `<orig_lnum>` - Original line number
- `<final_lnum>` - Current line number
- `<author>` - Author name
- `<author_mail>` - Author email
- `<author_time>` - Author timestamp
- `<summary>` - Commit message summary
- `<committer>` - Committer name
- `<committer_time>` - Commit timestamp

---

## Integration with LazyGit

You already have LazyGit configured:

```vim
<leader>gg           " Open LazyGit TUI
```

**Workflow**:
1. Edit files in Neovim
2. `<leader>gg` to open LazyGit
3. Stage/commit/push in TUI
4. Back to Neovim - blame updates automatically!

---

## Troubleshooting

### Blame not showing
```vim
" Check if git repo
:!git status

" Toggle blame on
<leader>gb

" Check gitsigns is attached
:Gitsigns attach
```

### Blame too slow
In git.lua, increase delay:
```lua
current_line_blame_opts = {
  delay = 1000,  -- Wait 1 second before showing
}
```

### Blame too long (wraps line)
Option 1: Use shorter format
```lua
current_line_blame_formatter = "<author>, <author_time:%m-%d>"
```

Option 2: Use column-based blame instead
```vim
<leader>gb           " Turn off inline blame
<leader>gbt          " Turn on virtual text blame (column 80)
```

### No gutter signs showing
```vim
" Check signcolumn
:set signcolumn?

" Should be "yes" or "auto"
:set signcolumn=yes
```

---

## Quick Reference Card

```
GIT BLAME:
  <leader>gb    Toggle inline blame
  <leader>gB    Show full blame popup
  <leader>gbt   Toggle virtual text blame
  <leader>gbo   Open commit in browser
  <leader>gbc   Copy commit SHA

HUNKS:
  ]h            Next hunk
  [h            Previous hunk
  <leader>ghp   Preview hunk
  <leader>ghs   Stage hunk
  <leader>ghr   Reset hunk

GIT OPS:
  <leader>gs    Git status
  <leader>gc    Git commit
  <leader>gp    Git push
  <leader>gD    Git diff split
  <leader>gg    LazyGit TUI

WORKFLOW:
  1. Edit code
  2. ]h to review changes
  3. <leader>ghp to preview
  4. <leader>ghs to stage
  5. <leader>gc to commit
```

---

## Restart Neovim

After making changes to git.lua:

```bash
# Close and restart Neovim
```

Then:
```vim
# Open any git-tracked file
# You should immediately see inline blame!

# Try the keymaps
<leader>gB           # Show full blame
<leader>gb           # Toggle on/off
]h                   # Jump to next change
```

**Inline git blame is now active!** 🎯
