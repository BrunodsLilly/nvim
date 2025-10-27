# Getting Started: Zero to Productivity in 15 Minutes

## 🚀 Welcome!

You've just installed the most comprehensive developer productivity system for Neovim. This guide will get you productive in 15 minutes.

**Your transformation starts with one principle:**
> "Investigate before implementing, test before coding, capture everything."

---

## ⏱️ Minute 1-3: Installation Check

### Verify Everything Works
```vim
nvim                    " Start Neovim
:checkhealth           " Check system health
:Lazy                  " View plugin status
:Mason                 " Check LSP servers
```

**Expected:** All checks green, plugins loaded, LSPs installed.

### Quick Navigation Test
```vim
-                      " Open file manager (Oil)
<leader>ff             " Find files (Telescope)
<leader>fg             " Grep search
<C-\>                  " Toggle terminal
```

---

## ⏱️ Minute 4-8: Your First Investigation

### The Git Archaeology Experience

Open any code file in your project:
```vim
:e src/main.py         " Open a file
```

Now investigate its history:
```vim
<leader>gb             " Toggle inline blame
" See who wrote each line and when

<leader>gB             " Full blame on current line
" Read the commit message - understand WHY

<leader>gF             " Search for this code elsewhere
" See if this pattern exists elsewhere
```

**🎯 Key Insight:** Every line of code has a story. Git blame shows you the author, but the commit message tells you the *why*.

---

## ⏱️ Minute 9-12: Start Your Knowledge System

### Create Your First Daily Note
```vim
<leader>zd             " Create/open today's daily note
```

Fill in your template:
```markdown
# 2025-10-27

## 🎯 ONE Thing Today
- [ ] [What's the most important task?]

## 🔍 Questions to Investigate
- [ ] Why does X work this way?
- [ ] How was Y implemented?
- [ ] Who knows about Z?

## 📊 End of Day Metrics
- Git investigations: 0/3
- Tests written: 0/5
- Notes captured: 0/3
```

### Capture Your First Insight
```vim
<leader>zn             " Create fleeting note
```

Write anything you just learned:
```markdown
# Git blame shows commit context

The blame view isn't just about finding who to blame -
it's about understanding the context and reasoning
behind code changes.

Tags: #git #learning
```

---

## ⏱️ Minute 13-15: Your First Productive Session

### The Complete Workflow

1. **Set Your Mission**
```vim
:TodoWrite             " Create task list
" Add: Investigate authentication system
" Add: Write test for login
" Add: Implement login feature
```

2. **Investigate First**
```vim
<leader>gF             " Search: "authenticate"
" Learn from existing implementations
```

3. **Document Discovery**
```vim
<leader>zg             " Create git discovery note
" Document what you found
```

4. **Work With Git**
```vim
<leader>gg             " Open LazyGit
" Stage, commit with meaningful message
```

---

## 📊 The 5 Commands That Change Everything

Master these TODAY:

| Command | Purpose | When to Use | Impact |
|---------|---------|-------------|---------|
| `<leader>gF` | Search git history | Before coding ANYTHING | Find existing solutions |
| `<leader>gbi` | Bisect to find bugs | When something breaks | Find bugs in minutes |
| `<leader>zn` | Capture notes | Any insight or idea | Never lose learning |
| `:TodoWrite` | Task management | Starting any work | Maintain focus |
| `<leader>gg` | Git interface | Committing code | Professional workflow |

---

## 🎮 Your First Day Challenge

Complete these in order:

### Morning (30 min)
- [ ] Create daily note (`<leader>zd`)
- [ ] Set your ONE Thing for today
- [ ] Make 3 git investigations (`<leader>gF`)
- [ ] Create 3 fleeting notes (`<leader>zn`)

### Afternoon (30 min)
- [ ] Use git bisect once (`<leader>gbi`)
- [ ] Create a git discovery note (`<leader>zg`)
- [ ] Make 3 commits with `<leader>gg`
- [ ] Convert 1 fleeting → permanent note

### Evening (15 min)
- [ ] Update daily note with metrics
- [ ] Review what you learned
- [ ] Plan tomorrow's ONE Thing

**Success:** If you complete this, you've already transformed your workflow.

---

## 🗺️ Learning Path

### Week 1: Foundation
**Focus:** Learn the commands
- Read: `QUICK_WIN_WORKFLOWS.md`
- Practice: 5 investigations daily
- Goal: Muscle memory for Big 5 commands

### Week 2: Integration
**Focus:** Build the habit
- Read: `MASTER_WORKFLOW.md`
- Practice: Full daily workflow
- Goal: Natural investigation reflex

### Week 3: Acceleration
**Focus:** Extract patterns
- Read: `GIT_ARCHAEOLOGY_QUICKSTART.md`
- Practice: Pattern documentation
- Goal: Building knowledge graph

### Week 4: Mastery
**Focus:** Share and teach
- Read: `PUBLISHING_QUICKSTART.md`
- Practice: Publish insights
- Goal: Contributing to community

---

## 💡 Instant Productivity Wins

### Find Any Bug's Origin (2 min)
```vim
<leader>gbi            " Start bisect
" Mark current as bad
" Mark last known good
" Test at each step
" Git finds exact breaking commit
```

### Understand Any Code (30 sec)
```vim
<leader>gB             " Full blame on line
" Read commit message
" See what else changed
" Understand the context
```

### Never Lose an Idea (10 sec)
```vim
<leader>zn             " Quick note
" Type insight
:w                     " Save
" Continue coding
```

### Track Everything (1 min)
```vim
:TodoWrite             " Task list
" Break down work
" Mark in_progress
" Stay focused
```

---

## 🚨 Troubleshooting

### "I'm Lost"
- Start with `<leader>zd` (daily note)
- Use `:TodoWrite` to organize thoughts
- Press `<leader>gF` to explore

### "Commands Not Working"
- Run `:checkhealth`
- Try `:Lazy sync`
- Check you're in a git repository

### "Too Many Features"
- Focus ONLY on the Big 5 commands
- Ignore everything else for first week
- Add one new command per day after

### "Not Seeing Benefits"
- Are you investigating BEFORE coding?
- Are you capturing notes immediately?
- Are you reviewing daily notes?

---

## 🎯 The ONE Rule

If you remember nothing else:

> **Before writing ANY code, press `<leader>gF`**

This investigates whether your problem has been solved before. It will save you hours every week.

---

## 📈 What Happens Next?

### After Today
- You'll find code 3x faster
- You'll understand context immediately
- You'll never lose insights

### After 1 Week
- Investigation becomes automatic
- Your notes start connecting
- Debugging time cut in half

### After 1 Month
- 10x problem-solving speed
- Rich personal knowledge base
- Confident in any codebase

### After 3 Months
- Intuitive pattern recognition
- Teaching others naturally
- Innovation through connections

---

## 🏁 Start NOW

Your first command sequence:
```vim
nvim                   " Start Neovim
<leader>zd             " Create daily note
<leader>gF             " Make first investigation
<leader>zn             " Capture first insight
<leader>gg             " Make first commit

" Congratulations! You've begun."
```

---

## 📚 Next Steps

1. **Bookmark** `QUICK_REFERENCE.md` - Your command cheatsheet
2. **Read** `QUICK_WIN_WORKFLOWS.md` - 5-minute productivity gains
3. **Study** `MASTER_WORKFLOW.md` - The complete system
4. **Master** `GIT_ARCHAEOLOGY_QUICKSTART.md` - Investigation expertise

---

## 💪 Your Commitment

Make this promise to yourself:

> "I will use `<leader>gF` before writing any code today."

This single habit will transform everything.

---

## 🎉 Welcome to the Community

You're not just using a text editor. You're joining a methodology that will accelerate your growth as a developer.

**Your tools are ready. Your system is configured. Your transformation is inevitable.**

The only thing left is to begin.

---

**Start your timer. Your 15 minutes begins now.**

🚀 Press `<leader>zd` and let's go!