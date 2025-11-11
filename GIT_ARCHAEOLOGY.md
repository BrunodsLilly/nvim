# Git Archaeology: Investigation & Discovery Guide

Master git history investigation for bug hunting, learning from experts, and understanding code evolution.

---

## Philosophy

**"The git history is your time machine. Every bug leaves traces, every expert leaves lessons."**

Git isn't just version control—it's a knowledge base containing:
- **Why** decisions were made (commit messages)
- **When** bugs were introduced (bisect)
- **How** experts solve problems (code patterns)
- **Who** understands specific areas (contributors)

---

## Quick Reference: Investigation Keymaps

### Basic Investigation
| Key | Command | Use Case |
|-----|---------|----------|
| `<leader>gb` | Toggle inline blame | "Who wrote this line?" |
| `<leader>gB` | Show full blame | "Why was this changed?" |
| `<leader>gl` | Git log | "What's the recent history?" |
| `<leader>gD` | Git diff split | "What changed?" |

### Advanced Investigation (`<leader>gf` prefix = "git find")
| Key | Command | Use Case |
|-----|---------|----------|
| `<leader>gF` | **Pickaxe search** | "When was this code added/removed?" |
| `<leader>gfF` | Follow file history | "Track file through renames" |
| `<leader>gfm` | Search commit messages | "Find bug fix commits" |
| `<leader>gft` | Commits since date | "What changed this week?" |
| `<leader>gfr` | Blame visual selection | "Who changed these lines?" |
| `<leader>gfh` | Show file at commit | "What did this look like before?" |
| `<leader>gbi` | Interactive bisect | "Which commit broke this?" |
| `<leader>gfa` | File contributors | "Who knows this code best?" |
| `<leader>gfR` | Git reflog | "What happened recently?" |
| `<leader>gfM` | Compare with main | "What's new on this branch?" |

---

## Investigation Workflows

### Workflow 1: Bug Discovery - "When Did This Break?"

**Scenario**: Feature X worked last week, now it's broken.

```vim
" Step 1: Find the exact code that's failing
" Put cursor on problematic line
<leader>gB           " Show full blame - when was this last changed?

" Step 2: Search for related changes
<leader>gF           " Pickaxe: Search for function name or key code
" Enter: "functionName" or key pattern

" Step 3: Use git bisect to find the breaking commit
<leader>gbi          " Start bisect
" Enter: start
" Bad commit: HEAD (current, broken)
" Good commit: HEAD~20 (or tag like v1.2.0)

" Step 4: Test the code
" Run your test suite
" If bug exists: <leader>gbi → "bad"
" If bug absent: <leader>gbi → "good"

" Repeat until git finds the exact commit

" Step 5: Examine the breaking commit
" Git bisect will show the commit SHA
:Git show <sha>      " See full diff
<leader>gbo          " Open commit in browser for PR/discussion context
```

**Capture your discovery:**
```vim
<leader>zg           " Create git discovery note
```

---

### Workflow 2: Understanding Unfamiliar Code

**Scenario**: You inherit a complex codebase and need to understand a module.

```vim
" Step 1: Open the file you want to understand
:e path/to/complex-file.js

" Step 2: See inline context for every line
<leader>gb           " Enable inline blame (if not already on)
" Now you see: Author, Date, Commit message on each line

" Step 3: Find the experts
<leader>gfa          " Show contributors sorted by commits
" Identify who wrote most of this file

" Step 4: Understand the evolution
<leader>gfF          " Follow file through renames/moves
" See complete history even if file was refactored

" Step 5: Deep dive on specific sections
" Visual select confusing lines (V + j/k)
<leader>gfr          " Blame just those lines
" Read commit messages for each change

" Step 6: See what else changed with each commit
" From blame, note the commit SHA
:Git show <sha>      " See full context of the commit
```

**Learning pattern:**
```vim
<leader>zn           " Create permanent note
# Title: "Pattern: [What You Learned]"
# Tag it: #learning #codebase #pattern
```

---

### Workflow 3: Learning from Experts

**Scenario**: You want to learn how senior engineers solve similar problems.

```vim
" Step 1: Find a well-written feature in your codebase
" Open a file you admire

" Step 2: Track its development
<leader>gfF          " Follow file history
" See: Original implementation → Refactorings → Improvements

" Step 3: Study the commit pattern
<leader>gl           " Full git log
" Look for patterns:
" - How were tests written?
" - How was code refactored?
" - What was the commit cadence?

" Step 4: Search for similar patterns elsewhere
<leader>gF           " Pickaxe: Search for pattern name
" Enter: "RepositoryPattern" or "FactoryMethod"
" See all implementations across the codebase

" Step 5: Compare approaches
<leader>gfh          " Show file at different commits
" Compare: Initial implementation vs. current state
```

**Extract principles:**
```vim
<leader>zn           " Create permanent note
# Title: "Principle: [Pattern Name]"
# Example from: commit abc123
# Applied in: [file path]
# Key insight: [what you learned]
```

---

### Workflow 4: Pre-Commit Investigation

**Scenario**: Before committing, understand if your change follows established patterns.

```vim
" Step 1: Check recent changes to similar files
<leader>gfm          " Search commit messages
" Enter: "add authentication" or "implement validation"

" Step 2: Study similar features
" From search results, note commit SHAs
:Git show <sha>      " Study how similar features were added

" Step 3: Check your changes match the pattern
<leader>gD           " Git diff split
" Compare your approach to established patterns

" Step 4: Verify no unintended changes
]h                   " Jump through each hunk
<leader>ghp          " Preview each change
" Ask: "Does this align with codebase conventions?"
```

---

### Workflow 5: Code Archaeology - "Why Does This Exist?"

**Scenario**: Weird code that doesn't make sense. "Why is this here?"

```vim
" Step 1: Find when it was added
<leader>gB           " Full blame on the strange code

" Step 2: Read the commit message
" Note the commit SHA from blame
:Git show <sha>      " Full commit details

" Step 3: Search for related context
<leader>gfm          " Search commit messages for keywords
" Look for: Bug numbers, feature names, related commits

" Step 4: Find related discussions
<leader>gbo          " Open commit in browser
" GitHub/GitLab will show:
" - PR description
" - Code review comments
" - Linked issues

" Step 5: Check if it's still needed
<leader>gF           " Pickaxe: Search for usages
" See if this code is referenced elsewhere
```

**Decision capture:**
```vim
" If you learn this code can be removed:
<leader>zn           " Create note
# Title: "Technical Debt: [Description]"
# Original reason: [from git history]
# Still needed? No because [reasoning]
# Can be removed in: [future milestone]
```

---

### Workflow 6: Security Investigation

**Scenario**: Security vulnerability disclosed. Find all related code.

```vim
" Step 1: Find when vulnerable code was introduced
<leader>gF           " Pickaxe: Search for vulnerable pattern
" Enter: "eval(" or "exec(" or "innerHTML"

" Step 2: Check all occurrences
" Git will show every commit that added/removed this pattern
" Review each occurrence for vulnerability

" Step 3: Find who to consult
<leader>gfa          " Show contributors
" Contact authors who introduced the code

" Step 4: Check for similar patterns
<leader>gfm          " Search commit messages
" Enter: "security" or "sanitize" or "escape"
" Find previous security fixes for pattern guidance

" Step 5: Verify fix coverage
" After applying fix:
<leader>gF           " Pickaxe: Verify pattern is gone
```

---

## Git Commands Explained

### The Pickaxe: `git log -S`

**Most powerful investigation tool**

```bash
# Find when "functionName" was added or removed
git log -S "functionName" -p --all

# Find when specific logic changed
git log -S "if (user.isAdmin)" --all
```

**In Neovim**: `<leader>gF` (cursor on word, or enter custom search)

**Use cases:**
- "When was this function introduced?"
- "When was this security check added?"
- "Who removed this feature?"

---

### Git Blame: `git blame`

**Find who changed each line and when**

```bash
# Blame entire file
git blame path/to/file.js

# Blame specific lines
git blame -L 42,56 path/to/file.js

# Blame with email and full commit SHA
git blame -e -l path/to/file.js
```

**In Neovim**:
- `<leader>gb` - Toggle inline blame
- `<leader>gB` - Full blame popup
- `<leader>gfr` - Blame visual selection (select lines first)

**Pro tips:**
- Look for patterns: Multiple changes by same person = expert
- Recent changes = potential bugs
- Old unchanged code = stable, critical code

---

### Git Bisect: Binary Search for Bugs

**Find exact commit that introduced a bug**

```bash
# Start bisect
git bisect start

# Mark current (broken) as bad
git bisect bad HEAD

# Mark last known good commit
git bisect good v1.2.0  # or commit SHA

# Test the code
# If broken: git bisect bad
# If works:  git bisect good

# Git checks out commits automatically
# Repeat until it finds the exact breaking commit

# When done
git bisect reset
```

**In Neovim**: `<leader>gbi` (interactive helper)

**Workflow**:
1. `<leader>gbi` → start → Enter bad/good commits
2. Test your code (run tests, try feature)
3. `<leader>gbi` → good/bad
4. Repeat until git finds the commit
5. `<leader>gbi` → reset when done

---

### Following Files: `git log --follow`

**Track file through renames and moves**

```bash
# Follow file history even through renames
git log --follow -p -- path/to/file.js

# See when file was renamed
git log --follow --name-status -- path/to/file.js
```

**In Neovim**: `<leader>gfF`

**Use case**: File was `OldName.js`, renamed to `NewName.js`, moved to `lib/NewName.js`. This shows complete history.

---

### Time-Based Investigation

```bash
# What changed in the last week?
git log --since="1 week ago" --oneline

# What changed in October?
git log --since="2024-10-01" --until="2024-10-31"

# Who committed in the last 3 days?
git log --since="3 days ago" --format="%an" | sort | uniq
```

**In Neovim**: `<leader>gft` (enter relative time)

---

### Commit Message Search

```bash
# Find commits about authentication
git log --grep="authentication" --oneline

# Find bug fix commits
git log --grep="fix" --grep="bug" --oneline

# Case-insensitive search
git log --grep="security" -i --oneline
```

**In Neovim**: `<leader>gfm` (enter search term)

---

## Investigation Patterns

### Pattern 1: The Detective

**Goal**: Find root cause of a bug

```markdown
1. Reproduce the bug (write failing test)
2. `<leader>gB` on buggy line → When last changed?
3. `<leader>gF` → Search for related code
4. `:Git show <sha>` → Examine full commit
5. `<leader>gbi` → Bisect if needed
6. Document: `<leader>zg` → Create git discovery note
```

### Pattern 2: The Apprentice

**Goal**: Learn from expert code

```markdown
1. Find excellent code example
2. `<leader>gfF` → Follow evolution
3. `<leader>gfa` → Identify expert authors
4. `<leader>gl` → Study commit history
5. Extract: `<leader>zn` → Create pattern note
```

### Pattern 3: The Archaeologist

**Goal**: Understand legacy code

```markdown
1. `<leader>gb` → Enable blame everywhere
2. Read commit messages as you read code
3. `<leader>gfh` → See previous versions
4. `<leader>gfm` → Search related commits
5. Document: `<leader>zn` → Create understanding note
```

### Pattern 4: The Auditor

**Goal**: Security/quality review

```markdown
1. `<leader>gF` → Search for dangerous patterns
2. `<leader>gft` → Recent changes only
3. `<leader>gfa` → Who to contact for questions
4. `<leader>gfM` → Compare with main branch
5. Document: Create DDR for findings
```

---

## Integration with Development Algorithm

### Stage 0: UNDERSTAND - Use Git to Learn

Before writing code:

```vim
" Understand existing patterns
<leader>gF           " Search for similar implementations
<leader>gfm          " Search commit history for context

" Find experts to consult
<leader>gfa          " Who knows this area?

" Document investigation
<leader>zg           " Git discovery note
```

### Stage 2: TEST-FIRST - Learn from Test History

```vim
" Open related test file
:e path/to/test.js

" Study test evolution
<leader>gfF          " How did tests evolve?
<leader>gF           " Search for test patterns

" Copy proven patterns
<leader>gfh          " See test at different commits
```

### Stage 5: COMMIT - Create Discoverable History

**Your commit creates future archaeology!**

Good commit messages help future investigators:

```
feat(auth): add JWT token validation

Why: Prevent unauthorized access to admin endpoints
How: Validate token signature and expiration
Context: Security audit finding #234

Tests added in auth.test.js
Documentation: docs/security.md

Refs: #234
```

Now future developers can:
- `git blame` → Understand why code exists
- `git log --grep="security"` → Find all security work
- `git show <sha>` → See full context

---

## Zettelkasten Integration

### Create Git Discovery Notes

```vim
<leader>zg           " New git discovery note
```

Template will include:

```markdown
---
title: "Git Discovery: [Finding]"
date: 2025-10-26
type: git-discovery
tags: [git, learning, debugging]
publish: false
---

# Git Discovery: [What You Found]

## Investigation Question
Why does [problem] occur? / How was [feature] built?

## Git Commands Used
- `git log -S "pattern"`
- `git blame file.js:42`
- `git show abc123`

## Discovery
The code was introduced in commit abc123 by Author Name
Commit message: "feat: add feature"
Date: 2024-06-15
Link: [GitHub PR](url)

## Root Cause / Insight
[Explanation of what you learned]

## Pattern Learned
This demonstrates the [[permanent/pattern-name]] pattern.

Key insight: [Core learning]

## Application
Can be applied to:
- Similar problem in [[project/other-feature]]
- Refactoring opportunity in [[permanent/tech-debt]]

## Related
- Bug report: [[permanent/bug-xyz]]
- Design decision: [[docs/ddr/YYYY-MM-DD]]
- Learning: [[daily/YYYY-MM-DD]]
```

### Extract Principles

After multiple git discoveries, extract patterns:

```vim
<leader>zn           " New permanent note
```

```markdown
---
title: "Pattern: Git Bisect for Regression Testing"
type: permanent-note
tags: [git, debugging, testing, pattern]
---

# Pattern: Git Bisect for Regression Testing

## Context
When a test that previously passed is now failing.

## The Pattern
Use git bisect with automated test runner:

git bisect start HEAD v1.0.0
git bisect run npm test

Git automatically finds the breaking commit.

## Why It Works
Binary search through commits (O(log n)) is faster than
linear search through all commits.

## When to Use
- Regression bugs (worked before, broken now)
- Performance degradation
- Flaky tests introduced recently

## Example
Discovered in: [[git-discovery/bug-auth-failure]]
Applied in: [[project/fix-login-bug]]

## Related Patterns
- [[permanent/test-driven-debugging]]
- [[permanent/failing-test-first]]
```

---

## Advanced Techniques

### Technique 1: Author-Specific Learning

**Learn from specific developers:**

```bash
# All commits by expert developer
git log --author="Jane Smith" --oneline

# Their recent work
git log --author="Jane" --since="1 month ago" -p

# Files they've touched
git log --author="Jane" --name-only
```

### Technique 2: Frequency Analysis

**Find hot spots (frequently changed code = potential problems):**

```bash
# Most frequently changed files
git log --format=format: --name-only | grep -v '^$' | sort | uniq -c | sort -rn | head -20

# Changes per file in last month
git log --since="1 month ago" --format=format: --name-only | grep -v '^$' | sort | uniq -c | sort -rn
```

### Technique 3: Coupling Analysis

**Find files that always change together:**

```bash
# Files changed together with auth.js
git log --format=format: --name-only -- auth.js | grep -v '^$' | grep -v 'auth.js' | sort | uniq -c | sort -rn
```

### Technique 4: Commit Pattern Analysis

**Study expert commit patterns:**

```bash
# Average commits per day
git log --author="Jane" --format="%ad" --date=short | uniq -c

# Commit message patterns
git log --author="Jane" --format="%s" | head -50

# Files per commit (atomic commits?)
git log --author="Jane" --shortstat | grep "files changed"
```

---

## Daily Git Investigation Practice

### Morning Routine (5 min)

```vim
" Review what changed overnight
<leader>gft          " Commits since "yesterday"

" Check who's active
<leader>gl           " Recent log

" Plan your learning
" Pick one commit: :Git show <sha>
" Study: Why was this change made?
```

### When Stuck (10 min)

```vim
" Before asking for help:
<leader>gF           " Has someone solved this before?
<leader>gfm          " Search for related commits
<leader>gfa          " Who's the expert on this file?

" Document what you tried
<leader>zg           " Git discovery note
```

### End of Day (5 min)

```vim
" Review your own commits
:Git log --since="today" --author="YourName"

" Reflect
<leader>zd           " Daily note
## Git Learning Today
- Discovered: [what you found]
- Learned from: [author/commit]
- Pattern: [[permanent/pattern]]
```

---

## Common Git Investigation Scenarios

### Scenario: "This Used to Work!"

```vim
1. Identify last known good version (git tag, or "2 weeks ago")
2. <leader>gbi → Start bisect
3. Binary search through commits
4. Find exact breaking commit
5. <leader>gbo → Open in browser for PR context
6. Document: <leader>zg → Git discovery note
```

### Scenario: "Why Is This Code So Weird?"

```vim
1. <leader>gB → Full blame
2. Read commit message (usually explains "why")
3. :Git show <sha> → See full context
4. <leader>gfm → Search for related context
5. Still confused? <leader>gfa → Contact the author
```

### Scenario: "Someone Fixed This Before"

```vim
1. <leader>gfm → Search: "fix" + keyword
2. Study fix commits: :Git show <sha>
3. Look for test additions (prevent regression)
4. Extract pattern: <leader>zn → Pattern note
5. Apply same pattern to your problem
```

### Scenario: "Is This Pattern Common?"

```vim
1. <leader>gF → Pickaxe search for pattern
2. Count occurrences in search results
3. Study different implementations
4. Find best implementation (recent, well-tested)
5. Document: <leader>zn → Pattern note
```

---

## Metrics to Track

### Weekly Git Archaeology Stats

Track in your weekly note:

```markdown
## Git Investigation This Week

**Discovery sessions**: 5
**Bugs found via bisect**: 2
**Patterns learned from history**: 3
**Expert developers identified**: 2
**Git discovery notes created**: 4

**Best discovery**:
Found that auth bug was introduced in commit abc123
when refactoring middleware. Author Jane Smith helped
me understand the edge case. Created pattern note for
future reference.

**Time saved**:
Instead of debugging for hours, git bisect found the
bug in 15 minutes. Studied Jane's commits to learn
proper middleware patterns.
```

---

## Resources & Further Learning

### Git Archaeology Tools

1. **GitLens** (VS Code) - Rich git integration
2. **tig** - Terminal git browser: `brew install tig`
3. **git-extras** - Extra git commands: `brew install git-extras`
4. **gh** - GitHub CLI: `brew install gh`

### Recommended Reading

- "Pro Git" book (free online): https://git-scm.com/book
- Git archaeology blog posts on commit archaeology
- Your own git history (best learning resource!)

---

## Quick Command Reference Card

```
GIT ARCHAEOLOGY COMMANDS:

BASIC:
  <leader>gb      Toggle inline blame
  <leader>gB      Show full blame
  <leader>gl      Git log
  <leader>gD      Git diff split

INVESTIGATION (<leader>gf prefix):
  <leader>gF      Pickaxe: Find code in history
  <leader>gfF     Follow file through renames
  <leader>gfm     Search commit messages
  <leader>gft     Commits since date
  <leader>gfr     Blame visual selection
  <leader>gfh     Show file at commit
  <leader>gbi     Interactive bisect
  <leader>gfa     File contributors
  <leader>gfR     Git reflog
  <leader>gfM     Compare with main

CAPTURE:
  <leader>zg      Git discovery note
  <leader>zn      Permanent pattern note

WORKFLOW:
  1. Investigate with git commands
  2. Understand root cause
  3. Extract learnings
  4. Document patterns
  5. Share with team
```

---

**Restart Neovim to load all git investigation commands!**

Your git history is now your greatest learning resource. 🔍

*"Every commit tells a story. Learn to read them."*
