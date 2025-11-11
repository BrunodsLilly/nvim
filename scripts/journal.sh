#!/bin/bash

# Development Journal Setup Script
# Run this to create today's journal entry

JOURNAL_DIR="$HOME/development-journal"
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d)
JOURNAL_FILE="$JOURNAL_DIR/$TODAY.md"

# Create journal directory if it doesn't exist
mkdir -p "$JOURNAL_DIR"

# Create today's entry if it doesn't exist
if [ ! -f "$JOURNAL_FILE" ]; then
    cat > "$JOURNAL_FILE" << EOF
# Development Journal - $TODAY

## Morning Intention
> Today I will focus on: [ONE THING]

## Tasks Planned
- [ ]
- [ ]
- [ ]

---

## What I Built
<!-- Describe features/fixes completed -->

## What I Learned
### Technical
-

### Process
-

### Domain
-

## Challenges & Solutions
| Challenge | Solution | Learning |
|-----------|----------|----------|
| | | |

## Mistakes Made
- **Mistake:**
  **Lesson:**
  **Prevention:**

## Code Quality Metrics
- Tests written first: ___/___
- Commits today: ___
- PRs merged: ___
- Bugs found: ___
- Refactoring sessions: ___

## Time Tracking
| Task | Estimated | Actual | Accuracy |
|------|-----------|--------|----------|
| | | | |

**Total accuracy:** ____%

## AI Assistance Log
- **Used for:**
- **Most helpful prompt:**
- **Key insight gained:**

## Tomorrow's Focus
1.
2.
3.

## Weekly Review (Friday only)
### Wins
-

### Struggles
-

### Commitments for next week
-

---

## Random Thoughts / Ideas
<!-- Capture any insights, ideas for improvement, or aha moments -->

---

*End of day energy level: [1-10]*
*Development Algorithm compliance: [A/B/C/D/F]*
*Overall satisfaction: [1-10]*
EOF
    echo "✅ Created journal entry: $JOURNAL_FILE"
else
    echo "📝 Journal entry already exists: $JOURNAL_FILE"
fi

# Open in Neovim
nvim "$JOURNAL_FILE"