# Spaced Repetition Quick Guide

Your custom spaced repetition system using frontmatter.

---

## Setup

**Restart Neovim** to load the new plugin.

---

## How It Works

Notes with review tracking in frontmatter:

```yaml
---
title: "JWT Token Security"
date: 2025-10-25
review_count: 3
last_reviewed: 2025-10-25
next_review: 2025-11-02
---
```

**Spacing intervals** (Fibonacci-like):
- Review 0: Tomorrow (1 day)
- Review 1: 2 days
- Review 2: 4 days
- Review 3: 8 days
- Review 4: 16 days
- Review 5: 32 days
- Review 6: 64 days
- Review 7: 128 days

Each successful review doubles the interval!

---

## Commands

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>zI` | Initialize | Add review tracking to note |
| `<leader>zr` | Mark reviewed | Update review count & next date |
| `<leader>zR` | Show due | Find notes due for review |

---

## Workflow

### Step 1: Mark Notes for Review

When you create an important zettel:

```vim
<leader>zn    " Create zettel
# Write your insights

<leader>zI    " Initialize review tracking
```

Frontmatter gets updated:
```yaml
---
title: "Your Note"
review_count: 0
last_reviewed: 2025-10-25
next_review: 2025-10-26    # Tomorrow
---
```

### Step 2: Daily Review

**Morning routine:**

```vim
<leader>zR    " Show notes due for review
```

Opens Telescope with notes that have `next_review:` in frontmatter.

For each note:
1. Read the note
2. Try to recall key points
3. If you remember → Press `<leader>zr`
4. If you forget → Just read and press `<leader>zr` anyway

### Step 3: System Updates Automatically

After pressing `<leader>zr`:

```yaml
---
review_count: 1          # Incremented
last_reviewed: 2025-10-25    # Updated to today
next_review: 2025-10-27      # Pushed forward (2 days)
---
```

**Message shows:**
```
✅ Reviewed! Next review in 2 days (2025-10-27)
```

---

## Example Session

**Create important zettel:**
```vim
<leader>zn
# Title: JWT Token Security
```

Write:
```markdown
---
title: "JWT Token Security Requires Secret Management"
date: 2025-10-25
type: permanent-note
tags: [security, authentication]
---

# JWT Token Security

Key insight: JWT security entirely depends on secret key protection.

## The Pattern
- Secrets must be validated (length, encoding)
- Environment variables need stripping
- Silent failures are dangerous

## Related
- [[cryptography-fails-silently]]
- [[defensive-input-validation]]
```

**Initialize review:**
```vim
<leader>zI
```

Output:
```
✅ Review tracking initialized. Next review: 2025-10-26
```

**Next day:**
```vim
<leader>zR    " Show due notes
# Opens Telescope, shows this note

<Enter>       " Open note
# Read and recall key points

<leader>zr    " Mark as reviewed
```

Output:
```
✅ Reviewed! Next review in 2 days (2025-10-27)
```

**Two days later:**
```vim
<leader>zR    " Note appears again
<leader>zr    " Review again
```

Output:
```
✅ Reviewed! Next review in 4 days (2025-10-31)
```

Intervals keep growing!

---

## Integration with Daily Notes

**In your daily note:**

```markdown
# Daily Note - 2025-10-25

## 📚 Review Session
Notes reviewed today:
- [[202510201200-jwt-security]] ✅
- [[202510191500-kubernetes-pods]] ✅
- [[202510181000-declarative-config]] ✅

Review count: 3
```

---

## Advanced: Forgetting

**If you forget something:**

Just press `<leader>zr` anyway - the review count still increases.

**To reset** (start over with short intervals):
Manually edit frontmatter:
```yaml
review_count: 0    # Reset to 0
next_review: 2025-10-26    # Tomorrow
```

---

## Which Notes to Review?

**Good candidates:**
- ✅ Key insights (patterns you want to remember)
- ✅ Complex concepts (hard to understand)
- ✅ Practical patterns (you'll use in code)
- ✅ Career knowledge (interviews, architecture)

**Don't need review:**
- ❌ Reference notes (just look them up)
- ❌ Project-specific notes (temporary context)
- ❌ Simple facts (easy to remember)

**Rule:** If you want to remember it long-term → Add review tracking

---

## Review Strategy

### Daily Review (Morning)

```vim
# Part of morning ritual
<leader>zR    " Check due notes
# Review 3-5 notes (5-10 minutes)
```

### Weekly Review (Friday)

```vim
# Find all notes with review tracking
<leader>zg
# Search: "review_count:"

# Check if any notes have been neglected
# Add review tracking to new important zettels
```

---

## Metrics

Track in weekly note:

```markdown
# Week of 2025-10-21

## 📊 Review Metrics
- Notes in SRS: 25
- Notes reviewed this week: 18
- Average review count: 3.2
- Notes due next week: 8
```

---

## Tips

### 1. Start Small
Don't add all notes to SRS at once.
Start with 5-10 most important.

### 2. Review Before Forgetting
The system reminds you, but you can review early:
```vim
<leader>zf    " Find note
<leader>zr    " Review it early
```

### 3. Connect While Reviewing
When reviewing, check backlinks:
```vim
<leader>zb    " What connects here?
```

Reinforces the web!

### 4. Add Context
When reviewing, if something's unclear:
```markdown
## Review Notes
2025-10-25: Forgot the connection to K8s. Added link.
2025-10-27: Much clearer now!
```

---

## Troubleshooting

### "No notes found" when pressing `<leader>zR`

**Cause**: No notes have review tracking yet

**Fix:**
```vim
<leader>zn    " Open a zettel
<leader>zI    " Initialize review
```

### Review count not updating

**Cause**: Frontmatter malformed

**Fix**: Manually fix frontmatter:
```yaml
---
review_count: 0
last_reviewed: 2025-10-25
next_review: 2025-10-26
---
```

(No quotes, proper YAML format)

---

## Comparison with Anki

| Feature | Custom System | Anki |
|---------|--------------|------|
| **Storage** | In your notes | Separate DB |
| **Context** | Full zettel | Just card |
| **Setup** | Built-in | Need export |
| **Mobile** | No | Yes |
| **Flexibility** | High | Medium |

**Custom system wins:**
- Notes are the source of truth
- Review in context
- No separate app

**Anki wins:**
- Mobile reviews
- Advanced algorithms
- Separate from work

**My recommendation:** Start with custom, add Anki later if needed.

---

## Quick Reference

```vim
INITIALIZE:
  <leader>zI    Add review tracking to note

REVIEW:
  <leader>zR    Show notes due today
  <leader>zr    Mark note as reviewed

WORKFLOW:
  1. Create zettel (<leader>zn)
  2. Initialize review (<leader>zI)
  3. Daily: Check due notes (<leader>zR)
  4. Review and mark (<leader>zr)
```

---

## Try It Now!

1. **Create a test zettel:**
   ```vim
   <leader>zn
   ```

2. **Write something important you want to remember**

3. **Initialize review:**
   ```vim
   <leader>zI
   ```

4. **Tomorrow, check for due notes:**
   ```vim
   <leader>zR
   ```

**After 30 days:** You'll have 20+ notes in spaced repetition, reinforcing your knowledge automatically! 🧠

---

## Integration with Publishing

**Important:** Review metadata stays private!

```yaml
---
title: "JWT Security"
publish: true          # This goes public
review_count: 3        # This stays private
last_reviewed: 2025-10-25    # This stays private
next_review: 2025-11-02      # This stays private
---
```

The aggregation script will filter out review fields when publishing.

Your review process is private. Your insights are public. Perfect! 🎯
