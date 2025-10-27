# LaTeX In-Buffer Image Rendering Setup

This guide helps you set up in-buffer LaTeX equation rendering using image.nvim with Kitty terminal.

## Solution Summary

image.nvim requires **ImageMagick** to process and render images. We use the `magick_cli` processor which is simpler and doesn't require LuaRocks.

## Quick Setup (Automated)

```bash
cd ~/.config/nvim
./scripts/setup-latex-images.sh
```

This will install ImageMagick via Homebrew.

## Manual Installation

### 1. Install ImageMagick

```bash
brew install imagemagick
```

Verify installation:
```bash
magick --version
```

### 2. Configuration (Already Done)

The configuration in `lua/plugins/latex-equations.lua` uses `magick_cli`:

```lua
opts = {
  backend = "kitty",
  processor = "magick_cli", -- Uses ImageMagick CLI (simpler, no LuaRocks needed)
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" },
    },
  },
  -- ... rest of config
},
```

### 3. Restart Neovim and Sync Plugins

```vim
:Lazy sync
:qa
```

Then reopen Neovim in Kitty terminal.

## Testing

### Test 1: Simple Image

Create a test markdown file and add a web image:

```markdown
![Test Image](https://via.placeholder.com/150)
```

The image should render inline in your buffer.

### Test 2: LaTeX Equation

Open your test file with LaTeX:

```markdown
$$
\int_{a}^{b} f(x) \, dx
$$
```

The equation should be converted to an image and displayed inline.

## Troubleshooting

### Check Plugin Status
```vim
:Lazy
```
Find "3rd/image.nvim" and verify it's loaded.

### Check for Errors
```vim
:messages
```
Look for any image.nvim or magick-related errors.

### Verify Kitty Graphics Protocol

Test if Kitty can display images at all:
```bash
kitty +kitten icat /path/to/some/image.png
```

### Check Image.nvim Health
After installing dependencies, run:
```vim
:checkhealth image
```

## How It Works

1. **Markdown with LaTeX**: You write LaTeX in markdown files
2. **LaTeX → PDF**: `pdflatex` converts LaTeX to PDF
3. **PDF → SVG**: `dvisvgm` or ImageMagick converts to SVG/PNG
4. **ImageMagick Processing**: The `magick` Lua rock processes the image
5. **Kitty Graphics Protocol**: Renders the image directly in terminal buffer

## Alternative: Browser-Only Preview

If in-buffer rendering proves problematic, you can stick with browser preview:
- `<leader>mp` - Opens markdown preview in browser with full KaTeX support
- Works perfectly for complex equations and chemistry
- No additional dependencies needed beyond what's already installed

## Dependencies Summary

| Dependency | Status | Purpose |
|------------|--------|---------|
| Kitty terminal | ✅ Installed | Graphics protocol backend |
| pdflatex | ✅ Installed | LaTeX compilation |
| dvisvgm | ✅ Installed | PDF to SVG conversion |
| ImageMagick | ✅ Installed | Image processing |

## Processor Options

image.nvim supports two processors:

1. **magick_cli** (USED - Simpler)
   - Uses ImageMagick's command-line tools
   - Only requires ImageMagick installation
   - Slightly less performance but easier setup
   - **This is what we use**

2. **magick_rock** (Alternative - More complex)
   - Uses FFI bindings via magick Lua rock
   - Requires LuaRocks + building the magick rock
   - Slightly better performance
   - More complex setup - not needed for our use case
