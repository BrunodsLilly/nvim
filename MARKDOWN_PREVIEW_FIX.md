# Markdown Rendering & Preview Guide

## Current Setup
Using `render-markdown.nvim` for beautiful in-buffer markdown rendering with Obsidian-like appearance.

## The Original Issue
`markdown-preview.nvim` failed to build with error: `E117: Unknown function: mkdp#util#install`

## Solutions

### Solution 1: render-markdown.nvim (RECOMMENDED - Now Active) ✅

1. **Update the plugin configuration** ✅ (Already done)
   - Changed build command to `"cd app && npm install"`
   - Added proper configuration

2. **Run the fix script**:
   ```bash
   ~/.config/nvim/scripts/fix-markdown-preview.sh
   ```

3. **Manual fix if script fails**:
   ```bash
   cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app
   npm install
   ```

4. **In Neovim**:
   ```vim
   :Lazy sync
   :Lazy build markdown-preview.nvim
   ```

5. **Test it**:
   - Open any markdown file
   - Press `<leader>mp` to toggle preview

### Solution 1: render-markdown.nvim (RECOMMENDED - Now Active) ✅

Beautiful in-buffer markdown rendering that makes your markdown files look amazing while editing:

1. **Already configured** in `markdown-preview-alternative.lua`

2. **Usage**:
   ```vim
   <leader>mr  " Toggle markdown rendering on/off
   :RenderMarkdown toggle   " Alternative command
   ```

3. **Features**:
   - **Obsidian-like rendering** - Beautiful headers, bullets, checkboxes
   - **Code block styling** - Syntax highlighting with borders
   - **Wiki-link support** - Perfect for Zettelkasten
   - **Callout blocks** - NOTE, TIP, WARNING, etc.
   - **Tables** - Properly formatted tables
   - **Checkboxes** - Visual checkboxes with custom states
   - **No external dependencies** - Pure Neovim rendering

4. **Advantages**:
   - Works directly in your buffer (no preview window)
   - Real-time rendering as you type
   - Preserves your ability to edit
   - Beautiful and customizable
   - Perfect for note-taking and documentation

### Solution 3: Install Both for Flexibility

Keep both options available:

```vim
<leader>mp  " Browser preview (markdown-preview.nvim)
<leader>mg  " Terminal preview (Glow)
```

## Testing Your Markdown Preview

1. **Create a test file**:
   ```bash
   nvim ~/test-preview.md
   ```

2. **Add test content**:
   ```markdown
   # Test Markdown Preview

   ## Features to Test

   - **Bold text**
   - *Italic text*
   - `Code inline`

   ```python
   def hello():
       print("Code block")
   ```

   > Blockquote test

   | Table | Test |
   |-------|------|
   | Cell  | Data |
   ```

3. **Test preview**:
   - Press `<leader>mg` for Glow (should work immediately)
   - Press `<leader>mp` for browser preview (after fixing)

## Troubleshooting

### If markdown-preview.nvim still doesn't work:

1. **Check Node.js availability in Neovim**:
   ```vim
   :echo executable('node')
   " Should return 1
   ```

2. **Check the plugin installation**:
   ```vim
   :echo isdirectory(expand('~/.local/share/nvim/lazy/markdown-preview.nvim'))
   " Should return 1
   ```

3. **Force rebuild**:
   ```vim
   :Lazy clean
   :Lazy sync
   ```

4. **Check for errors**:
   ```vim
   :messages
   :checkhealth
   ```

### If Glow doesn't work:

1. **Verify glow installation**:
   ```bash
   glow --version
   ```

2. **Test glow directly**:
   ```bash
   glow README.md
   ```

3. **Check plugin loading**:
   ```vim
   :Lazy
   " Look for glow.nvim in the list
   ```

## Recommended Setup

Use **render-markdown.nvim** for the best markdown experience:

1. **Beautiful in-buffer rendering** - See formatted markdown while editing
2. **No external dependencies** - Pure Neovim solution
3. **Perfect for note-taking** - Ideal for Zettelkasten and documentation
4. **Obsidian-like appearance** - Modern and clean
5. **Wiki-link support** - Great for connected notes

## Quick Reference

| Action | Command | Description |
|--------|---------|-------------|
| Toggle Rendering | `<leader>mr` | Turn markdown rendering on/off |
| Browser Preview | `<leader>mp` | Preview in browser (if fixed) |
| Force Enable | `:RenderMarkdown enable` | Enable rendering |
| Force Disable | `:RenderMarkdown disable` | Disable rendering |

## Special Markdown Features

### Callout Blocks
```markdown
> [!NOTE]
> This is a note callout

> [!TIP]
> This is a tip callout

> [!WARNING]
> This is a warning callout

> [!IMPORTANT]
> This is an important callout
```

### Enhanced Checkboxes
```markdown
- [ ] Unchecked task
- [x] Completed task
- [-] In progress task
- [!] Important task
- [?] Question task
```

### Wiki Links (Zettelkasten)
```markdown
[[link-to-another-note]]
[[folder/note-with-path]]
```

## Your Current Status

- ✅ render-markdown.nvim is configured and working
- ✅ Beautiful in-buffer markdown rendering
- ⚠️  markdown-preview.nvim needs the fix script for browser preview
- ✅ You can toggle rendering with `<leader>mr` right now!

## Action Items

1. **Immediate**: Use `<leader>mr` to toggle beautiful markdown rendering
2. **Optional**: Run fix script for browser-based preview if needed
3. **Enjoy**: Your markdown files now look amazing while editing!

---

*Last Updated: 2024*
*Status: render-markdown.nvim working beautifully, browser preview optional*