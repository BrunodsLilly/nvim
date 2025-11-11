#!/bin/bash

# Setup Git Hooks for Development Algorithm Enforcement

echo "🔧 Setting up Git hooks for Development Algorithm..."

# Create hooks directory if it doesn't exist
HOOKS_DIR=".git/hooks"

# Function to create a hook
create_hook() {
    local hook_name=$1
    local hook_path="$HOOKS_DIR/$hook_name"

    echo "Creating $hook_name hook..."
    cat > "$hook_path" << 'EOF'
#!/bin/bash
EOF
    chmod +x "$hook_path"
}

# Pre-commit hook: Check for common issues
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash

# Development Algorithm Pre-commit Checks

echo "🔍 Running pre-commit checks..."

# Check for debugging statements
if git diff --cached --name-only | xargs grep -E "(console\.log|print\(|debugger|import pdb|pdb\.set_trace)" 2>/dev/null; then
    echo "❌ Found debug statements. Remove them before committing."
    echo "Hint: Use git diff --cached to see staged changes"
    exit 1
fi

# Check for TODO comments without issue numbers
if git diff --cached --name-only | xargs grep -E "TODO(?!\(#[0-9]+\))" 2>/dev/null; then
    echo "⚠️  Found TODO without issue number."
    echo "Consider adding issue reference: TODO(#123)"
fi

# Check for large files
for file in $(git diff --cached --name-only); do
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    if [ "$size" -gt 1048576 ]; then
        echo "⚠️  Large file detected: $file ($(($size / 1024))KB)"
        echo "Consider using Git LFS for large files"
    fi
done

# Remind about tests
echo "✅ Pre-commit checks passed"
echo "📝 Reminder: Did you write tests first? (TDD)"
EOF

# Commit-msg hook: Enforce conventional commits
cat > "$HOOKS_DIR/commit-msg" << 'EOF'
#!/bin/bash

# Development Algorithm Commit Message Validator

commit_regex='^(feat|fix|test|refactor|docs|style|perf|chore|build|ci|revert)(\([a-z0-9-]+\))?: .{1,100}$'
commit_msg=$(cat "$1")

if ! echo "$commit_msg" | grep -qE "$commit_regex"; then
    echo "❌ Invalid commit message format!"
    echo ""
    echo "📝 Format: type(scope): description"
    echo ""
    echo "Types:"
    echo "  feat     - New feature"
    echo "  fix      - Bug fix"
    echo "  test     - Adding tests"
    echo "  refactor - Code refactoring"
    echo "  docs     - Documentation"
    echo "  style    - Formatting"
    echo "  perf     - Performance"
    echo "  chore    - Maintenance"
    echo ""
    echo "Example: feat(auth): add login endpoint"
    echo ""
    echo "Your message: $commit_msg"
    exit 1
fi

# Check message length
if [ ${#commit_msg} -gt 100 ]; then
    echo "⚠️  Commit message is too long (${#commit_msg} chars, max 100)"
    echo "Consider moving details to the commit body"
fi

echo "✅ Commit message validated"
EOF

# Post-commit hook: Reminders and tracking
cat > "$HOOKS_DIR/post-commit" << 'EOF'
#!/bin/bash

# Development Algorithm Post-commit Actions

echo "✅ Commit successful!"
echo ""
echo "📊 Development Algorithm Checklist:"
echo "  □ Did you follow TDD (test first)?"
echo "  □ Is this an atomic commit (one logical change)?"
echo "  □ Are all tests passing?"
echo "  □ Did you update documentation if needed?"
echo ""

# Track commit in daily journal
JOURNAL_DIR="$HOME/development-journal"
TODAY=$(date +%Y-%m-%d)
JOURNAL_FILE="$JOURNAL_DIR/$TODAY.md"

if [ -f "$JOURNAL_FILE" ]; then
    commit_msg=$(git log -1 --pretty=%B)
    echo "" >> "$JOURNAL_FILE"
    echo "### Commit at $(date +%H:%M): $commit_msg" >> "$JOURNAL_FILE"
fi

# Show commit stats
echo "📈 Today's commits: $(git log --since=midnight --oneline | wc -l)"
EOF

# Make all hooks executable
chmod +x "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/commit-msg"
chmod +x "$HOOKS_DIR/post-commit"

echo "✅ Git hooks setup complete!"
echo ""
echo "Hooks installed:"
echo "  • pre-commit: Checks for debug statements and code quality"
echo "  • commit-msg: Enforces conventional commit format"
echo "  • post-commit: Tracks commits and shows reminders"
echo ""
echo "To skip hooks (emergency only): git commit --no-verify"