# Publishing Quick Start Guide
## Get Your Digital Garden Live in 30 Minutes

**Goal:** Publish your Zettelkasten, tools, and blog to GitHub Pages using Quartz.

---

## Prerequisites Check

```bash
# Check Node.js (need v22+)
node --version

# If not installed or old version:
brew install node

# Check gh CLI
gh --version

# If not installed:
brew install gh
gh auth login
```

---

## Step-by-Step Setup

### 1. Set Up Quartz (10 min)

```bash
# Create digital garden directory
cd ~
mkdir digital-garden
cd digital-garden

# Clone Quartz
git clone https://github.com/jackyzha0/quartz.git
cd quartz

# Install dependencies (this takes a few minutes)
npm i

# Initialize Quartz
npx quartz create
# Choose: "Empty Quartz" when prompted

# Go back to garden root
cd ..
```

### 2. Create Directory Structure (2 min)

```bash
cd ~/digital-garden

# Create content and scripts directories
mkdir -p content
mkdir -p scripts

# Create basic landing page
cat > content/index.md <<'EOF'
---
title: "Welcome to My Digital Garden"
---

# 👋 Welcome

This is my digital garden - a living collection of my knowledge, tools, and learning journey.

## Explore

- [[brain/index|🧠 Knowledge Base]] - My Zettelkasten notes
- [[blog/index|📝 Blog]] - Essays and tutorials
- [[tools/index|🛠️ Tools]] - My development setup
- [[journey/index|📚 Learning Journey]] - DDRs and reflections

---

*This site is built with [Quartz](https://quartz.jzhao.xyz) and published from markdown notes.*
EOF
```

### 3. Create Aggregation Script (5 min)

Copy the aggregation script from `COMPREHENSIVE_PUBLISHING.md` to `~/digital-garden/scripts/aggregate-content.sh`.

Or create a simple starter version:

```bash
cat > ~/digital-garden/scripts/aggregate-content.sh <<'SCRIPT'
#!/bin/bash
# Simple content aggregation for digital garden

set -e

GARDEN_ROOT="$HOME/digital-garden"
CONTENT_DIR="$GARDEN_ROOT/content"
ZETTEL_DIR="$HOME/zettelkasten"
NVIM_DIR="$HOME/.config/nvim"

echo "🌱 Building Digital Garden..."

# Clean old content (except index)
find "$CONTENT_DIR" -mindepth 1 ! -name 'index.md' -exec rm -rf {} + 2>/dev/null || true

# Create directories
mkdir -p "$CONTENT_DIR/brain"
mkdir -p "$CONTENT_DIR/blog"
mkdir -p "$CONTENT_DIR/tools"
mkdir -p "$CONTENT_DIR/journey"

# 1. Zettelkasten notes with publish: true
echo "🧠 Collecting knowledge base..."
find "$ZETTEL_DIR" -name "*.md" -type f | while read -r file; do
  # Skip templates and private
  [[ "$file" == *"template"* ]] && continue
  [[ "$file" == *"private"* ]] && continue

  # Check for publish: true
  if grep -q "^publish: true" "$file" 2>/dev/null; then
    rel_path="${file#$ZETTEL_DIR/}"
    target="$CONTENT_DIR/brain/$rel_path"
    mkdir -p "$(dirname "$target")"
    cp "$file" "$target"
    echo "  ✅ $(basename "$file")"
  fi
done

# 2. Workflow docs
echo "🛠️ Collecting tools & workflows..."
for doc in DEVELOPMENT_ALGORITHM.md MASTER_WORKFLOW.md ZETTELKASTEN_WORKFLOW.md; do
  if [ -f "$NVIM_DIR/$doc" ]; then
    cp "$NVIM_DIR/$doc" "$CONTENT_DIR/tools/"
    echo "  ✅ $doc"
  fi
done

# 3. Learning journey (fixes, DDRs)
echo "📚 Collecting learning journey..."
for doc in *FIX*.md *SOLUTION*.md; do
  if [ -f "$NVIM_DIR/$doc" ]; then
    cp "$NVIM_DIR/$doc" "$CONTENT_DIR/journey/"
    echo "  ✅ $doc"
  fi
done 2>/dev/null

# 4. Images
if [ -d "$ZETTEL_DIR/images" ]; then
  cp -r "$ZETTEL_DIR/images" "$CONTENT_DIR/"
  echo "📎 Images copied"
fi

echo ""
echo "✅ Content aggregation complete!"
echo ""
echo "Next: cd ~/digital-garden/quartz && npx quartz build --serve"
SCRIPT

chmod +x ~/digital-garden/scripts/aggregate-content.sh
```

### 4. Test Aggregation (2 min)

```bash
# Run the script
~/digital-garden/scripts/aggregate-content.sh

# Check what was copied
ls -R ~/digital-garden/content/
```

### 5. Configure Quartz (3 min)

Edit `~/digital-garden/quartz/quartz.config.ts`:

```bash
cd ~/digital-garden/quartz
```

Find these lines and update:
- `pageTitle:` → Your name
- `baseUrl:` → `"yourusername.github.io"` (your actual GitHub username)

### 6. Preview Locally (2 min)

```bash
cd ~/digital-garden/quartz
npx quartz build --serve
```

Visit http://localhost:8080 to see your garden!

Press Ctrl+C to stop when done.

### 7. Deploy to GitHub Pages (5 min)

```bash
cd ~/digital-garden

# Initialize git
git init
git add .
git commit -m "Initial digital garden setup"

# Create GitHub repository
gh repo create digital-garden --public --source=. --remote=origin --push

# Deploy
cd quartz
npx quartz sync --commit "Initial publish"
```

GitHub Actions will build and deploy automatically (takes 2-3 minutes).

Your site will be live at: `https://yourusername.github.io/digital-garden`

---

## Daily Workflow

### Mark a Note for Publishing

Add frontmatter to any note:

```markdown
---
title: "My Awesome Note"
date: 2025-10-24
type: permanent-note
tags: [public, topic]
publish: true
---

# My Awesome Note

Content here...
```

### Publish Updates

```bash
# 1. Aggregate content
~/digital-garden/scripts/aggregate-content.sh

# 2. Preview (optional)
cd ~/digital-garden/quartz && npx quartz build --serve

# 3. Deploy
cd ~/digital-garden/quartz && npx quartz sync --commit "Update: $(date +%Y-%m-%d)"
```

---

## Neovim Integration (Optional)

Add to `lua/plugins/zettelkasten.lua`:

```lua
-- Quick publish command
vim.keymap.set("n", "<leader>zP", function()
  vim.cmd("!~/digital-garden/scripts/aggregate-content.sh")
  print("✅ Content aggregated. Run deploy to publish.")
end, { desc = "Aggregate Digital Garden" })

-- Quick deploy
vim.keymap.set("n", "<leader>zD", function()
  local cmd = "!~/digital-garden/scripts/aggregate-content.sh && " ..
              "cd ~/digital-garden/quartz && " ..
              "npx quartz sync --commit 'Update: $(date +%Y-%m-%d)'"
  vim.cmd(cmd)
end, { desc = "Deploy Digital Garden" })
```

Restart Neovim, then:
- `<leader>zP` - Aggregate content
- `<leader>zD` - Deploy to GitHub Pages

---

## What to Publish First

Start small! Mark these for publishing:

1. **3 Permanent Notes** - Your best evergreen knowledge
2. **1 Blog Post** - "Why I Built This Garden" or "My Setup"
3. **1 Workflow Doc** - Your Development Algorithm
4. **1 Fix Story** - Recent problem you solved

Run the aggregation script and deploy. That's your v1!

---

## Troubleshooting

### "node: command not found"
```bash
brew install node
```

### "npx: command not found"
```bash
npm install -g npx
```

### Quartz build fails
```bash
cd ~/digital-garden/quartz
rm -rf node_modules package-lock.json
npm install
```

### No content showing
- Check frontmatter has `publish: true`
- Check file paths in aggregation script
- Run aggregation script and check `~/digital-garden/content/`

---

## Next Steps

1. **Mark notes as public** - Add `publish: true` to 5-10 notes
2. **Run aggregation** - `~/digital-garden/scripts/aggregate-content.sh`
3. **Preview** - Check http://localhost:8080
4. **Deploy** - `cd ~/digital-garden/quartz && npx quartz sync`
5. **Share** - Tweet/post your garden URL!

---

## Resources

- Full guide: `COMPREHENSIVE_PUBLISHING.md`
- Quartz docs: https://quartz.jzhao.xyz
- Your garden: `https://yourusername.github.io/digital-garden`

**You're ready to grow your digital garden! 🌱**

Start with: `~/digital-garden/scripts/aggregate-content.sh`
