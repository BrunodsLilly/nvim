# Comprehensive Digital Presence Publishing

**Goal**: Publish EVERYTHING - your dotfiles, Zettelkasten, blog, learning journey, and workflows as a complete digital garden.

---

## Architecture Overview

### Content Sources

```
Your Digital Garden
├── 🧠 Knowledge Base (Zettelkasten)
│   ├── Permanent Notes (evergreen knowledge)
│   ├── Literature Notes (from reading)
│   ├── Project Notes (work context)
│   └── Fleeting Notes (quick captures)
├── 📝 Blog (narrative essays)
├── 🛠️ Tools & Setup
│   ├── Neovim Configuration
│   ├── Workflows & Algorithms
│   └── Scripts & Automation
├── 📚 Learning Journey
│   ├── DDRs (Design Decision Records)
│   ├── Fixes & Troubleshooting
│   └── Progress & Reflections
└── 🚀 Projects (showcases)
```

### Publishing Strategy: One Unified Site

**Single Quartz Site** that aggregates content from multiple sources:

```
~/digital-garden/              # GitHub repo: yourusername.github.io
├── content/
│   ├── index.md              # Landing page
│   ├── brain/                # From ~/zettelkasten
│   │   ├── permanent/
│   │   ├── literature/
│   │   └── projects/
│   ├── blog/                 # Original blog posts
│   ├── tools/                # From ~/.config/nvim
│   │   ├── neovim/
│   │   ├── workflows/
│   │   └── scripts/
│   └── journey/              # Learning journey
│       ├── ddrs/
│       └── reflections/
└── quartz/                   # Quartz static site generator
```

---

## Content Organization

### 1. Knowledge Base (Brain)

**Source**: `~/zettelkasten/`

**What to publish**:
- ✅ Permanent notes (evergreen, polished)
- ✅ Literature notes (book summaries, article notes)
- ✅ Project notes (public projects only)
- ❌ Fleeting notes (too raw)
- ❌ Work notes (confidential)
- ❌ Personal notes (private)

**Frontmatter template**:
```markdown
---
title: "Understanding TCP/IP"
date: 2025-10-24
updated: 2025-10-24
type: permanent-note
tags: [networking, learning, public]
publish: true
aliases: [TCP, IP Protocol]
---
```

### 2. Blog Posts

**Source**: `~/zettelkasten/blog/` OR `~/digital-garden/content/blog/`

**Structure**: Traditional narrative posts

**Frontmatter template**:
```markdown
---
title: "My Journey from VS Code to Neovim"
date: 2025-10-24
type: blog
tags: [neovim, tools, journey, public]
publish: true
description: "How I transitioned to Neovim and never looked back"
---
```

**Blog types**:
- 📖 **Tutorials**: Step-by-step guides
- 🎯 **Deep Dives**: Technical analysis
- 🚀 **Project Showcases**: What you built
- 💡 **Reflections**: Learning insights
- 🔧 **Fixes**: Problem-solving stories

### 3. Tools & Setup

**Source**: `~/.config/nvim/`

**What to publish**:
- ✅ Plugin configurations (anonymized)
- ✅ Workflows (Development Algorithm, etc.)
- ✅ Scripts (useful automations)
- ✅ Keybindings & mappings
- ✅ Setup guides
- ❌ Personal API keys/tokens
- ❌ Work-specific configs

**Structure**:
```
tools/
├── neovim/
│   ├── index.md              # "My Neovim Setup"
│   ├── plugins.md            # Plugin showcase
│   ├── lsp-setup.md          # LSP configuration
│   ├── workflows.md          # Development workflows
│   └── keybindings.md        # Keymaps reference
├── scripts/
│   ├── dual-doc.md           # Dual documentation script
│   ├── latex-setup.md        # LaTeX rendering setup
│   └── automation.md         # Other automations
└── dotfiles.md               # Link to dotfiles repo
```

### 4. Learning Journey

**Source**: Multiple sources

**DDRs** (from project repos):
```markdown
---
title: "DDR: Dual Documentation Strategy"
date: 2025-10-24
type: ddr
tags: [decision, documentation, workflow, public]
publish: true
---

## Context
We needed a way to document both project decisions and personal learning...

## Decision
Implement dual documentation: DDRs for project + Zettelkasten for learning...

## Consequences
- Improved knowledge retention
- Better team documentation
- Cross-pollination of ideas
```

**Learning Reflections**:
- Weekly/monthly reflections
- "Today I Learned" posts
- Problem-solving case studies

---

## Setup Guide

### Step 1: Create Digital Garden Repository

```bash
cd ~
mkdir digital-garden
cd digital-garden

# Initialize git
git init

# Clone Quartz
git clone https://github.com/jackyzha0/quartz.git
cd quartz
npm i
npx quartz create
```

### Step 2: Create Content Aggregation Script

Create `~/digital-garden/scripts/aggregate-content.sh`:

```bash
#!/bin/bash
# Aggregates content from all sources into digital-garden

set -e

GARDEN_ROOT="$HOME/digital-garden"
CONTENT_DIR="$GARDEN_ROOT/content"
ZETTEL_DIR="$HOME/zettelkasten"
NVIM_DIR="$HOME/.config/nvim"

echo "🌱 Building Digital Garden..."
echo ""

# Clean old content (except index)
find "$CONTENT_DIR" -mindepth 1 -maxdepth 1 ! -name 'index.md' -exec rm -rf {} +

# ========================================
# 1. KNOWLEDGE BASE (Zettelkasten)
# ========================================
echo "🧠 Aggregating Knowledge Base..."

mkdir -p "$CONTENT_DIR/brain"

# Copy permanent notes
if [ -d "$ZETTEL_DIR/permanent" ]; then
  find "$ZETTEL_DIR/permanent" -name "*.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/brain/"
      echo "  ✅ $(basename "$file")"
    fi
  done
fi

# Copy literature notes
if [ -d "$ZETTEL_DIR/literature" ]; then
  mkdir -p "$CONTENT_DIR/brain/literature"
  find "$ZETTEL_DIR/literature" -name "*.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/brain/literature/"
      echo "  ✅ Literature: $(basename "$file")"
    fi
  done
fi

# Copy public project notes
if [ -d "$ZETTEL_DIR/projects" ]; then
  mkdir -p "$CONTENT_DIR/brain/projects"
  find "$ZETTEL_DIR/projects" -name "*.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/brain/projects/"
      echo "  ✅ Project: $(basename "$file")"
    fi
  done
fi

# ========================================
# 2. BLOG POSTS
# ========================================
echo ""
echo "📝 Aggregating Blog Posts..."

mkdir -p "$CONTENT_DIR/blog"

if [ -d "$ZETTEL_DIR/blog" ]; then
  find "$ZETTEL_DIR/blog" -name "*.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/blog/"
      echo "  ✅ $(basename "$file")"
    fi
  done
fi

# ========================================
# 3. TOOLS & SETUP
# ========================================
echo ""
echo "🛠️ Aggregating Tools & Setup..."

mkdir -p "$CONTENT_DIR/tools/neovim"
mkdir -p "$CONTENT_DIR/tools/workflows"
mkdir -p "$CONTENT_DIR/tools/scripts"

# Neovim documentation
docs=(
  "CLAUDE.md"
  "DEVELOPMENT_ALGORITHM.md"
  "DUAL_DOCUMENTATION.md"
  "MASTER_WORKFLOW.md"
  "ZETTELKASTEN_WORKFLOW.md"
  "EQUATION_WORKFLOW.md"
)

for doc in "${docs[@]}"; do
  if [ -f "$NVIM_DIR/$doc" ]; then
    # Add frontmatter if not present
    if ! grep -q "^---" "$NVIM_DIR/$doc"; then
      {
        echo "---"
        echo "title: \"$(basename "$doc" .md | sed 's/_/ /g')\""
        echo "type: documentation"
        echo "tags: [neovim, tools, workflow]"
        echo "---"
        echo ""
        cat "$NVIM_DIR/$doc"
      } > "$CONTENT_DIR/tools/workflows/$(basename "$doc")"
    else
      cp "$NVIM_DIR/$doc" "$CONTENT_DIR/tools/workflows/"
    fi
    echo "  ✅ $doc"
  fi
done

# Plugin showcase
if [ -d "$NVIM_DIR/lua/plugins" ]; then
  cat > "$CONTENT_DIR/tools/neovim/plugins.md" <<EOF
---
title: "My Neovim Plugins"
type: showcase
tags: [neovim, plugins, tools]
---

# My Neovim Plugin Stack

This is my curated collection of Neovim plugins that supercharge my development workflow.

## Plugin List

$(ls -1 "$NVIM_DIR/lua/plugins" | sed 's/\.lua$//' | while read plugin; do
  echo "- [[plugins/$plugin]]"
done)

## Installation

All plugins are managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

See my [dotfiles repository](https://github.com/yourusername/dotfiles) for full configuration.
EOF
  echo "  ✅ Plugin showcase created"
fi

# ========================================
# 4. LEARNING JOURNEY
# ========================================
echo ""
echo "📚 Aggregating Learning Journey..."

mkdir -p "$CONTENT_DIR/journey/ddrs"
mkdir -p "$CONTENT_DIR/journey/fixes"

# Copy DDRs if they exist
if [ -d "$ZETTEL_DIR/projects" ]; then
  find "$ZETTEL_DIR/projects" -name "*-ddr.md" -type f | while read -r file; do
    if grep -q "^publish: true" "$file" 2>/dev/null; then
      cp "$file" "$CONTENT_DIR/journey/ddrs/"
      echo "  ✅ DDR: $(basename "$file")"
    fi
  done
fi

# Copy learning notes
learning_docs=(
  "IMAGE_NVIM_FIX.md"
  "MAGICK_ROCK_SOLUTION.md"
  "LATEX_IMAGE_SETUP.md"
  "PODMAN_LAZYDOCKER_FIX.md"
  "MARKDOWN_RENDERING_FIX.md"
  "FIXES_APPLIED.md"
)

for doc in "${learning_docs[@]}"; do
  if [ -f "$NVIM_DIR/$doc" ]; then
    cp "$NVIM_DIR/$doc" "$CONTENT_DIR/journey/fixes/"
    echo "  ✅ Fix: $doc"
  fi
done

# ========================================
# 5. IMAGES & ATTACHMENTS
# ========================================
echo ""
echo "📎 Copying attachments..."

if [ -d "$ZETTEL_DIR/images" ]; then
  cp -r "$ZETTEL_DIR/images" "$CONTENT_DIR/"
  echo "  ✅ Images copied"
fi

# ========================================
# DONE
# ========================================
echo ""
echo "✅ Content aggregation complete!"
echo ""
echo "Summary:"
echo "  - Knowledge base notes from Zettelkasten"
echo "  - Blog posts"
echo "  - Tools & workflow documentation"
echo "  - Learning journey & DDRs"
echo ""
echo "Next steps:"
echo "  cd $GARDEN_ROOT/quartz"
echo "  npx quartz build --serve  # Preview"
echo "  npx quartz sync           # Deploy"
```

Make it executable:
```bash
chmod +x ~/digital-garden/scripts/aggregate-content.sh
```

### Step 3: Create Landing Page

Create `~/digital-garden/content/index.md`:

```markdown
---
title: "Welcome to My Digital Garden"
---

# 👋 Welcome

I'm [Your Name], and this is my digital garden - a living, breathing collection of my knowledge, tools, and learning journey.

## 🗺️ Explore

### 🧠 [Knowledge Base](/brain)
My Zettelkasten - permanent notes, literature summaries, and insights I've developed over time. These are evergreen notes that grow and evolve.

### 📝 [Blog](/blog)
Essays, tutorials, and reflections on software engineering, learning, and problem-solving.

### 🛠️ [Tools & Setup](/tools)
My development environment, workflows, and the systems I use to learn and build effectively.

### 📚 [Learning Journey](/journey)
Design decisions, problem-solving stories, and the evolution of my thinking.

## 🌱 About Digital Gardens

This site is a digital garden, not a blog. That means:
- **Notes are living documents** - they grow and change over time
- **Imperfection is okay** - some notes are seeds, others are trees
- **Everything is connected** - follow the links to explore relationships
- **Learning in public** - see my thinking process and evolution

## 🔗 Connect

- GitHub: [yourusername](https://github.com/yourusername)
- Twitter/X: [@yourhandle](https://twitter.com/yourhandle)
- Email: your@email.com

## 📊 Stats

This garden contains:
- X permanent notes
- X blog posts
- X tools & workflows
- X learning reflections

Last tended: {{date}}

---

*This site is built with [Quartz](https://quartz.jzhao.xyz), published from markdown notes written in [Neovim](https://neovim.io), and organized using the [Zettelkasten method](https://zettelkasten.de).*
```

### Step 4: Configure Quartz

Edit `~/digital-garden/quartz/quartz.config.ts`:

```typescript
const config: QuartzConfig = {
  configuration: {
    pageTitle: "🌱 Your Name's Digital Garden",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "plausible",
    },
    locale: "en-US",
    baseUrl: "yourusername.github.io",
    ignorePatterns: ["private", "templates", ".obsidian", "**/node_modules"],
    defaultDateType: "created",
    theme: {
      typography: {
        header: "Schibsted Grotesk",
        body: "Source Sans Pro",
        code: "IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#faf8f8",
          lightgray: "#e5e5e5",
          gray: "#b8b8b8",
          darkgray: "#4e4e4e",
          dark: "#2b2b2b",
          secondary: "#284b63",
          tertiary: "#84a59d",
          highlight: "rgba(143, 159, 169, 0.15)",
        },
        darkMode: {
          light: "#161618",
          lightgray: "#393639",
          gray: "#646464",
          darkgray: "#d4d4d4",
          dark: "#ebebec",
          secondary: "#7b97aa",
          tertiary: "#84a59d",
          highlight: "rgba(143, 159, 169, 0.15)",
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate(),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
      }),
      Plugin.ObsidianFlavoredMarkdown(),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({
        markdownLinkResolution: "shortest",
      }),
      Plugin.Description(),
      Plugin.Latex({
        renderEngine: "katex",
      }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.NotFoundPage(),
    ],
  },
}

export default config
```

### Step 5: Deploy to GitHub Pages

```bash
cd ~/digital-garden

# Initialize git
git init
git add .
git commit -m "Initial digital garden setup"

# Create GitHub repo
gh repo create digital-garden --public --source=. --remote=origin
git push -u origin main

# Deploy
cd quartz
npx quartz sync --commit "Initial publish"
```

GitHub Actions will build and deploy automatically.

---

## Publishing Workflow

### Daily/Weekly Publishing

```bash
# 1. Aggregate content
cd ~/digital-garden
./scripts/aggregate-content.sh

# 2. Preview locally
cd quartz
npx quartz build --serve
# Visit http://localhost:8080

# 3. Deploy
npx quartz sync --commit "Update: $(date +%Y-%m-%d)"
```

### Neovim Integration

Add to `lua/plugins/zettelkasten.lua`:

```lua
-- Publish entire digital garden
vim.keymap.set("n", "<leader>zP", function()
  vim.cmd("!~/digital-garden/scripts/aggregate-content.sh")
  print("✅ Digital garden updated. Run 'cd ~/digital-garden/quartz && npx quartz sync' to deploy")
end, { desc = "Publish Digital Garden" })

-- Quick deploy (runs aggregate + deploy)
vim.keymap.set("n", "<leader>zD", function()
  vim.cmd("!~/digital-garden/scripts/aggregate-content.sh && cd ~/digital-garden/quartz && npx quartz sync --commit 'Update: $(date +%Y-%m-%d)'")
end, { desc = "Deploy Digital Garden" })
```

---

## Content Frontmatter Standards

### All Content

Every publishable note needs:

```markdown
---
title: "Note Title"
date: 2025-10-24
updated: 2025-10-24  # Auto-update on changes
type: permanent-note|blog|documentation|ddr|fix
tags: [tag1, tag2, public]
publish: true
description: "Brief description for SEO and previews"
---
```

### Type Definitions

- `permanent-note` - Zettelkasten permanent notes
- `literature-note` - Book/article summaries
- `project-note` - Project-related notes
- `blog` - Traditional blog posts
- `documentation` - Tool/workflow documentation
- `ddr` - Design Decision Record
- `fix` - Problem-solving story
- `reflection` - Learning reflection

---

## Privacy & Security

### What NOT to Publish

Create `~/digital-garden/.publishignore`:

```
# Never publish
**/private/*
**/personal/*
**/work/*
**/.env
**/credentials*
**/secrets*
**/api_keys*

# Templates
**/templates/*

# System files
.DS_Store
.git
node_modules
```

### Review Checklist

Before deploying:
- [ ] No API keys or tokens
- [ ] No work-specific info
- [ ] No personal identifiers (unless intended)
- [ ] All `publish: true` notes reviewed
- [ ] Links point to public content
- [ ] Images don't contain sensitive info

---

## Advanced Features

### Custom Components

Quartz supports custom components. Add to `quartz/components/`:

```typescript
// StatsComponent.tsx
export default function Stats() {
  return (
    <div class="stats">
      <h3>Garden Stats</h3>
      <ul>
        <li>Notes: {noteCount}</li>
        <li>Connections: {linkCount}</li>
        <li>Last Updated: {lastUpdate}</li>
      </ul>
    </div>
  )
}
```

### RSS Feed

Automatically generated for:
- All blog posts
- Recent note updates
- New permanent notes

Readers can subscribe at: `https://yourusername.github.io/index.xml`

### Search

Full-text search across ALL content automatically enabled.

### Graph View

Interactive graph showing ALL connections between:
- Zettelkasten notes
- Blog posts
- Tools & workflows
- Learning journey

---

## Maintenance

### Weekly Routine

```bash
# Sunday evening
cd ~/digital-garden
./scripts/aggregate-content.sh
cd quartz
npx quartz build --serve  # Review changes
npx quartz sync --commit "Weekly update: $(date +%Y-%m-%d)"
```

### Monthly Review

- Review analytics (if enabled)
- Update landing page stats
- Prune outdated content
- Update interconnections
- Refine tagging

---

## Showcase Examples

Your digital garden will include:

1. **Knowledge Base**: Connected notes on topics you're learning
2. **Blog**: "How I Built My Neovim Setup", "Learning Rust", etc.
3. **Tools**: Your entire Neovim config, workflows, scripts
4. **Journey**: Every fix, every decision, every "aha!" moment
5. **Projects**: Public projects with full context

Everything interconnected, everything searchable, everything growing.

---

## Next Steps

1. Run `~/digital-garden/scripts/aggregate-content.sh`
2. Create landing page with your personal touch
3. Mark 5-10 notes as `publish: true` to start
4. Preview locally
5. Deploy!
6. Share your digital garden 🌱

Your learning journey becomes a public resource. Your tools inspire others. Your knowledge compounds.

**Welcome to learning in public.**
