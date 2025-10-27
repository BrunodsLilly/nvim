#!/bin/bash

echo "🔧 Fixing markdown-preview.nvim installation..."

# Navigate to the plugin directory
PLUGIN_DIR="$HOME/.local/share/nvim/lazy/markdown-preview.nvim"

if [ ! -d "$PLUGIN_DIR" ]; then
    echo "❌ markdown-preview.nvim not found in lazy plugin directory"
    echo "Please run :Lazy sync in Neovim first"
    exit 1
fi

cd "$PLUGIN_DIR"

echo "📦 Installing dependencies..."

# Install the app dependencies
cd app

# Clean any existing installation
rm -rf node_modules package-lock.json

# Install fresh dependencies
npm install

if [ $? -eq 0 ]; then
    echo "✅ markdown-preview.nvim dependencies installed successfully!"
    echo ""
    echo "🚀 Next steps:"
    echo "1. Restart Neovim"
    echo "2. Open a markdown file"
    echo "3. Press <leader>mp to toggle preview"
else
    echo "❌ Failed to install dependencies"
    echo "Try manually running:"
    echo "  cd $PLUGIN_DIR/app"
    echo "  npm install"
fi