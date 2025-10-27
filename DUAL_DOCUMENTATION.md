# Dual Documentation Strategy
## Project Knowledge + Personal Learning

You've discovered the secret: **Document twice, learn forever**. Project documentation captures WHAT you built. Personal documentation captures WHAT YOU LEARNED. Together, they make you unstoppable.

---

## The Two-Layer System

### 📁 Layer 1: Project Documentation (`docs/ddr/`)
**Audience:** Your team, future maintainers
**Purpose:** Explain decisions for the project
**Lifetime:** Lives with the project
**Content:** What, Why, Trade-offs

### 🧠 Layer 2: Personal Zettelkasten (`~/zettelkasten/`)
**Audience:** Future you
**Purpose:** Capture learning and insights
**Lifetime:** Forever in your second brain
**Content:** Patterns, Principles, Insights, Questions

---

## The Documentation Flow

```
Feature Request
    ↓
[UNDERSTAND]
    ├→ docs/ddr/analysis.md (team context)
    └→ zettel/fleeting/questions.md (your questions)
    ↓
[IMPLEMENT]
    ├→ Code + Tests
    └→ zettel/fleeting/discoveries.md (aha moments)
    ↓
[COMPLETE]
    ├→ docs/ddr/decision.md (final decision)
    └→ zettel/permanent/pattern.md (extracted principle)
    ↓
[FUTURE PROJECT]
    ├→ Check past DDRs (what worked before)
    └→ Check Zettelkasten (patterns to apply)
```

---

## Practical Workflows

### 🎯 Starting a New Feature

```bash
# 1. Create project DDR
mkdir -p docs/ddr
nvim docs/ddr/$(date +%Y-%m-%d)-feature-name.md
```

```markdown
# Decision: [Feature Name]

## Status
- Date: YYYY-MM-DD
- Status: 🔍 Analyzing | 🏗️ Implementing | ✅ Complete
- Personal Notes: [[zettelkasten/projects/feature-name]]

## Context
[What problem are we solving?]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Options Being Considered
[Will fill in as we explore...]
```

```bash
# 2. Create personal project note
nvim
<leader>zn  # New note
# Choose: projects/feature-name.md
```

```markdown
# Project: [Feature Name]

## Learning Goals
- [ ] Understand [technology/pattern]
- [ ] Master [technique]
- [ ] Answer: [question]

## Resources
- Project DDR: [[docs/ddr/YYYY-MM-DD-feature-name]]
- Similar past project: [[projects/previous-similar]]

## Questions
- Why does [X] work this way?
- What's the best pattern for [Y]?
- How do experts handle [Z]?

## Discoveries
[Will document as I learn...]
```

### 🐛 Debugging Session

**In the moment (fleeting note):**
```vim
<leader>zn
# Title: Bug - [Description]
# Symptom: [What's broken]
# Hypothesis: [What I think is wrong]
# Attempts: [What I'm trying]
```

**After fixing (project documentation):**
```bash
nvim docs/ddr/$(date +%Y-%m-%d)-bugfix-issue-123.md
```

```markdown
# Bugfix: [Issue #123]

## Problem
[What was broken]

## Root Cause
[Why it was broken]

## Solution
[How we fixed it]

## Prevention
[How to avoid this in future]

## Learning
See: ~/zettelkasten/permanent/debug-pattern-[name].md
```

**Extract the learning (permanent note):**
```vim
<leader>zn
# Choose: permanent/debug-pattern-name.md
```

```markdown
# Debug Pattern: [Name]

## Symptom Recognition
When you see: [these symptoms]
Think: [this might be the cause]

## Root Cause Pattern
This happens because: [underlying reason]

## Solution Pattern
Fix by: [approach]

## Prevention Pattern
Avoid by: [practice]

## Real Examples
- Fixed in: [[docs/ddr/2024-01-15-bugfix-issue-123]]
- Similar to: [[permanent/debug-pattern-other]]

## Principle
[One sentence insight about this class of bugs]
```

### 🏗️ Architecture Decision

**Project DDR:**
```markdown
# Decision: Architecture for [Component]

## Context
Building [what] for [purpose]

## Options Evaluated

### Option A: [Approach]
- Pros: [advantages]
- Cons: [disadvantages]
- Effort: [estimation]

### Option B: [Approach]
[...]

## Decision
We chose [Option X] because [reasoning]

## Consequences
- Good: [positive outcomes]
- Bad: [negative outcomes]
- Risks: [what could go wrong]

## Personal Learning
Deep dive: ~/zettelkasten/permanent/architecture-pattern-[name].md
```

**Personal Zettelkasten:**
```markdown
# Architecture Pattern: [Name]

## When to Use
- Context: [when this applies]
- Problem: [what it solves]
- Forces: [constraints to balance]

## How It Works
[Explanation in my own words]

## Why It Works
[Underlying principles]

## Trade-offs
- Gains: [what you get]
- Costs: [what you pay]

## My Experience
- Applied in: [[docs/ddr/2024-01-15-architecture-decision]]
- Worked well when: [context]
- Struggled when: [context]

## Related Patterns
- Alternative: [[permanent/pattern-alternative]]
- Combines with: [[permanent/pattern-complementary]]
- Evolution of: [[permanent/pattern-predecessor]]
```

---

## Quick Capture Commands

### During Coding
```vim
" Quick project note
:!echo "- [ ] Document decision about X" >> docs/ddr/TODO.md

" Quick personal capture
<leader>zn  # Fleeting note
# Title: Insight - [what you learned]
```

### End of Feature
```vim
" Update project DDR
:e docs/ddr/$(date +%Y-%m-%d)-feature.md

" Extract personal learning
<leader>zn  # Permanent note
# Title: Pattern - [what you discovered]
```

---

## The Power of Dual Documentation

### What Project DDRs Give You
- ✅ Team alignment
- ✅ Decision history
- ✅ Onboarding material
- ✅ Audit trail
- ✅ Architecture evolution

### What Zettelkasten Gives You
- ✅ Personal growth
- ✅ Pattern recognition
- ✅ Reusable knowledge
- ✅ Career portability
- ✅ Compound learning

### What Both Together Give You
- 🚀 **Contextual Knowledge**: Decisions + Learning
- 🚀 **Pattern Library**: Project-specific + Universal
- 🚀 **Fast Recall**: "We did this before" + "Here's how"
- 🚀 **Teaching Ability**: Show the what + Explain the why
- 🚀 **Career Asset**: Portfolio + Expertise

---

## Templates for Dual Documentation

### New Feature Template Set

**1. Project DDR** (`docs/ddr/feature.md`):
```markdown
# Decision: [Feature]
## Context
## Requirements
## Design
## Implementation Notes
## See Also
- Personal learning: ~/zettelkasten/projects/[feature]
```

**2. Personal Note** (`~/zettelkasten/projects/feature.md`):
```markdown
# Project: [Feature]
## What I'm Learning
## Challenges
## Insights
## Questions for Future
## See Also
- Project DDR: docs/ddr/[feature]
```

### Bug Fix Template Set

**1. Project Record** (`docs/ddr/bugfix.md`):
```markdown
# Bugfix: [Issue]
## Symptom
## Root Cause
## Fix
## Prevention
## Learning: ~/zettelkasten/permanent/debug-[pattern]
```

**2. Personal Pattern** (`~/zettelkasten/permanent/debug-pattern.md`):
```markdown
# Debug Pattern: [Name]
## Recognition
## Common Causes
## Fix Approach
## Prevention
## Examples: docs/ddr/[bugfix]
```

---

## Weekly Review Protocol

Every Friday, reconcile both systems:

```vim
" 1. Review project DDRs from the week
:!ls -la docs/ddr/*$(date +%Y-%m)*

" 2. Review personal notes from the week
<leader>zf
/this week

" 3. Extract patterns
" For each DDR, ask:
" - What principle did I learn?
" - What pattern emerged?
" - What question remains?

" 4. Create permanent notes
<leader>zn
# Convert learnings to permanent notes

" 5. Cross-link
" Add links between DDRs and Zettelkasten notes
```

---

## Advanced Techniques

### The Learning Loop
```
Project Work → DDR (what) → Question (why) → Research →
Zettel Note (understanding) → Permanent Note (principle) →
Next Project (application) → Validation → Refined Principle
```

### The Knowledge Ladder
1. **Project Specific** (DDR): "We used Redis for caching"
2. **Pattern Recognition** (Zettel): "Caching reduces database load"
3. **Principle Extraction** (Permanent): "Trade memory for speed"
4. **Universal Wisdom** (Insight): "All performance is about trade-offs"

### The Synthesis Practice
Weekly: Pick 3 DDRs and 3 Zettel notes
- Find unexpected connections
- Extract common principles
- Create new permanent note linking them

---

## Metrics for Success

### Daily
- [ ] Created/updated at least 1 DDR
- [ ] Captured at least 1 learning in Zettelkasten
- [ ] Linked project work to personal knowledge

### Weekly
- [ ] All significant decisions have DDRs
- [ ] All learnings extracted to permanent notes
- [ ] Cross-pollination between projects identified

### Monthly
- [ ] DDRs are helping team discussions
- [ ] Zettelkasten is accelerating problem-solving
- [ ] Patterns from multiple projects synthesized

---

## Your Competitive Advantage

Most developers document OR learn. You do both:

1. **Project DDRs** = Professional credibility
2. **Personal Zettelkasten** = Deep expertise
3. **Bidirectional Links** = Contextual wisdom
4. **Pattern Extraction** = Transferable skills
5. **Continuous Synthesis** = Compound growth

---

## The Daily Practice

### Morning
```vim
" Check yesterday's DDRs
:!ls -la docs/ddr/*$(date -d yesterday +%Y-%m-%d)*

" Review related Zettelkasten notes
<leader>zf
/yesterday's topics
```

### During Work
```vim
" Capture decision
:e docs/ddr/$(date +%Y-%m-%d)-decision.md

" Capture learning
<leader>zn  # Quick fleeting note
```

### Evening
```vim
" Update DDR with final decision
:e docs/ddr/today.md

" Extract learning to permanent note
<leader>zn  # Create permanent note

" Link both directions
" In DDR: See also: ~/zettelkasten/...
" In Zettel: Applied in: docs/ddr/...
```

---

## Remember

> "The code you write runs on computers.
> The documentation you write runs in minds.
> The knowledge you extract runs forever."

Every DDR makes your team smarter.
Every Zettel note makes YOU smarter.
Together, they make you irreplaceable.

**Start now:** Next feature, create both a DDR and a Zettel note.

---

*"Document the decision for the team. Capture the learning for yourself. Link them both for power."*