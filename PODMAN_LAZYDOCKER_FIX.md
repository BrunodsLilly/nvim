# LazyDocker with Podman Configuration

## Issue
LazyDocker was failing with "docker command not found" because you use Podman instead of Docker. Shell aliases (docker=podman) don't work within Neovim's subprocess environment.

## Solution
Updated the LazyDocker configuration to automatically create a temporary docker->podman wrapper when launching LazyDocker. This makes LazyDocker think it's using Docker while actually using Podman.

## How It Works
When you press `<leader>gD`:

1. **Creates a wrapper script** that redirects docker commands to podman
2. **Sets up a temporary PATH** with the docker wrapper
3. **Launches LazyDocker** with the modified environment
4. **Cleans up** automatically when LazyDocker closes

## Testing Instructions

1. **Restart Neovim** to load the new configuration
   ```bash
   # Exit and restart Neovim
   ```

2. **Test LazyDocker**:
   - Press `<leader>gD` (usually `<Space>gD`)
   - LazyDocker should now open and show your Podman containers
   - Navigate with arrow keys
   - Press `q` to quit

## Verifying It Works

You should see:
- Your Podman containers listed
- Images, volumes, and networks from Podman
- All operations working through Podman backend

## Troubleshooting

If it still doesn't work:

1. **Check Podman is running**:
   ```bash
   podman ps
   ```

2. **Start Podman machine if needed** (macOS):
   ```bash
   podman machine start
   ```

3. **Check Podman socket** (for rootless mode):
   ```bash
   podman system service --time=0 &
   ```

4. **Alternative: Use Podman's Docker compatibility**:
   If you want a system-wide solution, you can install podman-docker:
   ```bash
   # This creates system-wide docker -> podman symlinks
   brew install podman-docker
   ```

## Known Limitations

- Some Docker-specific features might not work with Podman
- Podman in rootless mode has different networking behavior
- Docker Compose commands require podman-compose

## Benefits of This Approach

- No system-wide changes needed
- Works only within Neovim/LazyDocker
- Automatically cleans up after use
- Doesn't interfere with other tools

## Status: FIXED
The configuration now automatically handles the Docker->Podman translation when launching LazyDocker from Neovim.