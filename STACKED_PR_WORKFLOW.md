# Stacked PR Workflow: Small, Focused, Frequent

## 🎯 Philosophy

**"Measure twice, cut once. Ship small, ship often."**

Every feature is broken into a stack of small, reviewable PRs. Each PR:
- **<200 lines** of meaningful change
- **Single responsibility** (one concept)
- **Independently testable**
- **Builds on previous** (stacked)
- **Merged quickly** (same day goal)

---

## 📊 The Stack Structure

```
main
 └── feature/auth/01-types          PR #1: Type definitions (50 lines)
      └── feature/auth/02-db        PR #2: Database schema (75 lines)
           └── feature/auth/03-api   PR #3: API endpoints (150 lines)
                └── feature/auth/04-ui PR #4: UI components (100 lines)
```

Each branch:
- Depends on the previous
- Can be reviewed independently
- Adds one logical piece
- Has its own tests

---

## ⚡ Quick Commands for Stacked PRs

### Starting a New Stack
```bash
# 1. Create base branch
git checkout -b feature/auth/01-types

# 2. Make focused changes (measure twice)
<leader>gF          # Research first
:TodoWrite          # Plan the stack
<leader>zn          # Document approach

# 3. Commit frequently (cut once)
git add -p          # Stage selectively
git commit -m "feat(auth): add user type definitions"

# 4. Push and create PR
git push -u origin feature/auth/01-types
gh pr create --title "feat(auth): 1/4 - Type definitions" \
  --body "Stack: Authentication
  This PR: Type definitions
  Next: Database schema

  Part of #epic-123"
```

### Creating Next Stack Layer
```bash
# 1. Branch from previous
git checkout -b feature/auth/02-db

# 2. Small, focused work
# ... make changes ...

# 3. Commit and push
git commit -m "feat(auth): add database schema"
git push -u origin feature/auth/02-db

# 4. Create dependent PR
gh pr create --base feature/auth/01-types \
  --title "feat(auth): 2/4 - Database schema" \
  --body "Stack: Authentication
  Depends on: #101
  This PR: Database schema
  Next: API endpoints"
```

---

## 🔄 Daily Stack Workflow

### Morning: Plan the Stack (15 min)
```vim
<leader>td          # Open TODO.md
```

Add stack plan:
```markdown
## Today's Stack: User Authentication
- [ ] PR 1: Type definitions [30 min]
  - User interface
  - Auth tokens
  - Response types
- [ ] PR 2: Database schema [45 min]
  - Users table
  - Sessions table
  - Migrations
- [ ] PR 3: API endpoints [1 hour]
  - POST /login
  - POST /logout
  - GET /me
- [ ] PR 4: Tests [45 min]
  - Unit tests
  - Integration tests
```

### Development: One PR at a Time

#### PR 1: Types (30 min)
```vim
" 1. Investigate first
<leader>gF          # Search: "User type" or "interface User"

" 2. Create branch
:!git checkout -b feature/auth/01-types

" 3. Write test first
:e tests/types.test.ts
" ... write type tests ...

" 4. Implement types
:e src/types/auth.ts
" ... implement ...

" 5. Commit frequently
<leader>gg          # Stage and commit
" Message: "feat(auth): add User interface"

" 6. Create PR immediately
:!gh pr create
```

#### PR 2: Build on PR 1
```vim
" 1. Branch from PR 1
:!git checkout -b feature/auth/02-db

" 2. Small focused changes
" ... implement schema ...

" 3. Create dependent PR
:!gh pr create --base feature/auth/01-types
```

### Evening: Merge and Rebase

```bash
# When PR 1 is approved
gh pr merge 1 --squash

# Rebase PR 2 onto main
git checkout feature/auth/02-db
git rebase main

# Update PR 2
git push --force-with-lease
gh pr edit 2 --base main
```

---

## 📏 Size Guidelines

### ✅ Good PR Size (Merge Today)
- **Type definitions**: 20-50 lines
- **Single function**: 30-80 lines
- **Database migration**: 50-100 lines
- **One API endpoint**: 80-150 lines
- **Component + test**: 100-200 lines

### ⚠️ Too Large (Split It)
- Multiple features
- >200 lines of logic
- >5 files changed
- Mixed concerns
- "Refactor + feature"

### 🎯 The 2-Hour Rule
If a PR takes >2 hours, it's too big. Split it.

---

## 🏗️ Stack Planning Template

### In TODO.md
```markdown
## Stack: [Feature Name]
Total Estimate: [X hours]
PRs: [number]

### Planning
- [ ] Break into <200 line PRs
- [ ] Define dependencies
- [ ] Identify test points

### Stack Layers
1. [ ] **PR #1**: [Description] [30 min]
   - Git branch: `feature/name/01-desc`
   - Changes: [specific files]
   - Tests: [what to test]

2. [ ] **PR #2**: [Description] [45 min]
   - Git branch: `feature/name/02-desc`
   - Depends on: PR #1
   - Changes: [specific files]
   - Tests: [what to test]

3. [ ] **PR #3**: [Description] [30 min]
   - Git branch: `feature/name/03-desc`
   - Depends on: PR #2
   - Changes: [specific files]
   - Tests: [what to test]
```

---

## 🎯 Branch Naming Convention

```
feature/[stack]/[order]-[description]
```

Examples:
```
feature/auth/01-types
feature/auth/02-database
feature/auth/03-api
feature/auth/04-ui
feature/auth/05-tests

bugfix/payment/01-validation
bugfix/payment/02-error-handling

refactor/users/01-extract-service
refactor/users/02-update-callers
refactor/users/03-remove-legacy
```

---

## 📝 Commit Message Format

Each commit in a stack:
```
<type>(<scope>): <subject>

Stack: <stack-name>
Layer: <X/Y>
Depends: <PR number or "none">

<body>
```

Example:
```
feat(auth): add user type definitions

Stack: authentication
Layer: 1/4
Depends: none

- Added User interface
- Added AuthToken type
- Added LoginResponse type
```

---

## 🔧 Git Aliases for Stacks

Add to your git config:
```bash
# Create stack branch
git config --global alias.stack '!f() { git checkout -b feature/$1/01-$2; }; f'

# Create next layer
git config --global alias.layer '!f() {
  current=$(git branch --show-current)
  base=$(echo $current | sed "s/[0-9][0-9]-.*//")
  num=$(echo $current | grep -o "[0-9][0-9]" | sed "s/^0//")
  next=$(printf "%02d" $((num + 1)))
  git checkout -b ${base}${next}-$1
}; f'

# Show stack
git config --global alias.show-stack '!f() {
  base=$(git branch --show-current | sed "s/[0-9][0-9]-.*//")
  git branch | grep $base | sort
}; f'
```

Usage:
```bash
git stack auth types        # Creates feature/auth/01-types
git layer database          # Creates feature/auth/02-database
git show-stack              # Shows all branches in current stack
```

---

## 🚀 PR Creation Template

```markdown
## 🎯 Stack: [Feature Name]

**This PR**: [X/Y] - [Specific change]
**Size**: [XX lines]
**Time**: [XX minutes]

### Dependencies
- Depends on: #[PR] (or "none")
- Blocks: #[PR] (or "none")

### Changes
- [ ] Added [specific thing]
- [ ] Updated [specific thing]
- [ ] Tested [specific thing]

### Testing
```bash
# How to test this PR
npm test -- auth.types
```

### Review Focus
- [ ] Type safety
- [ ] Edge cases
- [ ] Naming conventions

### Stack Progress
- [x] PR 1: Types (#101) ✅
- [→] PR 2: Database (This PR)
- [ ] PR 3: API
- [ ] PR 4: UI
```

---

## 📊 Stack Metrics

Track in TODO.md:
```markdown
## Stack Metrics

### Current Week
- Stacks completed: 2/3
- PRs merged: 8/12
- Average PR size: 125 lines
- Average review time: 2 hours
- Rollback needed: 0

### Success Criteria
- [ ] All PRs <200 lines
- [ ] Review within 4 hours
- [ ] Merge within 8 hours
- [ ] Zero rollbacks
```

---

## 🎮 The Stack Game

### Level 1: Single Layer
- Create 1 PR <100 lines
- Merge same day

### Level 2: Two Layer Stack
- Create 2 dependent PRs
- Each <150 lines
- Both merged in 24 hours

### Level 3: Full Stack
- 4+ PR stack
- Each reviewed in <2 hours
- Full stack merged in 2 days

### Level 4: Parallel Stacks
- 2+ stacks in progress
- No merge conflicts
- All PRs <200 lines

---

## ⚡ Quick Wins

### The 50-Line PR
Start with tiny PRs:
- Add one type definition
- Fix one bug
- Add one test
- Update one doc

**Goal**: Merge within 1 hour of creation

### The 3-PR Day
Morning, noon, evening:
1. **9am**: Types/interfaces PR
2. **12pm**: Implementation PR
3. **3pm**: Tests PR

All reviewed and merged by EOD.

---

## 🚨 Anti-Patterns to Avoid

### ❌ The Monster PR
- 1000+ lines
- "Feature complete"
- 20+ files
- Mixed concerns
- 3-day review

### ❌ The Broken Stack
- PRs don't build on each other
- Merge conflicts between layers
- Circular dependencies
- Out of order merging

### ❌ The Endless Stack
- 10+ PRs in one stack
- Week-long implementation
- Scope creep
- Never completes

---

## ✅ Stack Checklist

### Before Starting
- [ ] Feature broken into <2 hour chunks
- [ ] Dependencies identified
- [ ] Branch naming planned
- [ ] Tests planned per layer

### Per PR
- [ ] <200 lines
- [ ] Single concept
- [ ] Tests pass
- [ ] No unrelated changes
- [ ] Clear commit message

### Before Merging
- [ ] Reviews complete
- [ ] CI passes
- [ ] Dependencies merged
- [ ] Rebase if needed

---

## 🔄 Integration with Workflow

### With Git Archaeology
```vim
<leader>gF          # Search for similar stacks
<leader>gfa         # Who created good stacks?
<leader>gfm         # Search: "stack" in commits
```

### With Todo System
```markdown
## Today's Stacks
- [ ] Auth stack (4 PRs)
  - [x] PR 1: Types
  - [ ] PR 2: Database
  - [ ] PR 3: API
  - [ ] PR 4: Tests
```

### With Daily Notes
```markdown
## Stacks Completed
- Auth stack: PRs #101-104
- Payment fix: PRs #105-106

## Tomorrow's Stack
- User profile: Plan 3 PRs
```

---

## 🎯 The Prime Directive

> **"Every PR should be reviewable in one coffee break."**

If someone can't review your PR in 15 minutes, it's too big.

---

## 📈 Benefits

1. **Faster Reviews**: Small PRs = quick reviews
2. **Less Risk**: Small changes = small problems
3. **More Frequent Wins**: Multiple merges daily
4. **Better Collaboration**: Others can build on your work
5. **Cleaner History**: Logical, traceable commits

---

## 🚀 Start Your First Stack

Right now:
```bash
# 1. Pick your smallest task
<leader>td          # Open TODO.md

# 2. Break it into 3 PRs
:TodoWrite          # Plan the stack

# 3. Create first branch
git checkout -b feature/task/01-setup

# 4. Make ONE small change
# Add ONE file, ONE function, or ONE test

# 5. Commit and PR
git add -p
git commit -m "feat(task): add initial setup"
gh pr create

# You've started your first stack!
```

---

**Remember**: The best PR is the one that gets merged today.

*Measure twice (plan the stack), cut once (focused PRs), ship often.*