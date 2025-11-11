# image.nvim In-Buffer Rendering Fix

## Problem

When opening LaTeX equations in Kitty terminal, they didn't render as images in the buffer despite:
- ✅ Kitty terminal installed and running
- ✅ Terminal detected as `xterm-kitty`
- ✅ image.nvim plugin configured with `backend = "kitty"`
- ✅ LaTeX (`pdflatex`) and `dvisvgm` installed

## Root Cause

**Missing Dependency**: image.nvim requires **ImageMagick** for image processing and manipulation.

Initial error message: `magick rock not found` was misleading - we don't actually need the magick Lua rock!

## Solution Discovery

image.nvim supports two processors:
1. **magick_rock** - Uses FFI bindings, requires LuaRocks setup
2. **magick_cli** - Uses ImageMagick CLI, much simpler!

We switched to `magick_cli` which only requires ImageMagick installation.

## Solution (Simple!)

### Quick Setup (Automated)

Run the setup script:
```bash
cd ~/.config/nvim
./scripts/setup-latex-images.sh
```

This installs ImageMagick via Homebrew.

### Manual Setup

```bash
# Install ImageMagick (that's it!)
brew install imagemagick
```

### Configuration Update

Updated `/Users/L021136/.config/nvim/lua/plugins/latex-equations.lua:22`:
```lua
opts = {
  backend = "kitty",
  processor = "magick_cli", -- Uses CLI instead of Lua rock
  integrations = {
    -- ... rest of config
  },
}
```

### After Installation

1. Restart Neovim
2. Run `:Lazy sync` to ensure plugin is updated
3. Open a markdown file with LaTeX equations in Kitty
4. Equations should now render as images inline

## How It Works

The rendering pipeline:
```
LaTeX source → pdflatex → PDF → dvisvgm/ImageMagick → PNG/SVG →
magick Lua rock → image.nvim → Kitty graphics protocol → Terminal display
```

## Testing

### Test 1: Verify ImageMagick

```bash
# Check ImageMagick installation
magick --version
# Should show: Version: ImageMagick 7.1.2-7 or similar
```

### Test 2: Simple Image

Create `test-image.md`:
```markdown
![Test](https://via.placeholder.com/150)
```

The image should render inline in Kitty.

### Test 3: LaTeX Equation

Create equation in markdown:
```markdown
$$
\int_{0}^{\infty} e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
$$
```

Should render as a properly typeset equation image.

## Troubleshooting

### Plugin Not Loading

```vim
:Lazy
```
Find "3rd/image.nvim" and check status. Click to see logs.

### Check for Errors

```vim
:messages
```
Look for image.nvim or magick-related errors.

### Verify Kitty Graphics

Test Kitty's image protocol directly:
```bash
kitty +kitten icat /path/to/image.png
```

### Health Check

```vim
:checkhealth image
```

## Alternative: Browser Preview

If in-buffer rendering proves problematic, you already have a working solution:
- `<leader>mp` - Opens markdown preview in browser
- Full KaTeX and mhchem support
- Perfect rendering of complex equations and chemistry
- No additional setup needed

## Files Modified

1. **Created**: `LATEX_IMAGE_SETUP.md` - Detailed setup guide
2. **Created**: `scripts/setup-latex-images.sh` - Automated installation
3. **Updated**: `lua/plugins/latex-equations.lua` - Added processor config
4. **Updated**: `EQUATION_WORKFLOW.md` - Added setup instructions
5. **Created**: `IMAGE_NVIM_FIX.md` - This document

## Key Learnings

1. **Kitty alone is not enough** - Even with Kitty's graphics protocol, image.nvim needs ImageMagick to process images
2. **magick_cli vs magick_rock** - The CLI processor is much simpler and sufficient for most use cases
3. **Error messages can be misleading** - "magick rock not found" led us down the wrong path initially
4. **Multiple rendering options** - Browser preview, in-buffer images, and text rendering each serve different use cases
5. **Keep it simple** - Don't over-engineer dependencies when a simpler solution works

## References

- [image.nvim GitHub](https://github.com/3rd/image.nvim)
- [ImageMagick](https://imagemagick.org/)
- [LuaRocks](https://luarocks.org/)
- [Kitty Graphics Protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/)
