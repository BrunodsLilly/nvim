# The Development Algorithm: A Systematic Approach to Excellence

## Core Philosophy
**"Think deeply, test first, commit often, refactor ruthlessly"**

This algorithm transforms you from a coder into a craftsman by establishing repeatable, measurable practices that compound over time. Every feature you build strengthens your skills through deliberate practice.

---

## The Algorithm: 7-Stage Development Cycle

### Stage 0: UNDERSTAND (Requirements & Design)
**Time: 20-30% of total effort**
*"Measure twice, cut once"*

```bash
# Commands
<leader>gg  # Check git status/branch
<leader>m   # Review any messages/errors
:Trouble    # Check existing issues
```

1. **Clarify Requirements**
   - [ ] Can I explain this feature to a 5-year-old?
   - [ ] Have I identified all edge cases?
   - [ ] Do I understand the "why" not just the "what"?

2. **Git Archaeology: Learn from History** 🆕
   *"The best documentation is the git history"*

   **When to use Git Investigation:**
   - Bug hunting: Why does this break?
   - Feature understanding: How was this built?
   - Learning patterns: How do experts solve this?
   - Code archaeology: Why was this decision made?

   ```vim
   # Quick Investigation Commands
   <leader>gB          # Show full blame for current line
   <leader>gl          # Git log for context
   <leader>gf <word>   # Find when code was added/removed (pickaxe)
   <leader>gbi         # Interactive git bisect (find bug)
   <leader>gF          # Follow file through renames
   ```

   **Git Investigation Checklist:**
   - [ ] When was this code last changed? (`git blame`)
   - [ ] Why was it changed? (Read commit message)
   - [ ] What else changed in that commit? (`git show <sha>`)
   - [ ] Who wrote it originally? (Check author)
   - [ ] Has this pattern been used elsewhere? (`git log -S "pattern"`)
   - [ ] When did this bug get introduced? (`git bisect`)

   **Capture Learning:**
   ```vim
   <leader>zg  # Create "Git Discovery" note
   ```

   Template:
   ```markdown
   # Git Discovery: [What You Found]

   ## Investigation Question
   Why does [problem] occur?

   ## Git Commands Used
   - `git log -S "search term"`
   - `git blame file.js:42`
   - `git show abc123`

   ## Discovery
   The code was introduced in commit abc123 by Author Name
   Commit message: "feat: add feature"
   Date: 2024-06-15

   ## Root Cause
   The issue stems from [explanation]

   ## Pattern Learned
   [[permanent/pattern-name]] - Extract to permanent note

   ## Related
   - Similar issue: [[permanent/debugging-pattern]]
   - Design decision: [[docs/ddr/YYYY-MM-DD]]
   ```

3. **AI-Assisted Analysis** (Claude in ToggleTerm)
   ```markdown
   PROMPT: "I need to implement [feature]. Help me think through:
   1. Core requirements and edge cases
   2. Potential design patterns
   3. Testing strategy
   4. Performance considerations
   What questions should I be asking?"
   ```

4. **Dual Documentation Strategy** 🆕

   **A. Project DDR (Team Knowledge)**
   Create `docs/ddr/YYYY-MM-DD-feature-name.md`:
   ```markdown
   # Decision: [Feature Name]

   ## Context
   What problem are we solving?

   ## Options Considered
   1. Option A: [description]
      - Pros:
      - Cons:

   ## Decision
   We will use [chosen approach] because...

   ## Consequences
   - Positive:
   - Negative:
   - Technical debt:

   ## Related Notes
   Personal Learning: [[zettelkasten/projects/feature-name]]
   ```

   **B. Personal Zettelkasten (Your Knowledge)**
   Create `~/zettelkasten/projects/feature-name.md`:
   ```markdown
   # Project: [Feature Name]

   ## What I'm Learning
   - New pattern: [[permanent/pattern-name]]
   - Technology deep dive: [[literature/tech-name]]
   - Problem-solving approach: [[permanent/approach]]

   ## Questions This Raises
   - Why does X work this way?
   - What's the underlying principle?

   ## Insights for Future
   - This pattern could apply to...
   - Better approach might be...

   ## Links
   - Project DDR: file:///path/to/docs/ddr/YYYY-MM-DD-feature.md
   - Related learning: [[daily/YYYY-MM-DD]]
   ```

5. **Create Work Breakdown**
   ```vim
   :TodoWrite
   ```
   - Break feature into <2 hour tasks
   - Each task should be independently testable
   - Order by dependencies

### Stage 1: SETUP (Branch & Environment)
**Time: 5 minutes**

```bash
# Git ceremony
git status                          # Where am I?
git checkout main && git pull       # Start fresh
git checkout -b feature/short-name  # New branch

# Neovim ceremony
<leader>qs                          # Restore session
:Mason                              # Check LSPs are ready
<leader>gg                          # LazyGit - review branch
```

**Branch Naming Convention:**
- `feature/` - New functionality
- `fix/` - Bug fixes
- `refactor/` - Code improvements
- `test/` - Test additions/improvements
- `docs/` - Documentation only

### Stage 2: TEST-FIRST (Red Phase of TDD)
**Time: 15-20% of coding time**
*"If you can't test it, you don't understand it"*

1. **Write the Test Declaration**
   ```python
   def test_feature_handles_happy_path():
       """Test that [specific behavior] works correctly."""
       # Arrange

       # Act

       # Assert
       assert False, "Not implemented"
   ```

2. **AI-Assisted Test Generation**
   ```markdown
   PROMPT: "Given this interface:
   [paste interface/function signature]

   Generate comprehensive test cases covering:
   1. Happy path
   2. Edge cases
   3. Error conditions
   4. Performance boundaries"
   ```

3. **Run Test to Confirm Failure**
   ```bash
   # Python
   pytest path/to/test.py::test_name -xvs

   # JavaScript/TypeScript
   npm test -- --watch path/to/test

   # Go
   go test -run TestName -v
   ```

4. **Review Test Quality Checklist**
   - [ ] Test name describes behavior, not implementation
   - [ ] Test has single assertion (or tightly related group)
   - [ ] Test is independent (no order dependencies)
   - [ ] Test is deterministic (no random/time dependencies)
   - [ ] Test documents the API by example

### Stage 3: IMPLEMENT (Green Phase of TDD)
**Time: 40-50% of coding time**
*"Make it work, then make it beautiful"*

1. **Minimal Implementation**
   ```vim
   gd          # Go to definition
   <leader>ca  # Code actions
   K           # Hover docs
   ```

   Write ONLY enough code to pass the test:
   - No premature optimization
   - No premature abstraction
   - No "while I'm here" additions

2. **AI-Assisted Coding**
   ```markdown
   PROMPT: "I have this failing test:
   [paste test]

   Provide the MINIMAL implementation to make it pass.
   Avoid over-engineering."
   ```

3. **Continuous Validation**
   ```bash
   # Run test in watch mode (another ToggleTerm tab)
   pytest-watch path/to/test.py

   # Or manually after each save
   :w | !pytest %:p:h/test_%:t:r.py -xvs
   ```

4. **Type Safety & Linting**
   ```vim
   <leader>cf  # Format and organize imports
   ]d          # Next diagnostic
   [d          # Previous diagnostic
   :Trouble    # View all diagnostics
   ```

### Stage 4: REFACTOR (Refactor Phase of TDD)
**Time: 20-30% of coding time**
*"Now make it beautiful"*

1. **Code Smells Checklist**
   - [ ] No duplicated code (DRY)
   - [ ] Functions < 20 lines
   - [ ] Cyclomatic complexity < 5
   - [ ] Clear variable names
   - [ ] No magic numbers/strings
   - [ ] Proper error handling

2. **AI-Assisted Refactoring**
   ```markdown
   PROMPT: "Review this code for:
   1. SOLID principles violations
   2. Performance improvements
   3. Readability enhancements
   4. Potential bugs

   [paste code]

   Suggest specific refactorings with explanations."
   ```

3. **Refactoring Commands**
   ```vim
   <leader>rn  # Rename symbol
   gr          # Find references
   <leader>ca  # Code actions (extract method, etc.)
   ```

4. **Continuous Testing During Refactor**
   ```bash
   # Keep test runner active
   # Every refactor should keep tests green
   # If test fails, immediately undo (git checkout -- .)
   ```

### Stage 4.5: STACK & PR 🆕
**Time: 10-15 minutes per PR**
*"Ship small, ship often. Every PR should be reviewable in one coffee break."*

**The Stacked PR Philosophy:**
- Each PR <200 lines
- Single responsibility
- Independently reviewable
- Builds on previous work

1. **Plan Your Stack**
   ```markdown
   Feature: User Authentication
   Stack Plan:
   - PR 1: Type definitions (50 lines)
   - PR 2: Database schema (75 lines)
   - PR 3: API endpoints (150 lines)
   - PR 4: UI components (100 lines)
   ```

2. **Create Small PR**
   ```bash
   # Branch naming: feature/stack/01-description
   git checkout -b feature/auth/01-types

   # Make focused changes (<200 lines)
   # Add ONE thing: one file, one function, one test

   # Commit frequently
   git add -p  # Stage selectively
   git commit -m "feat(auth): add user type definitions"

   # Push and create PR immediately
   git push -u origin feature/auth/01-types
   gh pr create --title "feat(auth): 1/4 - Type definitions"
   ```

3. **Stack Next Layer**
   ```bash
   # Branch from previous PR
   git checkout -b feature/auth/02-database

   # Small focused changes
   # Create dependent PR
   gh pr create --base feature/auth/01-types
   ```

4. **PR Checklist**
   - [ ] <200 lines of meaningful change
   - [ ] Single concept/responsibility
   - [ ] Tests included
   - [ ] Can be reviewed in 15 minutes
   - [ ] Clear dependency chain

See `STACKED_PR_WORKFLOW.md` for complete guide.

### Stage 5: COMMIT (Atomic & Meaningful)
**Time: 5-10 minutes**
*"Commit early, commit often, commit atomically"*

1. **Pre-Commit Review**
   ```bash
   git diff            # What changed?
   git diff --cached   # What's staged?
   npm test           # All tests pass?
   npm run lint       # No lint errors?
   ```

2. **Atomic Commit Rules**
   - One logical change per commit
   - All tests must pass
   - No commented-out code
   - No debug prints

3. **Commit Message Template**
   ```
   type(scope): imperative description

   - Detail what changed and why
   - Reference issue numbers
   - Note breaking changes

   Fixes #123
   ```

   Types: feat, fix, test, refactor, docs, style, perf, chore

4. **Git Commands in Neovim**
   ```vim
   <leader>gg  # LazyGit for staging
   :Git commit # Or use LazyGit
   ```

5. **AI-Assisted Commit Messages**
   ```markdown
   PROMPT: "Generate a conventional commit message for:

   git diff:
   [paste diff]

   Context: [brief description]"
   ```

### Stage 6: INTEGRATE (Pull Request & Review)
**Time: 15-20 minutes**
*"Code review is a conversation, not a judgment"*

1. **Self-Review First**
   ```bash
   # Push branch
   git push -u origin feature/name

   # Create PR via gh CLI
   gh pr create --title "feat: description" \
                --body "## What\n\n## Why\n\n## How\n\n## Testing"
   ```

2. **PR Description Template**
   ```markdown
   ## What
   Brief description of changes

   ## Why
   Problem being solved / Feature being added
   Link to issue: #XXX

   ## How
   Technical approach taken
   Key design decisions

   ## Testing
   - [ ] Unit tests added/updated
   - [ ] Manual testing completed
   - [ ] Performance impact assessed

   ## Screenshots (if UI changes)
   Before | After

   ## Checklist
   - [ ] Tests pass locally
   - [ ] No console.logs or debug code
   - [ ] Documentation updated
   - [ ] Follows team style guide
   ```

3. **AI-Assisted PR Review Prep**
   ```markdown
   PROMPT: "Review this PR for:
   1. Potential bugs
   2. Security issues
   3. Performance problems
   4. Missing test cases

   [paste diff or provide file paths]"
   ```

4. **Responding to Review Comments**
   - Thank reviewer for feedback
   - Address each comment with commit
   - Re-request review after changes

### Stage 7: LEARN (Retrospective & Documentation)
**Time: 10-15 minutes**
*"Every bug is a missing test, every confusion is missing documentation"*

1. **Dual Documentation Update** 🆕

   **A. Project Documentation (Team Knowledge)**
   ```bash
   # Update relevant docs
   docs/api/         # API changes
   docs/ddr/         # Design decisions
   README.md         # Setup/usage changes
   CHANGELOG.md      # User-facing changes
   ```

   **B. Personal Knowledge Extraction (Your Growth)**
   ```vim
   # Extract learnings to Zettelkasten
   <leader>zn  # New permanent note from insights
   ```

   Convert project learnings:
   - **Bug → Debugging Pattern**: `permanent/debug-pattern-[issue].md`
   - **Design Decision → Principle**: `permanent/principle-[concept].md`
   - **Refactoring → Code Pattern**: `permanent/pattern-[name].md`
   - **Performance Fix → Optimization**: `permanent/optimization-[technique].md`

2. **Knowledge Synthesis Workflow** 🆕
   ```markdown
   # In your daily note (<leader>zd)
   ## Today's Knowledge Harvest

   ### From Project: [Project Name]
   - DDR Created: [[docs/ddr/YYYY-MM-DD-feature]]
   - Pattern Discovered: [[permanent/pattern-name]]
   - Principle Learned: [[permanent/principle-name]]

   ### Questions Answered
   - Q: [What I didn't understand]
   - A: [What I learned] → [[permanent/insight]]

   ### Questions Raised
   - [ ] [New question for tomorrow]

   ### Connections Made
   - This relates to: [[permanent/previous-learning]]
   - This contradicts: [[permanent/old-assumption]]
   - This enhances: [[permanent/existing-pattern]]
   ```

3. **Cross-Pollination Protocol** 🆕

   After each feature/fix:
   1. **Update Project DDR** with decision
   2. **Create Zettel Note** with learning
   3. **Link Bidirectionally**:
      - DDR → "See also: Personal notes at ~/zettelkasten/..."
      - Zettel → "Applied in: Project DDR at docs/ddr/..."
   4. **Extract Principle** if pattern emerges
   5. **Share with Team** if universally valuable

4. **Metrics to Track** (Enhanced)
   - Tests written before code: ____%
   - Commits per day: ____
   - PRs merged without rework: ____%
   - Bugs found in production: ____
   - Time estimate accuracy: ____%
   - **DDRs created**: ____ 🆕
   - **Permanent notes extracted**: ____ 🆕
   - **Patterns documented**: ____ 🆕

---

## AI Integration Patterns

### 1. The Rubber Duck++
Before asking AI, explain your problem out loud:
```markdown
I'm trying to: [goal]
I've attempted: [what you tried]
It's failing because: [error/behavior]
I think the issue might be: [hypothesis]
```
THEN ask AI for validation/alternatives

### 2. The Socratic Method
Don't ask for solutions, ask for questions:
```markdown
"I'm implementing [feature]. What questions should I be asking myself about:
- Security
- Performance
- Maintainability
- Testing
- Edge cases"
```

### 3. The Code Review Partner
After implementing, before committing:
```markdown
"Review this code as a senior engineer:
[paste code]

Focus on:
1. Bugs and edge cases
2. Performance issues
3. Security vulnerabilities
4. Code smells
5. Missing tests"
```

### 4. The Learning Accelerator
After solving a problem:
```markdown
"I solved [problem] using [solution].
1. What pattern did I just use?
2. When is this pattern appropriate/inappropriate?
3. What are alternative approaches?
4. How would an expert improve this?"
```

---

## Daily Practices

### Morning Routine (15 minutes)
```bash
# 1. Check yesterday's metrics
cat ~/development-journal/$(date -d yesterday +%Y-%m-%d).md

# 2. Review today's goals
<leader>gg  # Check git status
:TodoWrite  # Review/update todos
:Trouble    # Check diagnostics

# 3. Update dependencies
:Lazy sync
:Mason
npm update # or equivalent

# 4. Set intention
echo "Today I will focus on: [one thing]"
```

### Context Switching Protocol
When switching tasks:
```bash
# 1. Commit WIP
git add -A
git commit -m "WIP: [current state]"

# 2. Document state
:TodoWrite  # Update task status

# 3. Save session
<leader>qd  # Don't save session (if changing projects)
```

### End of Day Routine (15 minutes)
```bash
# 1. Commit all work
git add -A
git commit -m "EOD: [summary]"

# 2. Push to remote
git push

# 3. Update journal
nvim ~/development-journal/$(date +%Y-%m-%d).md

# 4. Plan tomorrow
:TodoWrite  # Set tomorrow's priorities
```

---

## Skill Progression Levels

### Level 1: Disciplined (Months 1-3)
- [ ] Write test first 50% of the time
- [ ] Commit daily
- [ ] Use AI for rubber ducking
- [ ] Track time estimates

### Level 2: Consistent (Months 4-6)
- [ ] Write test first 80% of the time
- [ ] Atomic commits only
- [ ] Use AI for code review
- [ ] Estimates within 25% accuracy

### Level 3: Fluent (Months 7-12)
- [ ] TDD is natural default
- [ ] Commits tell a story
- [ ] AI augments thinking, doesn't replace it
- [ ] Mentor others in the algorithm

### Level 4: Master (Year 2+)
- [ ] Identify patterns across projects
- [ ] Contribute to open source
- [ ] Create team standards
- [ ] Innovation within discipline

---

## Anti-Patterns to Avoid

### 1. The "Quick Fix" Trap
❌ "I'll just fix this without a test"
✅ "Every fix needs a test to prevent regression"

### 2. The "Big Bang" Commit
❌ 500+ line commits with "stuff"
✅ Small, atomic commits with clear purpose

### 3. The "AI Crutch"
❌ Copy-paste AI solutions without understanding
✅ Use AI to enhance understanding, not replace it

### 4. The "Perfection Paralysis"
❌ Endless refactoring without shipping
✅ Ship working code, iterate based on feedback

### 5. The "Solo Hero"
❌ Working in isolation for days
✅ Daily commits, regular PR submissions

---

## Weekly Retrospective Template

Every Friday, answer:

1. **Wins**
   - What went better than expected?
   - Which practices helped most?

2. **Struggles**
   - Where did I deviate from the algorithm?
   - What caused the deviation?

3. **Lessons**
   - What would I do differently?
   - What new pattern did I discover?

4. **Commitments**
   - One practice to focus on next week
   - One skill to deliberately practice

5. **Metrics Review**
   - TDD compliance: ____%
   - Commit frequency: ____ per day
   - PR turnaround: ____ hours
   - Test coverage: ____%
   - Bug escape rate: ____

---

## The Path to Mastery

### Month 1-2: Foundation
Focus: Discipline over speed
- Master the 7-stage cycle
- Build TDD muscle memory
- Establish daily routines

### Month 3-4: Refinement
Focus: Quality over quantity
- Improve test design
- Better commit messages
- Faster refactoring

### Month 5-6: Acceleration
Focus: Speed with quality
- Reduce cycle time
- Improve estimation
- Pattern recognition

### Month 7-12: Excellence
Focus: Teaching and innovation
- Mentor others
- Create team tools
- Contribute upstream

---

## Personal Mastery Checklist

### Daily Habits
- [ ] First test before first line of code
- [ ] Commit within 2 hours of starting
- [ ] One learning journal entry
- [ ] Review one other's PR

### Weekly Habits
- [ ] Retrospective completed
- [ ] Metrics reviewed
- [ ] One refactoring session
- [ ] One learning investment (article/video)

### Monthly Habits
- [ ] Review and refine this algorithm
- [ ] Share learning with team
- [ ] Contribute to documentation
- [ ] Profile and optimize something

---

## Your Configuration Advantages

You have exceptional tooling. Use it:

1. **Neovim Discipline**
   - `<leader>cf` after EVERY file save
   - `:Trouble` before EVERY commit
   - `<leader>gg` for git visualization

2. **AI Augmentation**
   - Claude in ToggleTerm for pair programming
   - Separate terminal for test watching
   - AI for documentation generation

3. **Testing Power**
   - DAP for debugging (`<leader>db`)
   - pytest-watch for continuous testing
   - Coverage visualization

4. **Git Mastery**
   - LazyGit for visual git (`<leader>gg`)
   - Diffview for code review (`<leader>gd`)
   - Gitsigns for inline changes

---

## The Prime Directive

**"Every line of code is a liability, every test is an asset"**

Write less code that does more, backed by comprehensive tests. Use AI to think deeper, not to avoid thinking. Commit your learning, not just your code.

---

## Next Steps

1. **Print this algorithm** and keep it visible
2. **Start tomorrow** with Stage 0 on your next task
3. **Track metrics** for one week
4. **Share struggles** and wins in your journal
5. **Refine the algorithm** based on what works for YOU

Remember: Discipline equals freedom. The more you follow the algorithm, the faster and more creative you become within its structure.

---

*Last Updated: 2024*
*Version: 1.0*
*Your Journey Starts Now*