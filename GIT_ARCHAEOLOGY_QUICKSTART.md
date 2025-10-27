# Git Archaeology Quick Start

**5-minute guide to using git investigation in your development workflow.**

---

## Why Git Archaeology?

You just said: *"I found an open source bug and using git on the command line was crucial for discovery and diagnosing it."*

**This is exactly how senior engineers work.** Git history is your:
- 🔍 **Bug hunting tool** - Find when bugs were introduced
- 📚 **Learning resource** - Study expert code evolution
- 🎓 **Documentation** - Understand "why" not just "what"
- 🧭 **Navigation system** - Find who knows what

---

## The 3 Core Investigation Commands

### 1. Inline Blame (Always On)
```vim
<leader>gb           " Toggle inline git blame
```

**See instantly:**
```lua
const foo = "bar";  // Jane Smith, 2024-10-15 - feat: add validation
```

**Use when:** Reading any code to understand its history.

---

### 2. Pickaxe Search (Most Powerful)
```vim
<leader>gF           " Find when code was added/removed
```

**Example:**
- Cursor on `authenticateUser`
- Press `<leader>gF`
- See every commit that added/removed this code
- Terminal shows full git history with diffs

**Use when:**
- "When was this function introduced?"
- "Who removed this feature?"
- "Is this pattern used elsewhere?"

---

### 3. Git Bisect (Bug Finder)
```vim
<leader>gbi          " Interactive bisect
```

**Workflow:**
1. `<leader>gbi` → start
2. Enter bad commit: `HEAD` (current, broken)
3. Enter good commit: `v1.0.0` (or `HEAD~20`)
4. Git checks out middle commit
5. Test your code
6. `<leader>gbi` → "good" or "bad"
7. Repeat until git finds exact breaking commit

**Use when:** "This worked last week, now it's broken."

---

## Your Investigation Toolkit

### Quick Discovery Commands

| Key | What It Does | When to Use |
|-----|--------------|-------------|
| `<leader>gB` | Full blame popup | "Tell me everything about this line" |
| `<leader>gfm` | Search commit messages | "Find all authentication work" |
| `<leader>gft` | Commits since date | "What changed this week?" |
| `<leader>gfa` | File contributors | "Who's the expert on this?" |
| `<leader>gfh` | File at commit | "What did this look like before?" |
| `<leader>gfF` | Follow renames | "Track file through refactorings" |

### Navigation

| Key | What It Does |
|-----|--------------|
| `]h` | Next change hunk |
| `[h` | Previous change hunk |
| `<leader>ghp` | Preview change |
| `<leader>gD` | Full diff split |

---

## Integrated Development Workflow

### Before Coding (Stage 0: UNDERSTAND)

```vim
" 1. Understand the area
<leader>gb           " Enable blame
<leader>gfa          " Who wrote this file?

" 2. Find similar patterns
<leader>gF           " Search for related code
<leader>gfm          " Search commit history

" 3. Capture learning
<leader>zg           " Create git discovery note
```

### During Bug Investigation

```vim
" 1. Find the problematic code
<leader>gB           " When was this changed?

" 2. See what else changed
:Git show <sha>      " Full commit context

" 3. Find when it broke
<leader>gbi          " Bisect to find exact commit

" 4. Document discovery
<leader>zg           " Git discovery note
# Title: "Auth bug introduced in refactoring"
```

### Learning from Experts

```vim
" 1. Find expert work
<leader>gfa          " Top contributors

" 2. Study their commits
<leader>gfF          " Follow file evolution

" 3. Extract patterns
<leader>zn           " Create permanent note
# Title: "Pattern: Expert test-first approach"
```

---

## The Git Discovery Note

**Capture your investigation:**

```vim
<leader>zg           " New git discovery note
# Enter title: "Auth middleware bug"
```

**Template includes:**
- Investigation question
- Git commands you used
- What you discovered
- Root cause analysis
- Pattern learned
- Application

**Workflow:**
1. Investigate with git commands
2. Press `<leader>zg` to document
3. Extract reusable pattern to `<leader>zn` (permanent note)
4. Link from daily note

---

## Integration with Development Algorithm

Git Archaeology is now **Stage 0.2** of your algorithm:

```
Stage 0: UNDERSTAND
├─ 0.1: Clarify Requirements
├─ 0.2: Git Archaeology 🆕
│  ├─ <leader>gF - Find similar code
│  ├─ <leader>gfa - Find experts
│  ├─ <leader>gB - Understand history
│  └─ <leader>zg - Capture learning
├─ 0.3: AI-Assisted Analysis
├─ 0.4: Dual Documentation (DDR + Zettel)
└─ 0.5: Work Breakdown
```

**Key principle:** Before writing code, study the git history to learn from those who came before you.

---

## Real-World Examples

### Example 1: Open Source Bug Discovery

**Your workflow:**
```bash
# 1. Find when it broke
git bisect start HEAD v2.0.0

# Or in Neovim:
<leader>gbi → start → HEAD → v2.0.0

# 2. Test at each commit
npm test
<leader>gbi → bad/good

# 3. Found it! commit abc123
<leader>gB           # See full blame
<leader>gbo          # Open in GitHub

# 4. Understand the context
:Git show abc123     # Full diff

# 5. Document
<leader>zg
# Title: "Middleware order bug in v2.1"
```

### Example 2: Learning New Codebase

```vim
" Open main entry file
:e src/index.js

" Enable blame
<leader>gb

" Read code WITH history
" Each line shows: Author, Date, Commit message

" Deep dive on interesting sections
<leader>gB           " Full commit info
<leader>gbo          " Open PR discussion

" Find who knows this best
<leader>gfa          " Top contributors
```

### Example 3: Understanding Architectural Decision

```vim
" Find when architecture changed
<leader>gF
# Search: "RepositoryPattern"

" Study the commits
# Terminal shows all commits with this code

" Capture the pattern
<leader>zn
# Title: "Pattern: Repository for data access"
# Learned from: commit abc123 by Jane Smith
```

---

## Quick Win: Your First Investigation

**Try this right now:**

1. Open any file in your project
2. Press `<leader>gb` - See blame inline
3. Pick an interesting line
4. Press `<leader>gB` - See full commit info
5. Press `<leader>gbo` - Open in browser (if GitHub/GitLab)
6. Read the PR discussion
7. Press `<leader>zg` - Document what you learned

**You just did git archaeology!** 🎉

---

## Cheat Sheet

### Investigation Flow

```
1. DISCOVER
   <leader>gb    Inline blame ON
   <leader>gB    Full blame popup
   <leader>gF    Pickaxe search

2. UNDERSTAND
   :Git show <sha>   Full commit
   <leader>gbo       Open in browser
   <leader>gfa       Find experts

3. DEEP DIVE
   <leader>gbi       Bisect to find bug
   <leader>gfF       Follow file history
   <leader>gfh       File at commit

4. CAPTURE
   <leader>zg        Git discovery note
   <leader>zn        Pattern note
   <leader>zd        Link from daily
```

### Quick Commands

```vim
ALWAYS ON:
  <leader>gb      Toggle inline blame

INVESTIGATION:
  <leader>gB      Full blame
  <leader>gF      Pickaxe search
  <leader>gbi     Interactive bisect

LEARNING:
  <leader>gfa     File experts
  <leader>gfF     Follow file
  <leader>gfm     Search commits

CAPTURE:
  <leader>zg      Git discovery note
  <leader>zn      Pattern note
```

---

## Integration Points

### With Daily Notes
```markdown
# Daily Note - 2025-10-26

## Git Discoveries
- [[git-discoveries/202510261430-auth-bug]]
  - Found via `git bisect`
  - Introduced in commit abc123
  - Pattern: [[permanent/middleware-order]]

## Questions Raised
- [ ] Why does middleware order matter?
  - Investigate: <leader>gF "middleware"
```

### With Reflections
```markdown
# Weekly Reflection

## Learning via Git
- Studied Jane's commits on auth system
- Used `<leader>gfF` to follow refactoring
- Extracted: [[permanent/pattern-factory]]

**Time saved:** 4 hours by learning from history
instead of reimplementing from scratch
```

### With Publishing
```yaml
# In git-discovery note frontmatter
publish: true  # Share discovery with community
```

Then:
```vim
<leader>pp          # Publish to digital garden
```

---

## Common Patterns

### Pattern 1: The Detective
```
Bug → <leader>gbi → Find commit → <leader>zg → Document
```

### Pattern 2: The Student
```
Expert code → <leader>gfF → Study evolution → <leader>zn → Extract pattern
```

### Pattern 3: The Archaeologist
```
Weird code → <leader>gB → Understand why → <leader>zg → Capture context
```

---

## Next Steps

1. **Restart Neovim** to load all commands
2. **Try one investigation** today using `<leader>gF`
3. **Create your first git discovery note** with `<leader>zg`
4. **Read full guide**: `GIT_ARCHAEOLOGY.md`
5. **Update your Development Algorithm** - Git Archaeology is now Stage 0.2

---

## Files Created

1. `DEVELOPMENT_ALGORITHM.md` - Updated with Git Archaeology (Stage 0.2)
2. `lua/plugins/git.lua` - 10 new investigation keymaps
3. `GIT_ARCHAEOLOGY.md` - Complete investigation guide
4. `GIT_ARCHAEOLOGY_QUICKSTART.md` - This file
5. `zettelkasten/templates/git-discovery.md` - Template for findings
6. `lua/plugins/zettelkasten.lua` - Added `<leader>zg` command

---

**You now have a complete Git Archaeology system integrated into your development workflow.** 🔍

**Key insight:** Git history isn't just version control—it's a knowledge base. Every bug leaves traces, every expert leaves lessons. Learn to read the history, and you accelerate your growth exponentially.

*"The best developers aren't just good coders—they're good archaeologists."*

---

**Start now:** Press `<leader>gb` in any file. Your git archaeology journey begins! 🚀
