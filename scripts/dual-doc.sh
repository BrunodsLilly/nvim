#!/bin/bash

# Dual Documentation Creator
# Creates linked DDR and Zettelkasten entries for a feature/decision

# Get feature name from argument or prompt
if [ -n "$1" ]; then
    FEATURE_NAME="$1"
    echo "📝 Creating dual documentation for: $FEATURE_NAME"
else
    echo "📝 Dual Documentation Creator"
    echo "============================"
    echo ""
    read -p "Enter feature/decision name (kebab-case): " FEATURE_NAME

    if [ -z "$FEATURE_NAME" ]; then
        echo "❌ Feature name is required"
        exit 1
    fi
fi

# Set up paths
DATE=$(date +%Y-%m-%d)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
DDR_PATH="$PROJECT_ROOT/docs/ddr"
DDR_FILE="$DDR_PATH/$DATE-$FEATURE_NAME.md"
ZETTEL_PATH="$HOME/zettelkasten/projects"
ZETTEL_FILE="$ZETTEL_PATH/$DATE-$FEATURE_NAME.md"

# Create directories if they don't exist
mkdir -p "$DDR_PATH"
mkdir -p "$ZETTEL_PATH"

# Create DDR (Project Documentation)
if [ ! -f "$DDR_FILE" ]; then
    cat > "$DDR_FILE" << EOF
# Decision: ${FEATURE_NAME}

## Metadata
- Date: $DATE
- Status: 🔍 Analyzing
- Author: $(git config user.name || echo "Unknown")
- Personal Notes: [Zettelkasten Entry](file://$ZETTEL_FILE)

## Context

*What problem are we solving? Why now?*

## Requirements

- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Options Considered

### Option A: [Name]
**Description:**

**Pros:**
-

**Cons:**
-

**Effort:** Low / Medium / High

### Option B: [Name]
**Description:**

**Pros:**
-

**Cons:**
-

**Effort:** Low / Medium / High

## Decision

*Which option did we choose and why?*

## Consequences

### Positive
-

### Negative
-

### Risks
-

## Implementation Notes

*Key details for whoever implements this*

## Related Documents
- Personal Learning: [Zettelkasten Entry](file://$ZETTEL_FILE)
- Related DDR: [[docs/ddr/other-decision]]
- Issue/Ticket: #

---

*Last Updated: $DATE*
EOF
    echo "✅ Created DDR: $DDR_FILE"
else
    echo "⚠️  DDR already exists: $DDR_FILE"
fi

# Create Zettelkasten Entry (Personal Learning)
if [ ! -f "$ZETTEL_FILE" ]; then
    cat > "$ZETTEL_FILE" << EOF
# Project: ${FEATURE_NAME}

Date: $DATE
Type: Project Note
Status: 🔍 Active
Tags: #project #development #learning

## Overview

*What am I building and why is it interesting?*

## Learning Goals

- [ ] Understand [concept/technology]
- [ ] Master [technique/pattern]
- [ ] Answer: [specific question]

## Questions I Have

### Before Starting
- Why does [X] work this way?
- What's the best pattern for [Y]?
- How do experts handle [Z]?

### During Implementation
-

## Discoveries & Insights

### Technical Discoveries
-

### Pattern Recognition
-

### Aha Moments
-

## Challenges Faced

### Challenge 1: [Name]
**Problem:**
**Solution:**
**Learning:**

## Code Snippets

\`\`\`language
// Interesting code worth remembering
\`\`\`

## Resources

### Documentation
- [Official Docs]()
- [Tutorial]()

### Similar Solutions
- [[projects/similar-project]]
- [GitHub Example]()

## Permanent Notes Created

*Extract insights to permanent notes*

- [[permanent/pattern-name]]
- [[permanent/principle-name]]
- [[permanent/technique-name]]

## Reflection

### What Worked Well
-

### What I'd Do Different
-

### Future Applications
*Where else could I use this knowledge?*
-

## Links

- **Project DDR:** [Decision Record](file://$DDR_FILE)
- **Related Daily Notes:** [[daily/$DATE]]
- **Similar Projects:** [[projects/other]]

---

*Created: $DATE*
*Last Updated: $DATE*
EOF
    echo "✅ Created Zettelkasten: $ZETTEL_FILE"
else
    echo "⚠️  Zettelkasten entry already exists: $ZETTEL_FILE"
fi

# Output file paths for Neovim to open
echo ""
echo "✅ Files created successfully!"
echo ""
echo "DDR: $DDR_FILE"
echo "ZETTEL: $ZETTEL_FILE"