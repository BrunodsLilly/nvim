#!/bin/bash

# Setup Zettelkasten Directory Structure and Templates

ZETTEL_HOME="$HOME/zettelkasten"

echo "🧠 Setting up Zettelkasten Second Brain System..."

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p "$ZETTEL_HOME"/{daily,weekly,templates,images,work,personal}
mkdir -p "$ZETTEL_HOME"/{fleeting,literature,permanent,projects}
mkdir -p "$ZETTEL_HOME"/areas/{development,learning,ideas,references}

# Create Index file
echo "📝 Creating Index..."
cat > "$ZETTEL_HOME/index.md" << 'EOF'
# 🧠 Zettelkasten Index

Welcome to your Second Brain. This is your knowledge management system.

## Quick Links

- [[daily/index|📅 Daily Notes]]
- [[weekly/index|📊 Weekly Reviews]]
- [[fleeting/index|💭 Fleeting Notes]]
- [[literature/index|📚 Literature Notes]]
- [[permanent/index|💎 Permanent Notes]]
- [[projects/index|🚀 Projects]]

## Areas of Focus

- [[areas/development/index|💻 Development]]
- [[areas/learning/index|📖 Learning]]
- [[areas/ideas/index|💡 Ideas]]
- [[areas/references/index|🔖 References]]

## Recent Notes

<!-- Will be auto-populated -->

## Tags Index

#development #learning #idea #reference #project #insight #pattern #principle

## Search

- Find notes: `<leader>zf`
- Search content: `<leader>zg`
- Show all tags: `<leader>za`
- Show backlinks: `<leader>zb`

---

*"Building a Second Brain, one note at a time"*

Last updated: DATE
EOF

# Create Daily Note Template
echo "📅 Creating daily note template..."
cat > "$ZETTEL_HOME/templates/daily.md" << 'EOF'
# Daily Note - {{date}}

## 🎯 Today's Focus

- [ ] Primary goal:
- [ ] Secondary goal:
- [ ] Nice to have:

## 📝 Development Log

### Morning Session
- **Working on:**
- **Challenges:**
- **Solutions:**

### Afternoon Session
- **Working on:**
- **Challenges:**
- **Solutions:**

## 💡 Insights & Ideas

### Technical Discoveries
-

### Patterns Noticed
-

### Questions Raised
-

## 📚 Learning

### New Concepts
-

### Resources Reviewed
-

### To Research
-

## 🔗 Related Notes

- [[permanent/]]
- [[literature/]]
- [[projects/]]

## 📊 Metrics

- Commits:
- Tests Written:
- PRs Reviewed:
- Bugs Fixed:
- Features Shipped:

## 🌟 Wins

-

## 🚧 Blockers

-

## 📋 Tomorrow's Plan

-

---

Tags: #daily #development
Links: [[index|Home]] | [[daily/{{yesterday}}|← Yesterday]] | [[daily/{{tomorrow}}|Tomorrow →]]
EOF

# Create Weekly Review Template
echo "📊 Creating weekly review template..."
cat > "$ZETTEL_HOME/templates/weekly.md" << 'EOF'
# Weekly Review - Week {{week}}, {{year}}

## 📈 Week Overview

### Key Accomplishments
1.
2.
3.

### Metrics Summary
- **Commits:**
- **PRs Merged:**
- **Tests Written:**
- **Features Completed:**
- **Bugs Fixed:**
- **TDD Compliance:** __%

## 💡 Key Insights

### Technical Learning
-

### Process Improvements
-

### Patterns Recognized
-

## 📚 Knowledge Building

### New Permanent Notes Created
- [[permanent/]]

### Literature Processed
- [[literature/]]

### Fleeting Notes to Process
- [[fleeting/]]

## 🎯 Goal Review

### Last Week's Goals
- [ ] Goal 1:
- [ ] Goal 2:
- [ ] Goal 3:

### Next Week's Goals
- [ ] Goal 1:
- [ ] Goal 2:
- [ ] Goal 3:

## 🔄 Process Reflection

### What Worked Well
-

### What Needs Improvement
-

### Experiments to Try
-

## 📖 Learning Focus

### Skills Developed
-

### Resources Consumed
-

### Next Learning Priority
-

## 🔗 Notable Notes This Week

### Monday: [[daily/]]
### Tuesday: [[daily/]]
### Wednesday: [[daily/]]
### Thursday: [[daily/]]
### Friday: [[daily/]]

---

Tags: #weekly #review #reflection
Links: [[index|Home]] | [[weekly/{{last-week}}|← Last Week]] | [[weekly/{{next-week}}|Next Week →]]
EOF

# Create New Note Template
echo "💎 Creating new note template..."
cat > "$ZETTEL_HOME/templates/new_note.md" << 'EOF'
# {{title}}

Date: {{date}}
Type: {{type}}
Tags: {{tags}}

## Summary

*One-sentence summary of this note's key insight.*

## Content

### Main Idea

### Supporting Points

1.
2.
3.

### Evidence/Examples

## Connections

### Related Notes
- [[]]

### Contradicts
- [[]]

### Supports
- [[]]

### Questions This Raises
-

## Application

### How This Applies To Current Work
-

### Action Items
- [ ]

## References

- Source:
- Additional Reading:

---

Created: {{date}}
Modified: {{date}}
Tags: #
Links: [[index|Home]]
EOF

# Create Fleeting Note Template
echo "💭 Creating fleeting note template..."
cat > "$ZETTEL_HOME/templates/fleeting.md" << 'EOF'
# Fleeting: {{title}}

Date: {{date}}
Context: {{context}}

## Quick Capture

{{content}}

## To Process

- [ ] Expand into permanent note
- [ ] Find connections
- [ ] Add to relevant project
- [ ] Extract action items

---

Tags: #fleeting #to-process
Created: {{date}}
EOF

# Create Literature Note Template
echo "📚 Creating literature note template..."
cat > "$ZETTEL_HOME/templates/literature.md" << 'EOF'
# Literature: {{title}}

Source: {{source}}
Author: {{author}}
Date Read: {{date}}
Type: {{type}} (Book/Article/Video/Paper)

## Summary

*What is this about in my own words?*

## Key Ideas

### Idea 1:
**Quote:** ""
**My Interpretation:**

### Idea 2:
**Quote:** ""
**My Interpretation:**

### Idea 3:
**Quote:** ""
**My Interpretation:**

## Personal Reflection

### How This Relates to My Work
-

### What I Agree With
-

### What I Disagree With / Question
-

### Actions to Take
- [ ]

## Permanent Notes Created

- [[permanent/]]

## Related Literature

- [[literature/]]

---

Tags: #literature #
Links: [[index|Home]] | [[literature/index|Literature Index]]
EOF

# Create Permanent Note Template
echo "💎 Creating permanent note template..."
cat > "$ZETTEL_HOME/templates/permanent.md" << 'EOF'
# {{title}}

ID: {{id}}
Created: {{date}}
Type: Permanent Note

## Principle

*State the principle/insight in one clear sentence.*

## Explanation

*Explain the concept in your own words, as if teaching someone else.*

## Evidence

### From Experience
-

### From Literature
- [[literature/]]

### From Projects
- [[projects/]]

## Applications

### In Development
-

### In Learning
-

### In Problem-Solving
-

## Connections

### Building Blocks (What this is built on)
- [[permanent/]]

### Outcomes (What this leads to)
- [[permanent/]]

### Related Concepts
- [[permanent/]]

### Contradictions/Tensions
- [[permanent/]]

## Examples

### Example 1:

### Example 2:

## Questions for Further Exploration

1.
2.
3.

---

Tags: #permanent #principle #insight
Links: [[index|Home]] | [[permanent/index|Permanent Notes]]
EOF

# Create Project Template
echo "🚀 Creating project template..."
cat > "$ZETTEL_HOME/templates/project.md" << 'EOF'
# Project: {{title}}

Status: {{status}} (Planning/Active/Paused/Complete)
Started: {{date}}
Deadline: {{deadline}}

## Overview

### Goal
*What does success look like?*

### Context
*Why is this important?*

### Scope
*What's included/excluded?*

## Planning

### Milestones
- [ ] Milestone 1:
- [ ] Milestone 2:
- [ ] Milestone 3:

### Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

### Resources Needed
-

## Progress Log

### {{date}}
- What was done:
- Challenges:
- Next steps:

## Technical Decisions

### Architecture
- [[permanent/]]

### Technologies
-

### Patterns Used
- [[permanent/]]

## Learning

### New Skills Acquired
-

### Insights Gained
- [[permanent/]]

### Mistakes Made
-

## Related Notes

### Daily Logs
- [[daily/]]

### Reference Materials
- [[literature/]]

### Ideas
- [[fleeting/]]

## Outcomes

### Deliverables
-

### Metrics
-

### Lessons Learned
-

---

Tags: #project #active
Links: [[index|Home]] | [[projects/index|Projects]]
EOF

# Create subdirectory index files
echo "📑 Creating index files..."

# Daily index
cat > "$ZETTEL_HOME/daily/index.md" << 'EOF'
# Daily Notes Index

## Recent Entries

<!-- Auto-populated -->

## Navigation

- Create today's note: `<leader>zd`
- Find daily notes: `<leader>zf` then search "daily/"

## Purpose

Daily notes capture:
- Development progress
- Insights and ideas
- Challenges and solutions
- Learning moments
- Metrics and tracking

---

[[index|← Home]]
EOF

# Fleeting index
cat > "$ZETTEL_HOME/fleeting/index.md" << 'EOF'
# Fleeting Notes

Quick captures that need processing into permanent notes.

## Unprocessed

<!-- List fleeting notes here -->

## Processing Workflow

1. Capture quickly (don't worry about formatting)
2. Review weekly
3. Extract insights → [[permanent/index|Permanent Notes]]
4. Link to projects → [[projects/index|Projects]]
5. Archive or delete

---

[[index|← Home]]
EOF

# Literature index
cat > "$ZETTEL_HOME/literature/index.md" << 'EOF'
# Literature Notes

Notes from books, articles, videos, and other sources.

## Recent Additions

<!-- List recent literature notes -->

## By Category

### Books
### Articles
### Videos
### Papers
### Documentation

## Processing Workflow

1. Read/watch/listen actively
2. Capture key ideas with quotes
3. Write in your own words
4. Extract principles → [[permanent/index|Permanent Notes]]
5. Connect to projects

---

[[index|← Home]]
EOF

# Permanent index
cat > "$ZETTEL_HOME/permanent/index.md" << 'EOF'
# Permanent Notes

Refined, atomic ideas that represent your understanding.

## Core Principles

### Development Principles
### Learning Principles
### Problem-Solving Patterns
### Design Patterns

## Recent Additions

<!-- List recent permanent notes -->

## By Topic

### Software Architecture
### Testing & TDD
### Clean Code
### Performance
### Security
### Team Collaboration

## Note Quality Checklist

- [ ] One idea per note
- [ ] Written in your own words
- [ ] Linked to evidence
- [ ] Connected to other notes
- [ ] Has practical applications

---

[[index|← Home]]
EOF

# Create .gitignore
echo "🔒 Creating .gitignore..."
cat > "$ZETTEL_HOME/.gitignore" << 'EOF'
# Temporary files
*.swp
*.swo
*~
.DS_Store

# Private notes (prefix with private-)
private-*

# HTML exports
html/

# Media files (optional - remove if you want to track images)
# images/
EOF

# Initialize git repository
echo "🔧 Initializing git repository..."
cd "$ZETTEL_HOME"
git init
git add .
git commit -m "Initial Zettelkasten setup"

echo "✅ Zettelkasten setup complete!"
echo ""
echo "📍 Location: $ZETTEL_HOME"
echo ""
echo "🚀 Quick Start:"
echo "  1. Open Neovim"
echo "  2. Press <leader>ww to open your Zettelkasten index"
echo "  3. Press <leader>zd to create today's daily note"
echo "  4. Press <leader>zn to create a new note"
echo ""
echo "📚 Key Bindings:"
echo "  <leader>ww - Open Zettelkasten index"
echo "  <leader>zn - New note"
echo "  <leader>zf - Find notes"
echo "  <leader>zg - Search note contents"
echo "  <leader>zd - Today's daily note"
echo "  <leader>zt - Show tags"
echo "  <leader>zb - Show backlinks"
echo ""
echo "💡 Tip: Start with a daily note to capture today's work!"