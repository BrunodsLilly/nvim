# Zettelkasten FAQ: Links, Context, and Learning

## 1. What Are Active Contexts?

**Active contexts** are project notes that represent what you're currently working on.

### Example

In your daily note:
```markdown
## 🔗 Active Contexts
- [[project-microservices-migration]]
- [[learning-kubernetes]]
- [[client-acme-integration]]
```

### What They Are

- **Project notes** - Specific initiatives with start/end dates
- **Learning areas** - Topics you're currently studying
- **Work contexts** - Active client work or features

### Why Track Them?

When you capture a fleeting note or create a zettel, you can link it to active contexts:

```markdown
# Fleeting Note - JWT Security Issue

Found issue with JWT expiration.

**Context**: [[project-microservices-migration]]
**Related**: [[learning-kubernetes]]
```

Later, when reviewing the project, you'll see all related notes via backlinks!

### How to Use

**Morning:**
```vim
<leader>zd  " Open daily note
```

Write your active contexts:
```markdown
## 🔗 Active Contexts
- [[project-auth-system]]  ← Press <leader>zz to open/create
- [[learning-distributed-systems]]
```

**During work:**
When creating notes, mention active contexts:
```markdown
# 202510251200-jwt-token-security

This relates to [[project-auth-system]].
```

**Later:**
```vim
" Open project note
:e ~/zettelkasten/projects/project-auth-system.md

<leader>zb  " Show backlinks
# See all notes related to this project!
```

### Active Context Structure

```markdown
# Project: Microservices Migration

**Status**: Active
**Started**: 2025-10-01
**Target**: 2025-12-01

## Goal
Migrate monolith to microservices architecture.

## Key Decisions
- [[202510151200-ddr-service-boundaries]]
- [[202510201500-ddr-database-per-service]]

## Learning Notes
- [[202510251200-kubernetes-pod-scheduling]]
- [[202510221400-service-mesh-patterns]]

## Questions
- How to handle distributed transactions?
- What about shared data?

## Backlinks
(Use <leader>zb to see all notes linking here)
```

---

## 2. What Are Square Brackets [[]] For?

**`[[double brackets]]` are wiki-links** - the core of Zettelkasten!

### Syntax

```markdown
[[note-name]]                     # Link to note
[[note-name|Display Text]]        # Link with custom text
[[202510251200-jwt-security]]     # Link by zettel ID
```

### What Happens

When you write `[[kubernetes]]`:
- If `kubernetes.md` exists → Links to it
- If it doesn't exist → Creates a placeholder
- When you follow link → Opens or creates the file

### Types of Links

**1. Direct note links:**
```markdown
See [[kubernetes-deployment-strategies]]
```

**2. Zettel links with timestamps:**
```markdown
This pattern is similar to [[202510151200-declarative-config]]
```

**3. Hub/index links:**
```markdown
See [[kubernetes-hub]] for all K8s notes
```

**4. Links with custom text:**
```markdown
This uses [[kubernetes-pod-scheduling|K8s scheduling]]
```

### Why Wiki-Links Are Powerful

**Bidirectional connections:**
```markdown
# Note A
Links to [[note-b]]

# Note B
<leader>zb shows that Note A links here!
```

**Emergent structure:**
```markdown
You link [[kubernetes]] to [[distributed-systems]]
Later, [[distributed-systems]] to [[database-replication]]
Suddenly you see: K8s problems = database problems!
```

**No hierarchy:**
```markdown
Traditional: /cloud/kubernetes/deployment.md
Zettelkasten: [[deployment-strategies]] links to:
  - [[kubernetes]]
  - [[docker-swarm]]
  - [[nomad]]

No forced hierarchy - connections emerge!
```

---

## 3. How Do I Go to Links?

### Following Links

**Method 1: Telekasten (Recommended)**
```vim
" Cursor on [[link]]
<leader>zz    " Follow link (opens or creates note)
```

**Method 2: Vimwiki**
```vim
" Cursor on [[link]]
<Enter>       " Follow link
```

**Method 3: gf (Go to File)**
```vim
" Cursor on link text
gf            " Go to file
```

### Creating Links

**Method 1: Type as you go**
```markdown
I learned about [[kubernetes]]  ← Just type this
```
Then `<leader>zz` to create the note.

**Method 2: Visual selection**
```vim
1. Select text: viw or visual mode
2. <leader>zl    " Make selection a link
3. <leader>zz    " Follow to create
```

**Method 3: Word under cursor**
```vim
" Cursor on word
<leader>zL    " Word becomes [[word]] link
<leader>zZ    " Word becomes link AND creates note
```

**Method 4: Insert link**
```vim
<leader>zl    " Insert link (shows picker)
" Search for existing notes or type new name
```

### Navigation Commands

```vim
<leader>zz    " Follow link under cursor
<leader>zb    " Show backlinks (what links here?)
<leader>zf    " Find notes (search all)
<leader>zg    " Grep notes (search content)

<C-o>         " Go back (after following link)
<C-i>         " Go forward
```

### Quick Workflow

```markdown
Writing a note about Kubernetes...

"The control plane manages [[worker-nodes]]"
                              ↑
                      Cursor here, press <leader>zz
                              ↓
                   Opens worker-nodes.md (new or existing)
```

---

## 4. Spaced Repetition for Learning

**YES! This is brilliant for Zettelkasten!**

### The Idea

Your zettels contain insights. Review them at increasing intervals:
- Day 1: See note
- Day 2: Review
- Day 4: Review
- Day 8: Review
- Day 16: Review...

If you remember → Interval increases
If you forget → Interval resets

### Implementation Options

#### Option 1: Anki Integration (Best)

**Setup:**
1. Install Anki
2. Use `obsidian-to-anki` or similar
3. Mark zettels for review

**Workflow:**
```markdown
# 202510251200-declarative-config

Declarative configuration reduces operational errors.

## Anki
Q: What's the benefit of declarative configuration?
A: Reduces operational errors by specifying desired state instead of imperative steps

Q: Give 3 examples of declarative systems
A: Kubernetes, Terraform, SQL
```

Then sync to Anki deck!

#### Option 2: Simple Review System (Custom)

**Add frontmatter to zettels:**
```markdown
---
title: "Declarative Config Reduces Errors"
date: 2025-10-25
last_reviewed: 2025-10-25
next_review: 2025-10-27
review_count: 0
review_interval: 2
---
```

**Review command:**
```vim
<leader>zR    " Show notes due for review
```

**Implementation:**
Create `lua/plugins/zettel-review.lua`:

```lua
return {
  {
    "renerocksai/telekasten.nvim",
    config = function()
      -- Add custom review command
      vim.keymap.set("n", "<leader>zR", function()
        local today = os.date("%Y-%m-%d")
        -- Find notes with next_review <= today
        vim.cmd("Telescope find_files search_dirs=~/zettelkasten")
      end, { desc = "Review notes due today" })
    end,
  }
}
```

#### Option 3: Daily Review List

**Every morning in daily note:**
```markdown
# Daily Note - 2025-10-25

## 📚 Review Today
- [ ] [[202510251200-jwt-security]]
- [ ] [[202510201500-kubernetes-pods]]
- [ ] [[202510151200-declarative-config]]
```

Simple but effective!

### Spaced Repetition Algorithm

**Simple version (Fibonacci-like):**
```
Review 0: Today
Review 1: Tomorrow (1 day)
Review 2: 2 days later
Review 3: 4 days later
Review 4: 8 days later
Review 5: 16 days later
Review 6: 32 days later (1 month)
Review 7: 64 days later (2 months)
```

**If forgotten**: Reset to Review 0

### Implementation with Persistence

**Yes, we need to persist state!**

**Where to store:**
1. **Frontmatter** (my recommendation):
```yaml
---
review_count: 3
last_reviewed: 2025-10-25
next_review: 2025-11-02
---
```

2. **Separate database** (`.zettel-review.json`):
```json
{
  "202510251200-jwt-security": {
    "review_count": 3,
    "last_reviewed": "2025-10-25",
    "next_review": "2025-11-02"
  }
}
```

3. **Git notes** (advanced):
```bash
git notes add -m "review_count: 3"
```

### Recommended Setup: Anki Bridge

**Best approach: Use Anki!**

Create `~/zettelkasten/scripts/zettel-to-anki.sh`:

```bash
#!/bin/bash
# Convert zettels with Q&A sections to Anki cards

ZETTEL_DIR="$HOME/zettelkasten"
ANKI_IMPORT="$HOME/anki-import.txt"

# Find all zettels with ## Anki section
grep -rl "## Anki" "$ZETTEL_DIR" | while read file; do
  # Extract Q&A pairs
  # Generate Anki import format
  # Append to import file
done

# Import to Anki
# anki-import "$ANKI_IMPORT"
```

**In your zettels:**
```markdown
# 202510251200-Declarative Config Pattern

Config that declares desired state reduces errors.

## Content
[Your insights]

## Connections
- [[kubernetes]]
- [[terraform]]

## Anki
Q: What is declarative configuration?
A: Specifying desired end state instead of steps to achieve it

Q: Why does declarative config reduce errors?
A: System can self-heal to desired state, no imperative script bugs

Q: Give 3 examples of declarative systems
A: Kubernetes (manifests), Terraform (HCL), SQL (queries)
```

### Daily Review Workflow

**Morning:**
```vim
<leader>zd    " Open daily note
```

Check review section:
```markdown
## 📚 Review Due Today (Auto-generated)
- [[202510251200-jwt-security]]
- [[202510201500-kubernetes-pods]]
```

For each note:
1. Open it
2. Read
3. Try to recall key points
4. Check your memory
5. Update `last_reviewed` date

**With Anki:**
Just do your Anki reviews! The cards link back to zettels.

### Why This Is Powerful

**Traditional SRS**: Isolated flashcards
**Zettelkasten SRS**:
- Cards link to full context (zettels)
- Zettels link to other zettels
- You review in context
- Connections strengthen memory

**Example:**
```
Anki shows: "What is declarative config?"
↓
You answer
↓
Click link to [[202510251200-declarative-config]]
↓
See full context + connections to K8s, Terraform, React
↓
Understand pattern, not just fact!
```

---

## Quick Command Reference

### Links
```vim
<leader>zz    Follow link (opens/creates note)
<leader>zl    Insert link to note
<leader>zb    Show backlinks
<C-o>         Go back
<C-i>         Go forward
```

### Making Links
```vim
[[note-name]]               " Type wiki-link
<leader>zL (normal mode)    " Word → Link
<leader>zZ (normal mode)    " Word → Link + Create
<leader>zl (visual mode)    " Selection → Link
```

### Review (if implemented)
```vim
<leader>zR    Show notes due for review
```

---

## Try It Now!

1. **Follow a link:**
   - Open any note with `[[brackets]]`
   - Put cursor on link
   - Press `<leader>zz`
   - You jump to that note!

2. **Create a link:**
   - Type `[[my-new-idea]]`
   - Press `<leader>zz`
   - New note created!

3. **See backlinks:**
   - Open any note
   - Press `<leader>zb`
   - See what links to this note!

4. **Add active context:**
   - Open today's daily note: `<leader>zd`
   - Add: `[[project-learning-zettelkasten]]`
   - Press `<leader>zz` to create project note

---

## Next Steps for Spaced Repetition

Would you like me to:

1. **Set up Anki integration** (recommended)
2. **Create simple review system** with frontmatter tracking
3. **Build custom Telescope picker** for due reviews
4. **Create daily review script** that generates review lists

Let me know which approach interests you most!
