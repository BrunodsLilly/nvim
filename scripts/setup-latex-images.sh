#!/bin/bash
# Setup script for image.nvim in-buffer LaTeX rendering
# Requires: Kitty terminal, Homebrew

set -e

echo "🔧 Setting up in-buffer LaTeX image rendering..."
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS. Please install ImageMagick manually."
    exit 1
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Install from https://brew.sh"
    exit 1
fi

# Install ImageMagick (that's all we need!)
echo "📦 Installing ImageMagick..."
if command -v magick &> /dev/null; then
    echo "✅ ImageMagick already installed: $(magick --version | head -n1)"
else
    echo "Installing ImageMagick via Homebrew..."
    brew install imagemagick
    echo "✅ ImageMagick installed"
fi

echo ""
echo "✅ Setup complete! ImageMagick installed."
echo ""
echo "Next steps:"
echo "1. Restart Neovim and run: :Lazy sync"
echo "2. Open a markdown file in Kitty terminal"
echo "3. Add a LaTeX equation and it should render inline!"
echo ""
echo "Test with this markdown:"
echo '```markdown'
echo '$$'
echo '\int_{0}^{\infty} e^{-x^2} dx = \frac{\sqrt{\pi}}{2}'
echo '$$'
echo '```'
echo ""
echo "Note: We're using magick_cli processor (simpler, no LuaRocks needed)"
echo "Troubleshooting: See LATEX_IMAGE_SETUP.md for more details"
