# Publishing Your Second Brain & Blog to GitHub Pages

Complete guide for publishing your Zettelkasten notes and blog as a digital garden using Quartz.

---

## Overview

**Recommendation: Quartz v4**

Quartz is perfect for your use case because:
- ✅ **Wiki-link support** - Your `[[note]]` links work out of the box
- ✅ **Backlinks** - Automatically shows what links to each note
- ✅ **Graph view** - Visual network of your knowledge
- ✅ **Fast** - Incredibly quick page loads
- ✅ **GitHub Pages** - Easy deployment
- ✅ **Hot reload** - See changes instantly while writing
- ✅ **Full-text search** - Find anything quickly
- ✅ **Markdown native** - No conversion needed

---

## Architecture

### Two-Repository Strategy

```
~/zettelkasten/           # Private repo (your vault)
├── daily/
├── fleeting/
├── literature/
├── permanent/           # ← Publish these
├── projects/            # ← Publish these (curated)
└── .private/            # ← Never publish

~/quartz/                # Public repo (Quartz site)
└── content/             # ← Synced from ~/zettelkasten
```

**Why two repos?**
- Keep private notes private (work, personal)
- Publish only curated, polished notes
- Maintain full control over what's public

---

## Privacy-First Publishing

### Marking Notes as Public

Add frontmatter to notes you want to publish:

```markdown
---
title: "My Awesome Note"
date: 2025-10-24
tags: [public, programming, learning]
publish: true
---

# My Awesome Note

Content here...
```

Notes **without** `publish: true` will NOT be published.

### Three Privacy Levels

1. **Public** - `publish: true` in frontmatter
2. **Private** - No `publish` field (default)
3. **Secret** - Store in `~/zettelkasten/.private/` (never sync)

---

## Setup Guide

### Step 1: Install Node.js

```bash
# Install Node.js v22+ via Homebrew
brew install node

# Verify
node --version  # Should be v22 or higher
npm --version   # Should be v10.9.2 or higher
```

### Step 2: Set Up Quartz

```bash
# Clone Quartz
cd ~
git clone https://github.com/jackyzha0/quartz.git
cd quartz

# Install dependencies
npm i

# Initialize Quartz
npx quartz create

# When prompted:
# - "Choose how to initialize Quartz" → "Empty Quartz"
# - This gives you a clean slate to add your notes
```

### Step 3: Configure Quartz for Your Notes

Edit `quartz.config.ts`:

```typescript
const config: QuartzConfig = {
  configuration: {
    pageTitle: "🧠 My Second Brain",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "plausible", // or "google", or null
    },
    locale: "en-US",
    baseUrl: "yourusername.github.io/quartz",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "created",
    theme: {
      fontOrigin: "googleFonts",
      cdnCaching: true,
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
      Plugin.SyntaxHighlighting(),
      Plugin.ObsidianFlavoredMarkdown(),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks(),
      Plugin.Description(),
      Plugin.Latex(),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex(),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.NotFoundPage(),
    ],
  },
}
```

### Step 4: Create Sync Script

Create `~/zettelkasten/scripts/publish.sh`:

```bash
#!/bin/bash
# Syncs public notes from Zettelkasten to Quartz

set -e

ZETTEL_DIR="$HOME/zettelkasten"
QUARTZ_DIR="$HOME/quartz"
QUARTZ_CONTENT="$QUARTZ_DIR/content"

echo "🔄 Publishing Zettelkasten to Quartz..."

# Clear old content
rm -rf "$QUARTZ_CONTENT"/*

# Find all notes with 'publish: true' in frontmatter
find "$ZETTEL_DIR" -name "*.md" -type f | while read -r file; do
  # Skip template and private directories
  if [[ "$file" == *"templates"* ]] || [[ "$file" == *".private"* ]]; then
    continue
  fi

  # Check if file has 'publish: true' in frontmatter
  if grep -q "^publish: true" "$file" 2>/dev/null; then
    # Get relative path from zettelkasten root
    rel_path="${file#$ZETTEL_DIR/}"
    target="$QUARTZ_CONTENT/$rel_path"

    # Create directory structure
    mkdir -p "$(dirname "$target")"

    # Copy file
    cp "$file" "$target"
    echo "  ✅ Published: $rel_path"
  fi
done

# Copy any images/attachments
if [ -d "$ZETTEL_DIR/attachments" ]; then
  cp -r "$ZETTEL_DIR/attachments" "$QUARTZ_CONTENT/"
  echo "  📎 Copied attachments"
fi

echo ""
echo "✅ Sync complete!"
echo ""
echo "Next steps:"
echo "  cd ~/quartz"
echo "  npx quartz build --serve  # Preview locally"
echo "  npx quartz sync           # Deploy to GitHub Pages"
```

Make it executable:
```bash
chmod +x ~/zettelkasten/scripts/publish.sh
```

### Step 5: Create GitHub Repository

```bash
cd ~/quartz

# Initialize git if not already done
git init
git add .
git commit -m "Initial Quartz setup"

# Create repo on GitHub (via gh CLI)
gh repo create quartz --public --source=. --remote=origin

# Push
git push -u origin main
```

### Step 6: Configure GitHub Pages

```bash
# Quartz has built-in GitHub Actions for deployment
# Just sync once to set up GitHub Pages
cd ~/quartz
npx quartz sync --commit "Initial publish"
```

GitHub Actions will automatically:
1. Build your site
2. Deploy to GitHub Pages
3. Make it available at `yourusername.github.io/quartz`

---

## Workflow Integration

### Publishing a Note

When you finish a note and want to publish it:

1. **Add frontmatter**:
   ```markdown
   ---
   title: "Understanding TCP/IP"
   date: 2025-10-24
   tags: [public, networking, learning]
   publish: true
   ---
   ```

2. **Run publish script**:
   ```bash
   ~/zettelkasten/scripts/publish.sh
   ```

3. **Preview locally** (optional):
   ```bash
   cd ~/quartz
   npx quartz build --serve
   # Open http://localhost:8080
   ```

4. **Deploy**:
   ```bash
   npx quartz sync --commit "Published: Understanding TCP/IP"
   ```

### Neovim Integration

Add to `lua/plugins/zettelkasten.lua`:

```lua
-- Quick publish command
vim.keymap.set("n", "<leader>zp", function()
  -- Check if current file has publish: true
  local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
  local has_publish = false
  for _, line in ipairs(lines) do
    if line:match("^publish:%s*true") then
      has_publish = true
      break
    end
  end

  if not has_publish then
    print("⚠️  Note not marked for publishing (add 'publish: true' to frontmatter)")
    return
  end

  -- Run publish script
  vim.cmd("!~/zettelkasten/scripts/publish.sh")
  print("✅ Published to Quartz")
end, { desc = "Publish to Quartz" })

-- Toggle publish status
vim.keymap.set("n", "<leader>zt", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
  local in_frontmatter = false
  local has_publish = false
  local publish_line = nil

  for i, line in ipairs(lines) do
    if line == "---" then
      in_frontmatter = not in_frontmatter
    elseif in_frontmatter and line:match("^publish:") then
      has_publish = true
      publish_line = i - 1
      break
    end
  end

  if has_publish then
    -- Toggle existing publish field
    local line = lines[publish_line + 1]
    if line:match("true") then
      vim.api.nvim_buf_set_lines(0, publish_line, publish_line + 1, false, {"publish: false"})
      print("🔒 Marked as private")
    else
      vim.api.nvim_buf_set_lines(0, publish_line, publish_line + 1, false, {"publish: true"})
      print("🌍 Marked as public")
    end
  else
    -- Add publish field to frontmatter
    -- Find end of frontmatter
    local end_line = nil
    for i, line in ipairs(lines) do
      if i > 1 and line == "---" then
        end_line = i - 1
        break
      end
    end
    if end_line then
      vim.api.nvim_buf_set_lines(0, end_line, end_line, false, {"publish: true"})
      print("🌍 Marked as public")
    end
  end
end, { desc = "Toggle publish status" })
```

---

## Blog vs Zettelkasten

### Separate Blog Section

Create `~/zettelkasten/blog/` for traditional blog posts:

```markdown
---
title: "My Journey with Neovim"
date: 2025-10-24
tags: [public, blog, neovim]
publish: true
type: blog
---

This is a traditional blog post with a narrative structure...
```

In Quartz config, you can filter by type to show blogs separately from notes.

---

## Advanced Features

### Graph View

Quartz automatically creates a graph of all your notes and their connections.

### Backlinks

Every note shows what other notes link to it.

### Search

Full-text search across all published notes.

### LaTeX Support

Your LaTeX equations work perfectly:
```markdown
$$
\int_{0}^{\infty} e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

---

## Maintenance

### Daily Publishing Workflow

```bash
# After writing/updating notes
cd ~/zettelkasten
./scripts/publish.sh

# Preview changes
cd ~/quartz
npx quartz build --serve

# Deploy
npx quartz sync --commit "Daily update: $(date +%Y-%m-%d)"
```

### Automated Daily Publishing (Optional)

Create a cron job or use a GitHub Action to auto-publish daily.

---

## Privacy Checklist

Before publishing:
- [ ] Review all notes marked `publish: true`
- [ ] Check for personal info (names, emails, internal details)
- [ ] Ensure work-related notes are in `.private/`
- [ ] Remove any API keys or credentials
- [ ] Review linked notes (they'll be visible if published)

---

## Alternative: MkDocs Material

If you prefer documentation-style layout:

```bash
# Install
pip install mkdocs-material

# Create site
mkdocs new my-brain
cd my-brain

# Configure mkdocs.yml
# Add markdown files
# Deploy to GitHub Pages
```

**Quartz vs MkDocs:**
- Quartz: Better for digital garden, wiki-style notes
- MkDocs: Better for structured documentation, tutorials

For your Zettelkasten → **Quartz is better**

---

## Resources

- Quartz Docs: https://quartz.jzhao.xyz
- Example Sites: https://quartz.jzhao.xyz/showcase
- Discord: Join for support
- GitHub: https://github.com/jackyzha0/quartz

---

## Next Steps

1. Install Node.js
2. Clone and set up Quartz
3. Create publish script
4. Mark 2-3 notes as `publish: true` for testing
5. Run publish script and preview locally
6. Deploy to GitHub Pages
7. Share your digital garden! 🌱

Your Zettelkasten will become a living, breathing knowledge base that others can learn from.
