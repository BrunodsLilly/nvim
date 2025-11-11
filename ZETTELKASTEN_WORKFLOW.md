# Zettelkasten Knowledge Capture Workflow

## The Second Brain Philosophy

Your Zettelkasten is not just a note-taking system—it's an extension of your thinking. It captures, connects, and compounds your knowledge over time, making you exponentially smarter.

**Core Principle:** *"Writing is thinking. To write well is to think clearly."*

---

## The 5-Layer Knowledge Architecture

### 1. 💭 Fleeting Notes (Capture)
**Purpose:** Quick capture without friction
**Lifetime:** 1-7 days
**Location:** `~/zettelkasten/fleeting/`

```vim
<leader>zn  " Create fleeting note
```

**When to use:**
- Mid-coding insights
- Shower thoughts
- Meeting observations
- Bug pattern recognition
- "Aha!" moments

**Capture Rule:** Don't think, just write. Processing comes later.

### 2. 🔍 Git Discovery Notes (Investigate)
**Purpose:** Document git investigations
**Lifetime:** Permanent
**Location:** `~/zettelkasten/git-discoveries/`

```vim
<leader>zg  " Create git discovery note
```

**When to use:**
- After `<leader>gF` reveals pattern
- After `<leader>gbi` finds bug
- When `<leader>gB` explains confusion
- After studying expert commits

**Investigation → Documentation Flow:**
```vim
<leader>gF          " Search for pattern
<leader>gB          " Understand context
<leader>zg          " Document discovery
```

### 3. 📚 Literature Notes (Process)
**Purpose:** Digest external knowledge
**Lifetime:** Permanent
**Location:** `~/zettelkasten/literature/`

**When to use:**
- After reading documentation
- Watching technical talks
- Code review insights
- Stack Overflow solutions
- Blog posts/articles

**Processing Template:**
1. **Quote** exactly (with source)
2. **Paraphrase** in your words
3. **Connect** to your work
4. **Question** assumptions

### 4. 💎 Permanent Notes (Distill)
**Purpose:** Your original insights
**Lifetime:** Forever
**Location:** `~/zettelkasten/permanent/`

**Quality Criteria:**
- **Atomic:** One idea per note
- **Autonomous:** Self-contained understanding
- **Connected:** Linked to other notes
- **Original:** In your voice
- **Practical:** Applicable to real work

### 5. 🚀 Project Notes (Apply)
**Purpose:** Active work documentation
**Lifetime:** Project duration
**Location:** `~/zettelkasten/projects/`

**Contents:**
- Design decisions
- Technical challenges
- Solutions found
- Lessons learned
- Performance metrics

---

## Git Archaeology Integration 🔍

### The Investigation-Documentation Loop

**Before Writing Any Code:**
```vim
<leader>gF          " Has this been done before?
<leader>gfa         " Who's the expert?
<leader>gfm         " What's the history?
<leader>zg          " Document findings
```

### Capturing Git Insights

#### When You Find a Bug Origin
```vim
<leader>gbi         " Bisect to find breaking commit
:Git show <sha>     " Understand the change
<leader>zg          " Create git discovery note
" Title: Bug: [Description]
" Commit: <sha>
" Root Cause: [Why it broke]
" Fix: [How to fix]
" Prevention: [How to avoid]
```

#### When You Discover a Pattern
```vim
<leader>gF          " Search for pattern usage
<leader>gfF         " Study evolution
<leader>zn          " Create permanent note
" Title: Pattern: [Name]
" Evidence: [Git commits showing pattern]
" Application: [Where to use]
```

#### When You Find Expert Code
```vim
<leader>gfa         " Identify expert
<leader>gl          " Read their commits
<leader>zn          " Extract principles
" Title: Learning from [Expert]
" Commits studied: [list]
" Key insights: [what you learned]
```

---

## Daily Workflow Integration

### Morning Ritual (5 min)
```bash
# 1. Open today's daily note
nvim
<leader>zd  # Today's daily note

# 2. Review yesterday's fleeting notes
<leader>zf  # Find notes
/fleeting.*yesterday

# 3. Check recent git activity
<leader>gft # What changed overnight?

# 4. Set learning intention
"What do I want to understand better today?"
```

### During Development

#### When You Learn Something New
```vim
" Quick capture
<leader>zn  " New fleeting note
" Title: [Quick description]
" Content: [What you learned]
" Context: [Where/why you learned it]
:w

" Continue coding
```

#### When You Solve a Problem
```vim
" Document the pattern
<leader>zn
" Title: Solution - [Problem description]
" Problem: [What wasn't working]
" Solution: [What fixed it]
" Why it works: [Underlying principle]
" Future application: [Where else this applies]
```

#### When You Read Documentation
```vim
" Create literature note
<leader>zn
" Choose: literature/[source-name].md
" Capture key concepts with quotes
" Add your interpretation
" Link to current project
```

### Evening Processing (15 min)

```vim
" 1. Open daily note
<leader>zd

" 2. Process fleeting notes
<leader>zf
/fleeting/

" For each fleeting note:
"   - Expand into permanent note OR
"   - Add to project documentation OR
"   - Delete if not valuable

" 3. Create permanent notes
<leader>zn
" Choose: permanent/[concept].md
" Write principle clearly
" Add evidence from today
" Link to related notes

" 4. Update daily metrics
" - Notes created: ___
" - Concepts understood: ___
" - Patterns recognized: ___
```

### Weekly Review (30 min)

```vim
" 1. Create weekly review
<leader>zw

" 2. Analyze note connections
<leader>zg  " Search for patterns
#development " Review by tag

" 3. Identify knowledge gaps
" What questions keep appearing?
" What concepts need deeper study?

" 4. Plan next week's learning focus
```

---

## Capture Triggers

### 🔴 Red Flags (Must Capture)
- "I don't understand why this works"
- "This is the third time I've googled this"
- "This would have saved me hours last week"
- "This contradicts what I thought"
- "This is a clever pattern"

### 🟡 Yellow Flags (Should Capture)
- "This is interesting"
- "I might need this later"
- "This relates to [other concept]"
- "This could be optimized"
- "Alternative approach"

### 🟢 Green Flags (Consider Capture)
- "Good to know"
- "Confirmation of existing knowledge"
- "Minor variation"
- "Tool-specific detail"

---

## Note Types & Templates

### 1. Git Discovery Note 🔍
```markdown
# Git Discovery: [Title]

## Investigation Question
What I was trying to understand:

## Git Commands Used
```bash
<leader>gF "search term"
<leader>gbi HEAD~20..HEAD
```

## Discovery
What I found:
- Commit: <sha>
- Author: [Name]
- Date: [When]

## Root Cause Analysis
Why this happened:

## Pattern Learned
The reusable insight:

## Application
Where else this applies:

## Prevention Strategy
How to avoid similar issues:

## Related
- [[permanent/pattern-name]]
- [[git-discoveries/similar-issue]]
```

### 2. Principle Note
```markdown
# Principle: [Name]

## Statement
[One sentence principle]

## Explanation
[Why this is true]

## Evidence
- From project: [[projects/X]]
- From git history: [[git-discoveries/Y]]
- From experience: [[daily/Z]]

## Application
- When to use:
- When to avoid:

## Related Principles
- Supports: [[permanent/A]]
- Contradicts: [[permanent/B]]
```

### 3. Pattern Note
```markdown
# Pattern: [Name]

## Context
When you see: [situation]

## Problem
[What makes this hard]

## Solution
[The pattern]

## Implementation
```code
[Example code]
```

## Evidence from Git
- First seen: [commit sha]
- Evolution: [[git-discoveries/pattern-evolution]]
- Expert usage: [developer name]

## Trade-offs
- Pros:
- Cons:

## Examples in Codebase
- [[projects/]]
```

### 4. Debugging Note
```markdown
# Debug: [Error/Issue]

## Symptom
[What you observed]

## Root Cause
[Why it happened]

## Git Investigation
- Found with: `<leader>gbi`
- Breaking commit: [sha]
- Working commit: [sha]

## Solution
[How you fixed it]

## Prevention
[How to avoid in future]

## Detection
[How to catch earlier]

## Related Bugs
- [[permanent/similar-issue]]
- [[git-discoveries/root-cause]]
```

### 5. Learning Path Note
```markdown
# Learning: [Technology/Concept]

## Current Understanding
[Where I am now]

## Goal Understanding
[Where I want to be]

## Resources
- [ ] [[literature/resource1]]
- [ ] [[literature/resource2]]

## Practice Projects
- [ ] [[projects/practice1]]

## Key Insights
- [[permanent/insight1]]

## Questions
- [ ] Question 1
- [ ] Question 2
```

---

## Power Features

### 1. The Daily Question
Each daily note starts with a question:
- Monday: "What pattern did I use most last week?"
- Tuesday: "What slowed me down yesterday?"
- Wednesday: "What could be abstracted?"
- Thursday: "What surprised me this week?"
- Friday: "What would I do differently?"

### 2. The Connection Game
Before closing daily note:
1. Pick a random permanent note
2. Find connection to today's work
3. Create linking note if valuable

### 3. The Teaching Test
Weekly: Pick a concept and write explanation for beginner
- If struggle → need more understanding
- If easy → ready to mentor others

### 4. The Refactoring Review
Monthly: Review permanent notes
- Merge similar concepts
- Split complex notes
- Update outdated information
- Strengthen connections

---

## Keyboard Shortcuts Reference

### Essential Knowledge Capture
```vim
<leader>ww   " Zettelkasten home
<leader>zd   " Today's daily note
<leader>zn   " New fleeting note
<leader>zg   " Git discovery note (NEW!)
<leader>zf   " Find notes
<leader>zD   " Public reflection
```

### Git Investigation Integration
```vim
<leader>gF   " Pickaxe: Find code history
<leader>gbi  " Bisect: Find breaking commit
<leader>gB   " Full blame popup
<leader>gb   " Toggle inline blame
<leader>gfa  " File contributors
<leader>gfF  " Follow file evolution
→ <leader>zg " Document findings
```

### Note Management
```vim
<leader>zb   " Show backlinks
<leader>zt   " Show tags
<leader>zl   " Insert link
<leader>zr   " Mark as reviewed (SRS)
<leader>zR   " Show due notes (SRS)
<leader>zI   " Initialize review tracking
```

### Advanced Features
```vim
<leader>zP   " Paste image (was zI)
<leader>zw   " Weekly review
<leader>zZ   " Word → Create note
<leader>zL   " Word → Link
[[           " Insert link (insert mode)
```

### In Vimwiki Files
```vim
<Enter>      " Follow link
<Backspace>  " Go back
<Tab>        " Next link
<S-Tab>      " Previous link
```

---

## Integration with Development Algorithm

### Stage 0: UNDERSTAND
- Create fleeting notes for requirements
- Link to similar past projects
- Capture design decisions

### Stage 2: TEST-FIRST
- Document test patterns discovered
- Link failing tests to debugging notes
- Capture TDD insights

### Stage 4: REFACTOR
- Document refactoring patterns
- Create permanent notes for principles
- Link code smells to solutions

### Stage 7: LEARN
- Process daily work into permanent notes
- Update project documentation
- Connect new learning to existing knowledge

---

## Knowledge Compound Interest

### Week 1-4: Foundation
- 5-10 fleeting notes/day
- 2-3 permanent notes/week
- Focus: Capture habit

### Month 2-3: Connection
- 3-5 permanent notes/week
- 10+ connections/week
- Focus: Linking knowledge

### Month 4-6: Emergence
- Patterns become visible
- Insights emerge from connections
- Focus: Synthesis

### Month 7-12: Mastery
- Instant recall of solutions
- Pattern recognition across domains
- Focus: Teaching others

### Year 2+: Innovation
- Original insights
- Novel connections
- Focus: Contributing new knowledge

---

## The Git-Zettelkasten Synergy 🔄

### Why Git + Notes = Exponential Learning

**Traditional Development:**
```
Code → Bug → Debug → Fix → Forget
```

**With Git-Zettelkasten Integration:**
```
Code → Investigate → Document → Learn → Never Repeat
     ↓        ↓           ↓         ↓
<leader>gF  <leader>zg  Pattern  Compound
```

### The Investigation Workflow

```vim
" 1. Question arises
"    'Why does this work?'

" 2. Investigate with git
<leader>gF          " Search history
<leader>gB          " Understand context
<leader>gfa         " Find expert

" 3. Document discovery
<leader>zg          " Git discovery note

" 4. Extract pattern
<leader>zn          " Permanent note

" 5. Apply learning
"    Never make same mistake
```

---

## Success Metrics

### Daily
- [ ] Created at least one fleeting note
- [ ] Performed 3+ git investigations
- [ ] Processed yesterday's fleeting notes
- [ ] Added to daily note
- [ ] Documented 1+ git discovery

### Weekly
- [ ] Created 2+ permanent notes
- [ ] Made 5+ connections
- [ ] Completed weekly review
- [ ] Extracted patterns from git history
- [ ] Published 1+ insight

### Monthly
- [ ] 10+ permanent notes
- [ ] 50+ git investigations
- [ ] Identified 3+ patterns
- [ ] Refactored note structure
- [ ] Built expertise in 1+ area through history study

---

## Common Pitfalls & Solutions

### Pitfall 1: Over-Capturing
**Symptom:** 100+ fleeting notes, none processed
**Solution:** Daily 15-minute processing slot

### Pitfall 2: Under-Connecting
**Symptom:** Isolated notes, no network
**Solution:** Every note must link to 2+ others

### Pitfall 3: Perfect Note Paralysis
**Symptom:** Never creating permanent notes
**Solution:** "Good enough" notes can be improved later

### Pitfall 4: Tool Obsession
**Symptom:** Tweaking system instead of using it
**Solution:** Freeze system for 30 days, just use it

---

## The Zettelkasten Mantras

1. **"Capture now, process later"**
2. **"One idea, one note"**
3. **"Links are more valuable than notes"**
4. **"Writing is thinking"**
5. **"Your future self will thank you"**

---

## Quick Start Challenge

### Day 1: Setup
```bash
~/.config/nvim/scripts/setup-zettelkasten.sh
```

### Day 2-7: Capture Week
- Goal: 5 fleeting notes/day
- Don't process, just capture

### Day 8-14: Process Week
- Goal: Turn fleeting → permanent
- Create 5+ permanent notes

### Day 15-21: Connect Week
- Goal: Link everything
- Find surprising connections

### Day 22-28: Review Week
- Analyze your knowledge graph
- Identify patterns
- Plan next month's focus

---

## Your Knowledge Flywheel

```
Capture → Process → Connect → Apply
   ↑                              ↓
   ←  Learn  ←  Share  ←  Create ←
```

The more you capture, the more you can connect.
The more you connect, the more you can create.
The more you create, the more you learn.
The more you learn, the more valuable your captures become.

**This is how you build a Second Brain that makes you unstoppable.**

---

*Start your first note now: `<leader>zd`*