# "magick rock not found" - Solution

## The Problem

When trying to use image.nvim for in-buffer LaTeX equation rendering, you got the error:
```
from image.nvim: magick rock not found
```

## The Cause

The error message was **misleading**! It suggested you needed the "magick Lua rock", which would require:
- Installing LuaRocks
- Building and installing the magick Lua rock
- Complex setup

## The ACTUAL Solution

image.nvim supports **two processors**:

1. `processor = "magick_rock"` - Complex, requires Lua rocks
2. `processor = "magick_cli"` - Simple, only needs ImageMagick

**We just needed to:**
1. Switch to `magick_cli` processor
2. Install ImageMagick

That's it!

## What We Did

### 1. Updated Configuration
Changed `lua/plugins/latex-equations.lua:22`:
```lua
processor = "magick_cli",  -- Instead of "magick_rock"
```

### 2. Installed ImageMagick
```bash
brew install imagemagick
```

### 3. Created Setup Script
Made `scripts/setup-latex-images.sh` for easy one-command setup:
```bash
cd ~/.config/nvim
./scripts/setup-latex-images.sh
```

## Next Steps for You

**You're ready to go!** Just:

1. **Restart Neovim** and run:
   ```vim
   :Lazy sync
   ```

2. **Open a markdown file** with LaTeX in Kitty terminal:
   ```markdown
   $$
   \int_{0}^{\infty} e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
   $$
   ```

3. **The equation should render as an image** directly in your buffer!

## Verification

Check that ImageMagick is installed:
```bash
magick --version
# Should output: Version: ImageMagick 7.1.2-7 Q16-HDRI aarch64...
```

## Troubleshooting

If it still doesn't work after restarting Neovim:

1. Check plugin loaded:
   ```vim
   :Lazy
   ```
   Find "3rd/image.nvim" and verify it's loaded

2. Check for errors:
   ```vim
   :messages
   ```

3. Verify Kitty graphics:
   ```bash
   kitty +kitten icat /path/to/some/image.png
   ```

## Key Takeaway

**Don't let error messages send you down rabbit holes!**

The "magick rock not found" error made it seem like we needed complex Lua rock setup, when we actually just needed:
- ImageMagick (simple brew install)
- Use `magick_cli` instead of `magick_rock`

Sometimes the simpler solution is the right solution.

## Files Modified

1. `lua/plugins/latex-equations.lua` - Changed processor to `magick_cli`
2. `scripts/setup-latex-images.sh` - Simplified to only install ImageMagick
3. Updated docs: `LATEX_IMAGE_SETUP.md`, `IMAGE_NVIM_FIX.md`

## Current Status

✅ ImageMagick installed
✅ Configuration updated to use `magick_cli`
✅ Setup script created
✅ Documentation updated
⏳ Awaiting Neovim restart + `:Lazy sync` to test

Enjoy your in-buffer LaTeX equation rendering! 🎉
