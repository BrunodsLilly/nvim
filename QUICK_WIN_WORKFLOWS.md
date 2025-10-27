# Quick-Win Workflows
## Immediate Productivity Gains in Under 5 Minutes

Get 10x productivity improvements TODAY with these battle-tested workflows. Each takes <5 minutes to execute.

---

## 🎯 The Power Shortcuts (Memorize These NOW)

### The Big 5 Commands

| Command | What It Does | When to Use | Time Saved |
|---------|--------------|-------------|------------|
| `<leader>gF` | **Pickaxe Search** | Before coding ANYTHING | 30+ min/problem |
| `<leader>gbi` | **Git Bisect** | When something breaks | 2+ hours/bug |
| `<leader>zn` | **Capture Note** | Any insight/thought | Never lose ideas |
| `:TodoWrite` | **Task Breakdown** | Starting any work | Clear focus |
| `<leader>gg` | **LazyGit** | Git operations | 10+ min/commit |

**Rule:** If you learn only 5 commands, learn these. They cover 80% of productivity gains.

---

## ⚡ Instant Productivity Workflows

### 1. The "Why Is This Broken?" (2 minutes)

```vim
<leader>gB          " See who last touched this line
" Read commit message - usually explains everything
<leader>gbo         " Open in GitHub for full context
```

**Success Rate:** 70% of bugs explained immediately

### 2. The "Find Expert" (30 seconds)

```vim
<leader>gfa         " Who knows this file best?
" Contact top contributor directly
```

**Impact:** Get answers from the right person immediately

### 3. The "Has This Been Done?" (1 minute)

```vim
<leader>gF          " Search for pattern/function
" Study existing implementations
```

**Result:** Don't reinvent the wheel

### 4. The "What Changed?" (30 seconds)

```vim
<leader>gft         " Show recent commits
" Enter: "1 day ago"
```

**Use Case:** Monday morning catch-up

### 5. The "Quick Capture" (10 seconds)

```vim
<leader>zn          " Fleeting note
" Type thought, save, continue coding
```

**Benefit:** Never interrupt flow, never lose insights

---

## 🔥 Problem-Specific Workflows

### "This Test Is Failing"

```vim
<leader>gB          " When did this test last pass?
:Git show <sha>     " What changed?
<leader>zg          " Document the fix
```
**Time:** 3 minutes vs 30 minutes of debugging

### "I Don't Understand This Code"

```vim
<leader>gb          " Enable inline blame
<leader>gB          " Read commit messages for context
<leader>gfF         " See how it evolved
```
**Result:** Understand legacy code in minutes

### "Need to Fix a Bug FAST"

```vim
<leader>gbi         " Start bisect
" Test at each commit (good/bad)
" Git finds exact breaking commit
<leader>gB          " Understand the breaking change
```
**Speed:** Find bug in 5-10 iterations vs hours of debugging

### "Starting New Feature"

```vim
:TodoWrite          " Break down the task
<leader>gF          " Search for similar features
<leader>zn          " Capture requirements
<leader>dpt         " Set up test file
```
**Impact:** Start with clarity and examples

### "Code Review Time"

```vim
]h                  " Jump between changes
<leader>ghp         " Preview each change
<leader>ghs         " Stage good changes
<leader>gc          " Commit with message
```
**Efficiency:** Review and commit in one flow

---

## 💎 The Daily Productivity Routine (15 min total)

### Morning (3 min)
```vim
nvim                " Start editor
<leader>qs          " Restore session
<leader>zd          " Daily note with goals
```

### Before Each Task (2 min)
```vim
<leader>gF          " Search for existing solutions
<leader>gfa         " Find who to ask
:TodoWrite          " Break down the task
```

### After Each Task (1 min)
```vim
<leader>zn          " Capture what you learned
<leader>gg          " Commit your work
```

### End of Day (3 min)
```vim
<leader>zd          " Update daily note
<leader>pc          " Check publishable notes
<leader>gg          " Final commit and push
```

---

## 🚀 Muscle Memory Builders

### Exercise 1: The Investigation Reflex
**Practice this 10 times today:**
```vim
" On any function/variable:
<leader>gF          " When was this added?
<leader>gfa         " Who wrote it?
```

### Exercise 2: The Capture Habit
**Do this after EVERY insight:**
```vim
<leader>zn          " Fleeting note
" Type: [one line insight]
:w                  " Save and continue
```

### Exercise 3: The Blame Reader
**Try on 5 different files:**
```vim
<leader>gb          " Toggle inline blame
" Read the commit messages
" Notice patterns in good commits
```

---

## 📊 Measurable Gains

### After 1 Day
- Find bugs 3x faster with `<leader>gbi`
- Understand any code with `<leader>gB`
- Never lose insights with `<leader>zn`

### After 1 Week
- Investigation becomes automatic
- Knowledge graph starts forming
- Debugging time cut by 50%

### After 1 Month
- 10x faster problem solving
- 100+ captured insights
- Expert-level codebase knowledge

---

## 🎯 The 5-Minute Challenges

### Challenge 1: Bug Hunt
```vim
" Find a bug in your code
<leader>gbi         " Bisect to exact commit
" Fix it
" Time yourself - should be <5 min
```

### Challenge 2: Pattern Search
```vim
" Pick a design pattern (e.g., "Singleton")
<leader>gF          " Find all implementations
<leader>zn          " Note the best one
```

### Challenge 3: Expert Finding
```vim
" Pick a complex file
<leader>gfa         " Find top contributor
<leader>gfF         " Study their commits
```

### Challenge 4: Knowledge Capture
```vim
" Set a timer for 5 minutes
" Create 5 fleeting notes
<leader>zn          " Capture anything you think
```

### Challenge 5: Publishing
```vim
" Pick your best insight
<leader>zD          " Create public reflection
<leader>pp          " Preview it
```

---

## 🔨 Troubleshooting Workflows

### "Command Not Working"
```vim
:Lazy sync          " Update plugins
:checkhealth        " Check for issues
```

### "Git Commands Failing"
```vim
:!git status        " Verify git repo
<leader>gg          " Use LazyGit UI instead
```

### "Lost in Codebase"
```vim
<leader>ff          " Find files
<leader>fg          " Grep for text
-                   " Oil.nvim file browser
```

### "Overwhelmed by Tasks"
```vim
:TodoWrite          " List everything
" Mark ONE as in_progress
" Focus only on that
```

---

## 💡 Pro Tips

### Tip 1: Chain Commands
```vim
<leader>gF<leader>zn   " Search then capture
<leader>gbi<leader>zg  " Bisect then document
```

### Tip 2: Use Terminal Splits
```vim
<space>st           " Horizontal terminal
" Run tests while editing
```

### Tip 3: Visual Mode Power
```vim
V                   " Select lines
<leader>gfr         " Blame just selection
```

### Tip 4: Quick Reviews
```vim
<leader>gft         " "1 hour ago"
" See everything that changed recently
```

### Tip 5: Link Everything
```vim
" In any note:
[[concept]]         " Create connections
<leader>zz          " Follow links
```

---

## 🎮 Gamification: Level Up

### Level 1: Novice (Day 1)
- [ ] Use `<leader>gF` 5 times
- [ ] Create 3 fleeting notes
- [ ] Complete 1 git bisect

### Level 2: Apprentice (Day 3)
- [ ] 10+ investigations/day
- [ ] 5+ notes/day
- [ ] Find 3 bugs with bisect

### Level 3: Journeyman (Week 1)
- [ ] Investigation before every task
- [ ] Convert fleeting → permanent
- [ ] Publish first note

### Level 4: Expert (Week 2)
- [ ] 50+ total investigations
- [ ] 20+ permanent notes
- [ ] Help someone with your knowledge

### Level 5: Master (Month 1)
- [ ] Intuitive investigation
- [ ] Rich knowledge graph
- [ ] Teaching others

---

## 🚦 Start RIGHT NOW

### Your Next 5 Minutes

```vim
" 1. Open your current project
nvim

" 2. Pick any file you're working on
:e src/main.py

" 3. Investigate something
<leader>gF          " Search for main function
<leader>gfa         " Who wrote this?

" 4. Capture what you learned
<leader>zn          " Quick note about discovery

" 5. Commit to daily practice
<leader>zd          " Daily note: "I will investigate before coding"
```

---

## 📈 The Compound Effect

### Every Investigation Compounds
- **Day 1**: Learn one pattern
- **Day 7**: Recognize patterns everywhere
- **Day 30**: Predict patterns before seeing them
- **Day 90**: Think in patterns naturally

### Every Note Compounds
- **1 note**: One insight
- **10 notes**: Connections emerge
- **100 notes**: Knowledge web forms
- **1000 notes**: Expert knowledge base

---

## 🎯 The ONE Thing

If you do nothing else, do this:

> **Before writing ANY code, press `<leader>gF`**

This single habit will transform you from a coder to an investigator, from a bug fighter to a bug preventer, from a solo developer to someone learning from the entire team's history.

---

## ⚡ Quick Reference Card

```
INSTANT PRODUCTIVITY:
  <leader>gF     Find when code added (BEFORE CODING!)
  <leader>gbi    Bisect to find bugs (WHEN BROKEN!)
  <leader>gB     Full blame (WHEN CONFUSED!)
  <leader>zn     Capture thought (WHEN INSIGHT!)
  :TodoWrite     Break down work (WHEN STARTING!)

DAILY MINIMUMS:
  Morning:  <leader>zd  (daily note)
  Coding:   <leader>gF  (investigate first)
  Insights: <leader>zn  (capture always)
  Evening:  <leader>gg  (commit work)

THE RULE:
  Investigate → Understand → Code → Capture
  Never skip investigation.
  Never lose insights.
```

---

**Copy this card. Print it. Tape it to your monitor.**

Your productivity transformation starts with the next `<leader>gF`.

🚀 **Go press `<leader>gF` right now!**