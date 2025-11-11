# Public & Private Diary System

How to keep personal thoughts private while sharing learning publicly.

---

## The Problem

Your daily notes contain:
- ✅ **Public**: Learning insights, project updates, technical reflections
- 🔒 **Private**: Personal thoughts, job search, sensitive info

You want to publish learning but keep personal stuff private.

---

## Solution: Dual-Section Daily Notes

### Approach 1: Sections with Markers (Recommended)

Use HTML comments to mark sections:

```markdown
---
title: "Daily Note - 2025-10-25"
date: 2025-10-25
type: daily-note
---

# Daily Note - 2025-10-25

<!-- PUBLIC_START -->

## 🎯 Today's Focus
Built authentication system with JWT tokens.

## 💡 Key Insights
- JWT security requires careful secret management
- [[202510251200-jwt-token-security]]
- TDD caught edge cases early

## 📚 What I Learned
- Declarative config patterns appear everywhere
- Same pattern in K8s, Terraform, React
- [[202510251130-declarative-pattern-universal]]

## 🔗 Active Contexts
- [[project-auth-system]]
- [[learning-kubernetes]]

<!-- PUBLIC_END -->

<!-- PRIVATE_START -->

## 💼 Personal
- Applied to 3 companies today
- Interview with Acme Corp next week
- Considering pivot to DevOps role

## 🤔 Career Thoughts
- Current role feels stagnant
- Want more distributed systems work
- Should I pursue K8s certification?

<!-- PRIVATE_END -->
```

**Benefits:**
- One file to manage
- Clear separation
- Easy to review what's public

### Approach 2: Separate Public Reflection Notes

Keep daily notes 100% private, create separate public reflections:

**Daily Note** (always private):
```markdown
# Daily Note - 2025-10-25

## Work
Built auth system. Feeling good about progress.

## Personal
Job search update: applied to 3 places.
Interview prep tonight.

## Learning
- JWT patterns
- K8s scheduling

Link to public reflection: [[202510251800-daily-reflection]]
```

**Public Reflection** (published):
```markdown
---
title: "Daily Reflection - Authentication System"
date: 2025-10-25
type: reflection
tags: [public, learning, authentication]
publish: true
---

# Daily Reflection - 2025-10-25

## What I Built
Implemented JWT authentication with refresh tokens.

## Key Insights
- [[202510251200-jwt-token-security]]
- Declarative config patterns everywhere
- TDD caught silent failures

## Lessons
Secret management is harder than expected.
Environment variables need validation.

## Tomorrow's Focus
Add 2FA support to auth system.

Related: [[project-auth-system]]
```

**Benefits:**
- Complete privacy for daily notes
- Public reflections are curated
- Can skip days without publishing

---

## Implementation

### Option 1: Section Markers (Automated Filtering)

**Update aggregation script** to filter sections:

Create `~/digital-garden/scripts/filter-daily-notes.sh`:

```bash
#!/bin/bash
# Extracts only PUBLIC sections from daily notes

INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Extract frontmatter
awk '/^---$/{p++} p==1 || p==2' "$INPUT_FILE" > "$OUTPUT_FILE"

# Extract PUBLIC sections only
awk '/<!-- PUBLIC_START -->/,/<!-- PUBLIC_END -->/' "$INPUT_FILE" |
  grep -v "<!-- PUBLIC" >> "$OUTPUT_FILE"
```

**Update `aggregate-content.sh`:**

```bash
# In the daily notes section
if [ -d "$ZETTEL_DIR/daily" ]; then
  mkdir -p "$CONTENT_DIR/journal"
  find "$ZETTEL_DIR/daily" -name "*.md" -type f | while read -r file; do
    if grep -q "<!-- PUBLIC_START -->" "$file"; then
      basename_file=$(basename "$file")
      # Filter and copy only public sections
      ~/digital-garden/scripts/filter-daily-notes.sh "$file" "$CONTENT_DIR/journal/$basename_file"
      echo "  ✅ Journal (filtered): $basename_file"
    fi
  done
fi
```

### Option 2: Separate Reflection Notes

**Create reflection template:**

`~/zettelkasten/templates/daily-reflection.md`:

```markdown
---
title: "Daily Reflection - {{date}}"
date: {{date}}
type: reflection
tags: [public, learning, reflection]
publish: true
---

# Daily Reflection - {{date}}

## What I Built/Learned Today


## Key Insights
- [[]]


## Challenges


## Tomorrow's Focus


## Related
- [[daily/{{date}}-daily-note]] (private)
- [[]]
```

**Add keybinding** to `zettelkasten.lua`:

```lua
{
  "<leader>zD",
  function()
    local date = os.date("%Y%m%d%H%M")
    local title = vim.fn.input("Reflection title: ")
    local filename = string.format("%s-%s.md", date, title:gsub("%s+", "-"):lower())
    vim.cmd("e ~/zettelkasten/reflections/" .. filename)
  end,
  desc = "New Daily Reflection (Public)",
},
```

**Update aggregation script:**

```bash
# Copy public reflections
if [ -d "$ZETTEL_DIR/reflections" ]; then
  mkdir -p "$CONTENT_DIR/journal"
  find "$ZETTEL_DIR/reflections" -name "*.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/journal/"
      echo "  ✅ Reflection: $(basename "$file")"
    fi
  done
fi
```

---

## Directory Structure

### Option 1 (Section Markers)
```
~/zettelkasten/
├── daily/
│   ├── 2025-10-25.md          # Mixed public/private
│   └── 2025-10-26.md          # Mixed public/private
```

### Option 2 (Separate Reflections)
```
~/zettelkasten/
├── daily/                      # 100% private, never published
│   ├── 2025-10-25.md
│   └── 2025-10-26.md
├── reflections/                # Curated, publishable
│   ├── 202510251800-auth-system-reflection.md
│   └── 202510261900-kubernetes-learning.md
```

---

## Workflow Comparison

### Option 1: Section Markers

**Morning:**
```vim
<leader>zd  " Open daily note
```

Write throughout day:
```markdown
<!-- PUBLIC_START -->
## Learning
Built K8s operator today
<!-- PUBLIC_END -->

<!-- PRIVATE_START -->
## Personal
Job interview went well!
<!-- PRIVATE_END -->
```

**Evening:**
Script automatically filters when publishing.

**Pros:**
- Everything in one file
- Automatic filtering

**Cons:**
- Need to remember markers
- Less control over published form

### Option 2: Separate Reflections

**Morning:**
```vim
<leader>zd  " Open daily note (private)
```

Write freely all day (100% private).

**Evening:**
```vim
<leader>zD  " Create public reflection
```

Curate what to share:
```markdown
---
publish: true
---

# Daily Reflection

[Thoughtfully written public post]
```

**Pros:**
- Complete privacy by default
- Curated public content
- Can skip days

**Cons:**
- Two files to manage
- Extra step to publish

---

## Recommended Approach

**I recommend Option 2: Separate Reflections**

**Why:**
1. **Privacy by default** - Daily notes NEVER published
2. **Curation** - You choose what to share
3. **Quality** - Public reflections are thoughtful, not raw
4. **Flexibility** - Skip days, combine topics, etc.
5. **No markers** - Less to remember

**Your workflow:**

```
Morning:
  <leader>zd → Write freely (private thoughts, job search, etc.)

Evening:
  <leader>zD → Curate public reflection (learning, insights)

Sunday:
  ./aggregate-content.sh → Only reflections with publish: true go public
```

---

## Implementation Guide

### Step 1: Create Reflections Directory

```bash
mkdir -p ~/zettelkasten/reflections
```

### Step 2: Create Template

```bash
cat > ~/zettelkasten/templates/daily-reflection.md <<'EOF'
---
title: "Daily Reflection - {{date}}"
date: {{date}}
type: reflection
tags: [public, learning, reflection]
publish: true
---

# Daily Reflection - {{date}}

## What I Built/Learned


## Key Insights
-


## Tomorrow's Focus


## Related
- [[daily/{{date}}]] (private notes)
EOF
```

### Step 3: Add Keybinding

Add to `lua/plugins/zettelkasten.lua`:

```lua
{ "<leader>zD", function()
  local date = os.date("%Y-%m-%d")
  local title = vim.fn.input("Reflection title (optional): ")
  local filename
  if title ~= "" then
    filename = string.format("reflections/%s-%s.md",
      os.date("%Y%m%d%H%M"),
      title:gsub("%s+", "-"):lower())
  else
    filename = string.format("reflections/%s-daily-reflection.md",
      os.date("%Y%m%d%H%M"))
  end
  vim.cmd("e ~/zettelkasten/" .. filename)
end, desc = "New Daily Reflection (Public)" },
```

### Step 4: Update Aggregation Script

Add to `~/digital-garden/scripts/aggregate-content.sh`:

```bash
# ========================================
# DAILY REFLECTIONS (Public)
# ========================================
echo ""
echo "📔 Aggregating Daily Reflections..."

mkdir -p "$CONTENT_DIR/journal"

if [ -d "$ZETTEL_DIR/reflections" ]; then
  find "$ZETTEL_DIR/reflections" -name "*.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/journal/"
      echo "  ✅ Reflection: $(basename "$file")"
    fi
  done
fi
```

---

## Daily Workflow

### Morning (8:00 AM)
```vim
nvim
<leader>zd  " Daily note
```

Write everything:
```markdown
# Daily Note - 2025-10-25

## 🎯 Focus
Build auth system

## 💼 Personal
- Job search: Applied to Google, Amazon
- Interview prep: study system design
- Feeling burned out, need vacation

## 💡 Technical
- Working on JWT implementation
- Discovered secret management issues
```

### Evening (6:00 PM)
```vim
<leader>zD  " Create public reflection
```

Curate for public:
```markdown
---
publish: true
---

# Daily Reflection - Authentication Journey

Built JWT authentication today. Key learning:
secret management is harder than expected.

Created: [[202510251200-jwt-secret-management]]

Tomorrow: Add 2FA support.
```

### Sunday Publishing
```bash
./aggregate-content.sh
# Only reflections/ with publish: true are copied
# daily/ notes NEVER copied
```

---

## Privacy Checklist

✅ **Daily notes** → Never published (not in script)
✅ **Reflections without `publish: true`** → Not published
✅ **Reflections with `publish: true`** → Published
✅ **Personal thoughts** → Stay in daily notes only

**Rule:** If it's in `daily/`, it's 100% private. Always.

---

## Next Steps

1. Create `~/zettelkasten/reflections/` directory
2. Add reflection template
3. Add `<leader>zD` keybinding
4. Update aggregation script
5. Try writing one reflection tonight!

Your daily notes stay private. Your learning stays public. Perfect! 🎯
