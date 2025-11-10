# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an advanced Neovim configuration implementing a comprehensive developer productivity system combining:
- **7-Stage Development Algorithm** with TDD and Git archaeology
- **Zettelkasten knowledge management** with spaced repetition for learning capture and pattern extraction
- **Digital Garden publishing** system for knowledge sharing
- **Extensive automation** via 200+ custom keymaps and workflows

The configuration emphasizes learning from code history, systematic problem-solving, and knowledge compounding through deliberate practice. It integrates Claude AI pair programming, automated testing, and a personal knowledge base.

## Critical Commands for Development

### Core Navigation & Workflow

```vim
" Essential workflow commands
<leader>gg          " LazyGit - Check git status/branch
:TodoWrite          " Create/manage task breakdown
<leader>qf          " Send diagnostics to quickfix
<leader>cf          " Format code and organize imports
<leader>cF          " Format only (no import organization)
-                   " Oil file explorer (parent directory)
```

### Development Algorithm Commands

```vim
" Algorithm documentation & automation
<leader>Dd          " Open Development Algorithm guide
<leader>Dq          " Quick Reference sheet
<leader>DD          " Create Dual Documentation (DDR + Zettel in split view)
<leader>Dr          " Dual Documentation guide
<leader>Dj          " Open Today's Journal

" Test automation (automatically detects filetype)
<leader>Dtr         " Run test for current file (Python: pytest, Java: javac+run)
<leader>Dtw         " Watch test for current file (Python: pytest-watch, Java: not impl)
<leader>Dta         " Run all tests (Python: pytest, Java: compile all .java files)
<leader>Dtc         " Coverage/timing (Python: pytest --cov, Java: time java)

" Git flow automation
<leader>Dgn         " Create new feature branch (prompts for name)
<leader>Dgc         " Conventional commit helper (type + scope + message)
<leader>Dgp         " Push current branch with -u flag
<leader>Dgpr        " Create PR via GitHub CLI

" Metrics & productivity tracking
<leader>Dmt         " Toggle task timer (counts session time)
```

### Git Archaeology (Investigating Code History)

```vim
" Essential git investigation
<leader>gb          " Toggle inline git blame (see who/when/why)
<leader>gB          " Full blame popup with commit details
<leader>gF          " Pickaxe: Find when code was added/removed (search history)
<leader>gbi         " Interactive bisect to find bug-introducing commit

" Advanced git investigation
<leader>gfa         " Show file contributors (find code experts)
<leader>gfF         " Follow file through git history and renames
<leader>gfm         " Search in commit messages
<leader>gft         " Show commits since specific date
<leader>gfr         " Blame selected lines (visual mode)
<leader>gfh         " Show file at specific commit
<leader>gfR         " Show reflog (all recent HEAD changes)
<leader>gfM         " Compare current branch with main
```

### Knowledge Capture & Management (Zettelkasten)

```vim
" Note creation & linking
<leader>zd          " Daily note (private journal, never published)
<leader>zn          " New fleeting note (quick capture, inbox)
<leader>zg          " Git discovery note (document code investigations)
<leader>zD          " Public reflection (sharable learning, publish: true)
<leader>zz          " Follow wiki-link [[like-this]]

" Word-to-link operations (on word under cursor)
<leader>zL          " Convert word → [[wiki-link]]
<leader>zZ          " Convert word → [[wiki-link]] & create note immediately

" Spaced repetition system (learn efficiently)
<leader>zI          " Initialize note for spaced repetition tracking
<leader>zr          " Mark note as reviewed (updates Fibonacci interval)
<leader>zR          " Show notes due for review today
```

### Todo Management

```vim
" Central task management
<leader>td          " Open central TODO.md in current window
<leader>tD          " Open TODO.md in vertical split
<leader>tt          " Quick add task to TODO.md (dialog)
<leader>tm          " Show sprint metrics in floating window
```

### Publishing & Sharing

```vim
" Knowledge publication pipeline
<leader>pp          " Full publish: Aggregate + Build + Preview locally
<leader>pa          " Aggregate publish: true notes to digital-garden/
<leader>pb          " Build & serve locally (Quartz SSG)
<leader>pc          " Check what will be published (show publish: true notes)
<leader>pd          " Deploy to GitHub Pages (push to production)
```

### Debugging & Testing

```vim
" Python debugging with DAP
<leader>dpt         " Debug pytest test under cursor
<leader>db          " Toggle breakpoint at cursor
<leader>dB          " Breakpoint with log message
<leader>dc          " Continue execution (resume)
<leader>du          " Toggle DAP UI (side panel)
<leader>dL          " List all breakpoints
<leader>dC          " Clear all breakpoints

" Python test-specific debugging
<leader>dpc         " Debug from console (interactive pdb)
<leader>dpf         " Debug and run to failure (stop on first assertion)
<leader>dpp         " Debug pytest in debug mode
<leader>dpb         " Toggle break-on-failure (stop at first error)
```

### Diagnostics & Code Intelligence

```vim
" Diagnostic navigation & display
<leader>xx          " Toggle all diagnostics (Trouble.nvim)
<leader>xd          " Show buffer diagnostics only
<leader>xs          " Symbol browser (functions, classes, variables)
<leader>xl          " LSP references (where this is used)
<leader>qf          " Send diagnostics to quickfix list
]d / [d             " Jump to next/previous diagnostic
```

### Task Runner (Overseer - Build/Test Automation)

```vim
" Task execution & management
<leader>oo          " Toggle task runner panel
<leader>or          " Run selected task
<leader>oq          " Quick action menu
<leader>oi          " Show task info
```

### Focus & UI Modes

```vim
" Zen mode & focus features
<leader>uz          " Toggle Zen mode (minimal UI, centered text)
<leader>uZ          " Toggle Zoom on current window
<M-k> / <M-j>       " Navigate quickfix list (previous/next)
<M-c>               " Close quickfix
```

## High-Level Architecture

### Knowledge-Driven Development System

The configuration implements a complete learning and development system:

```
┌─────────────────────────────────────────────────────┐
│                Development Algorithm                 │
│  Stage 0: UNDERSTAND (with Git Archaeology)         │
│  Stage 1: SETUP → 2: TEST → 3: IMPLEMENT           │
│  Stage 4: REFACTOR → 5: COMMIT → 6: INTEGRATE      │
│  Stage 7: LEARN (extract to Zettelkasten)          │
└─────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────┐
│              Zettelkasten + Spaced Rep              │
│  Fleeting → Permanent → Review (Fibonacci spacing)  │
│  Quick capture → Distill → Remember                │
└─────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────┐
│                  Digital Garden                      │
│  Aggregate (publish: true) → Build → Deploy         │
│  Private knowledge → Public sharing                 │
└─────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **Dual LSP Strategy**: Python uses Ruff (fast linting/import org) + basedpyright (type checking)
2. **Git-First Learning**: Every code investigation starts with git history (15+ archaeology commands)
3. **Privacy-By-Default**: All notes have `publish: false` unless explicitly marked for sharing
4. **Modular Plugin System**: 34 plugins in separate files under `lua/plugins/` for easy maintenance
5. **Session Persistence**: Automatic workspace restoration (remember last buffer, cursor position)
6. **Spaced Repetition**: Fibonacci-based review intervals (1, 2, 4, 8, 16, 32, 64, 128 days) for learning
7. **Modern Completion**: Rust-based blink.cmp with fuzzy matching and snippet integration

### Directory Structure Impact

```
~/.config/nvim/
├── lua/
│   ├── config/              # Bootstrap & utilities
│   │   ├── lazy.lua         # Lazy.nvim loader
│   │   ├── diagnostics.lua  # Quickfix filtering
│   │   └── dap-pytest-pdb.lua # Debug configuration
│   └── plugins/             # 34 plugin configurations
│       ├── git.lua          # Git archaeology (15+ commands)
│       ├── zettelkasten.lua # Notes + spaced rep system
│       ├── publishing.lua   # Digital garden pipeline
│       ├── development-algorithm.lua # DDR, test automation
│       ├── lsp.lua          # Language servers (Python/Go/TS/etc)
│       ├── dap.lua          # Debugging with pytest integration
│       └── [30+ others]     # Treesitter, completion, UI, etc
├── after/ftplugin/          # Language-specific settings
│   ├── python.lua           # 4-space indents, Ruff + basedpyright
│   ├── go.lua               # Actual tabs, gopls
│   ├── typescript.lua       # 2-space indents, ts_ls
│   └── [more languages]
└── init.lua                 # Core config, keymaps, vim settings

~/zettelkasten/             # Knowledge base (mostly private)
├── daily/                  # Daily notes (never published)
├── fleeting/               # Quick captures (inbox)
├── permanent/              # Atomic insights (selectively published)
├── projects/               # Active work documentation
├── git-discoveries/        # Git archaeology findings
├── reflections/            # Public learning (publish: true by default)
└── templates/              # Note templates with frontmatter

~/digital-garden/           # Public website
├── quartz/                 # Static site generator
│   └── content/            # Aggregated public notes (auto-sync)
└── scripts/
    └── aggregate-content.sh # Copies publish: true notes to Quartz
```

## Development Workflows

### Workflow 1: Bug Investigation with Git Archaeology

```vim
" 1. Find when bug was introduced
<leader>gbi         " Start interactive bisect
" Git walks you through commits: mark good/bad
" Automatically finds exact breaking commit

" 2. Understand the change
<leader>gB          " Full blame popup on problematic line
" Shows author, date, commit message, full context
<leader>gfM         " Compare with main to see what diverged

" 3. Investigate the commit
<leader>gfh         " Show file content at specific commit
<leader>gfF         " Follow file through renames (historical context)

" 4. Document discovery
<leader>zg          " Create git discovery note
" Automatically includes investigation context
" Title: "Bug: Authentication fails after refactoring"

" 5. Extract learning
<leader>zn          " Create permanent note if pattern applies
" Title: "Pattern: Middleware ordering matters"
<leader>zI          " Mark for spaced repetition review
```

### Workflow 2: Learning from Expert Code

```vim
" 1. Find who knows this code best
<leader>gfa         " Show file contributors with commit counts

" 2. Study their evolution
<leader>gfF         " Follow file through renames
<leader>gfm         " Search in commit messages for intent
<leader>gft         " Filter commits by date

" 3. Search for patterns
<leader>gF          " Pickaxe: Find when pattern was added/removed
" Enter search term (e.g., "FactoryPattern", "decorator", "middleware")

" 4. Capture learnings
<leader>zn          " Create permanent note with pattern insights
<leader>zL          " Convert key terms to wiki-links
<leader>zI          " Mark for spaced repetition (learn it)

" 5. Review periodically
<leader>zR          " Show notes due for review today
<leader>zr          " Mark reviewed (updates Fibonacci interval)
```

### Workflow 3: TDD with Knowledge Capture

```vim
" Stage 0: UNDERSTAND
<leader>Dq          " Review Quick Reference
<leader>zn          " Capture requirements as fleeting note
<leader>gF          " Search for similar implementations

" Stage 1: SETUP
:TodoWrite          " Create task breakdown

" Stage 2: TEST-FIRST
<leader>Dtr         " Run test for current file
<leader>db          " Set breakpoint if debugging
<leader>dpt         " Debug specific test

" Stage 3: IMPLEMENT
<leader>cf          " Format & organize imports
<leader>xd          " Check diagnostics

" Stage 4: REFACTOR
<leader>qf          " Send diagnostics to quickfix
<leader>Dtc         " Run tests with coverage

" Stage 5-6: COMMIT & INTEGRATE
<leader>Dgc         " Conventional commit with helper
<leader>Dgp         " Push branch
<leader>Dgpr        " Create PR

" Stage 7: LEARN
<leader>zg          " Document what you learned
<leader>zD          " Create public reflection if valuable
<leader>zI          " Mark for spaced repetition
```

### Workflow 3b: Java Development Without LSP

Since jdtls is disabled (Java 24 runtime incompatibility), use these workflows:

```vim
" Quick compile and run workflow
<leader>Dtr         " Compile and run current Java file
" Automatically handles:
" - Changing to file directory
" - Compiling with javac
" - Running with java
" - Escaping paths with spaces

" Compile all Java files in project
<leader>Dta         " Find and compile all .java files
" Uses: find . -name '*.java' -type f -print0 | xargs -0 javac

" Performance testing
<leader>Dtc         " Compile, run, and show execution time
" Uses 'time' command to measure performance

" Syntax highlighting and navigation
" - Treesitter provides full syntax highlighting
" - Basic navigation with %{} works
" - No go-to-definition (requires LSP)

" Manual testing workflow
" 1. Write code with Treesitter syntax highlighting
" 2. Compile with <leader>Dtr to check for errors
" 3. Fix compilation errors shown in terminal
" 4. Run with <leader>Dtr to test functionality
" 5. Iterate until working

" To enable full LSP features:
" 1. Install Java 21: brew install openjdk@21
" 2. Uncomment jdtls config in lua/plugins/lsp.lua
" 3. Uncomment nvim-java in lua/plugins/dap.lua
" 4. Restart Neovim
" 5. jdtls will use Java 21 runtime but can compile Java 24 projects
```

### Workflow 4: Dual Documentation (DDR + Learning)

```vim
" Create a Decision Record + Learning Note together
<leader>DD          " Prompt for feature name
" Creates side-by-side split:
"   LEFT: docs/ddr/YYYY-MM-DD-feature.md (team knowledge)
"   RIGHT: ~/zettelkasten/projects/feature.md (personal insights)

" In DDR (team knowledge):
" - Record decision & rationale
" - Link to related decisions
" - Note trade-offs

" In Zettel (personal learning):
" - Why is this pattern useful?
" - When would I use this again?
" - Related patterns [[pattern-name]]
<leader>zI          " Mark for spaced repetition review
```

### Workflow 5: Spaced Repetition Learning

```vim
" 1. Mark a note for learning
:e ~/zettelkasten/permanent/important-concept.md
<leader>zI          " Initialize: adds review tracking to frontmatter
" Adds: review_count: 0, last_reviewed: null, next_review: today

" 2. Review periodically
<leader>zR          " Show all notes due for review today
" Returns sorted list with "due in X days"

" 3. Mark as reviewed
<leader>zr          " Mark reviewed: auto-updates Fibonacci interval
" review_count: 1 → next_review: today + 1 day
" review_count: 2 → next_review: today + 2 days
" review_count: 3 → next_review: today + 4 days
" ... continues: 1, 2, 4, 8, 16, 32, 64, 128 days

" Best practice: Review 5-10 notes daily for compounding knowledge
```

### Workflow 6: Publishing Knowledge

```vim
" 1. Mark notes for publishing
" Edit frontmatter in notes: publish: false → publish: true
" Typically reflections/ folder (automatically public by default)

" 2. Check what will be published
<leader>pc          " Shows all publish: true notes in floating window
" Verifies you're sharing what you intended

" 3. Preview locally
<leader>pa          " Aggregate: copy publish: true notes to digital-garden/
<leader>pb          " Build: Quartz generates static site
" Visit http://localhost:8080 in browser

" 4. Deploy to GitHub Pages
<leader>pd          " Push to production (git push)
" Your knowledge is now public at yoursite.com

" Optional: Just aggregate or just build
<leader>pa          " Copy files only (no build/deploy)
<leader>pb          " Build & serve for testing
```

## Language-Specific Configuration

### Python Development
- **LSP Servers**:
  - **Ruff**: Fast linting, import organization (`source.organizeImports` action)
  - **basedpyright**: Type checking with `typeCheckingMode: basic`
  - Configured to avoid conflicts (Ruff handles imports, basedpyright handles types)
- **Debugging**: nvim-dap-python with pytest integration
  - `<leader>dpt` - Debug test under cursor
  - `<leader>dpb` - Break on failure (stop at first error)
  - `<leader>db` - Toggle breakpoint
- **Testing**:
  - `<leader>Dtr` - Run test for current file
  - `<leader>Dta` - Run all tests
  - `<leader>Dtc` - Run with coverage
- **File settings**: `after/ftplugin/python.lua` (4-space indents, colorcolumn at 79)

### Go Development
- **LSP**: gopls with auto-format on save
- **Testing**:
  - `:!go test -v` (manual)
  - `<leader>Dtr` / `<leader>Dta` (automated)
- **Debugging**: Delve via nvim-dap
- **File settings**: Uses actual tabs (no expansion), 4-space display width

### TypeScript/JavaScript
- **LSP**: ts_ls with auto-format on save
- **Formatting**: Auto-format on save via LSP
- **File settings**: `after/ftplugin/typescript.lua` (2-space indents, colorcolumn at 79)
- **Completion**: blink.cmp with snippet support

### Java Development
- **LSP**: DISABLED (jdtls doesn't support Java 24 runtime)
  - To enable: Install Java 21 for jdtls runtime (can still compile Java 24 projects)
  - Uncomment jdtls config in `lua/plugins/lsp.lua` after installing Java 21
- **Syntax Highlighting**: Treesitter with Java parser (works perfectly with Java 24)
- **Compilation & Execution** (uses local `javac` compiler):
  - Language-aware test commands automatically detect Java files
  - `<leader>Dtr` - Compile and run current Java file (handles paths with spaces)
  - `<leader>Dta` - Find and compile all `.java` files in project
  - `<leader>Dtc` - Compile, run, and show execution time (using `time` command)
  - `<leader>Dtw` - Watch mode (not yet implemented for Java)
- **File settings**: `after/ftplugin/java.lua`
  - 4-space indentation (spaces, not tabs)
  - 120-character line length (colorcolumn)
  - Consistent with Java industry standards
- **Debugging**: DISABLED (nvim-java plugin requires jdtls)
  - nvim-java plugin is present but explicitly disabled
  - To enable: Install Java 21, enable jdtls, then enable nvim-java in `lua/plugins/dap.lua`
- **Documentation**: See `JAVA_DEVELOPMENT_GUIDE.md` for comprehensive setup instructions
- **Best Practices**: See `JAVA_DEVELOPMENT_BEST_PRACTICES_2025.md` for coding standards
- **Note**: You can use Java 24 for projects while running jdtls on Java 21
  - jdtls supports managing projects from Java 1.8 through Java 24
  - Only the jdtls runtime environment needs Java 21

### Other Languages Configured
- **Rust**: rust_analyzer with auto-format
- **C/C++**: clangd
- **Lua**: lua_ls (for this config!)
- **Swift**: sourcekit
- **Elixir**: elixirls

## LSP Server Management with Mason

This configuration uses **Mason.nvim** for automatic LSP server installation and management. All language servers mentioned above are automatically installed on first run.

### Essential Mason Commands

```vim
:Mason              " Open Mason UI (interactive server management)
:MasonLog           " View installation log and errors
:MasonUpdate        " Update all installed servers
:MasonInstall <server>   " Install a specific server
:MasonUninstall <server> " Remove a server
:LspInfo            " Show active LSP servers for current buffer
:LspRestart         " Restart LSP servers
```

### Auto-Installed Servers

The following servers are automatically installed on first Neovim startup:

| Server | Language | Purpose |
|--------|----------|---------|
| lua_ls | Lua | Neovim config development |
| basedpyright | Python | Type checking, completions, go-to-def |
| ruff | Python | Linting, formatting, import organization |
| gopls | Go | Full language support + auto-format |
| ts_ls | TypeScript/JavaScript | Full language support |
| rust-analyzer | Rust | Full language support + auto-format |
| clangd | C/C++ | Full language support |
| elixir-ls | Elixir | Full language support |
| gleam | Gleam | Full language support |
| jdtls | Java | Full language support (requires Java ≤21) |

**Note**: Swift's `sourcekit-lsp` is auto-detected from Xcode installation.

### Configuration Files

- **Server list**: `lua/plugins/mason.lua` - defines `ensure_installed` servers
- **Server settings**: `lua/plugins/lsp.lua` - custom configurations per server
- **Language-specific**: `after/ftplugin/<language>.lua` - filetype-specific settings

### Adding a New LSP Server

1. Edit `lua/plugins/mason.lua`:
   ```lua
   ensure_installed = {
     'new-server-name',  -- Add to this list
     -- ... existing servers
   }
   ```

2. If custom configuration needed, edit `lua/plugins/lsp.lua`:
   ```lua
   local server_configs = {
     new_server = {
       settings = {
         -- Custom server settings here
       }
     },
   }
   ```

3. Restart Neovim or run `:MasonInstall new-server-name`

### First-Time Setup Behavior

On first Neovim startup with this configuration:
1. Mason automatically detects missing servers
2. Downloads and installs all `ensure_installed` servers (~1-2 minutes)
3. LSP servers become active immediately after installation
4. Subsequent startups are fast (servers already installed)

**Tip**: Open `:Mason` in a split window during first startup to watch installation progress.

### Troubleshooting Mason

**Server not installing?**
```vim
:MasonLog           " Check what went wrong
:MasonInstall <server>  " Try manual install
```

**LSP not working for a file?**
```vim
:LspInfo            " Check if server is attached
:set filetype=<type>  " Ensure correct filetype is set
:LspRestart         " Restart LSP servers
```

**Conflicting diagnostics?**
- Check `:LspInfo` to see which servers are attached
- Hover over diagnostic to see source (e.g., "ruff" vs "basedpyright")
- Adjust `diagnosticSeverityOverrides` in `lua/plugins/lsp.lua` if needed

**Format on save not working?**
```vim
:LspInfo            " Check if server supports formatting
" Look for "formatting" in server capabilities
```

**Slow first startup?**
- Normal! Mason is installing servers (happens once)
- Open `:Mason` to see progress
- Subsequent startups are normal speed

### Multi-Machine Workflow

Mason makes this configuration portable across machines:
1. Clone this Neovim config to new machine
2. Start Neovim (servers auto-install)
3. Wait 1-2 minutes for installation
4. Done! Full LSP support ready

No manual installation of language servers required.

### Updating Servers

```vim
:MasonUpdate        " Update all servers to latest versions
:MasonUpdateAll     " Update Mason itself + all servers
```

**Best practice**: Update servers monthly or when encountering issues with language support.

### Python Dual-LSP Strategy

This configuration uses **two** Python LSP servers working together:

- **Ruff**: Handles linting, formatting, import organization
- **basedpyright**: Handles type checking, go-to-definition, completions

Configured to avoid conflicts:
- Basedpyright's import/unused variable diagnostics are disabled (Ruff handles these)
- Basedpyright focuses on type checking only (`typeCheckingMode: basic`)
- Both servers work seamlessly together via Mason

### See Also

For complete Mason documentation, see:
- `MASON_INDEX.md` - Navigation guide to all Mason docs
- `MASON_QUICK_REFERENCE.md` - Quick command reference (2-minute read)
- `MASON_MIGRATION_GUIDE.md` - Complete setup guide (10-minute read)
- `MASON_BEFORE_AFTER.md` - Code comparison showing what changed
- `MASON_REFACTORING_SUMMARY.md` - Executive summary

## Core Plugin Categories & Purpose

### Git & Version Control (15+ commands)
- **gitsigns.nvim**: Inline change indicators, hunk staging
- **vim-fugitive**: Advanced git operations (log, commit, show)
- **git-blame.nvim**: Floating blame window
- **diffview.nvim**: Split diff viewer
- **Custom git.lua**: 10+ archaeology commands (pickaxe, bisect, file history, etc)

### Development & Testing
- **nvim-dap**: Debug Adapter Protocol with breakpoint management
- **nvim-dap-python**: pytest integration, break-on-failure mode
- **nvim-java**: DISABLED - Java debugging with JUnit (requires jdtls, which needs Java ≤21 runtime)
- **overseer.nvim**: Task runner for custom build/test scripts
- **trouble.nvim**: Diagnostic browser and symbol navigator
- **Language-aware test automation**: Test commands auto-detect Python vs Java and use appropriate tools

### Knowledge & Notes
- **vim-telekasten**: Zettelkasten with UUID-based linking and backlinks
- **vim-markdown**: Enhanced markdown with folding and math support
- **todo-comments.nvim**: Highlight TODO/FIXME/BUG in code
- **Custom todo management**: Central TODO.md with sprint metrics

### Completion & Snippets
- **blink.cmp**: Modern Rust-based completion with fuzzy matching
- **LuaSnip**: Snippet engine with LaTeX templates (math, chemistry)
- **friendly-snippets**: Community snippet collection

### UI & Visualization
- **telescope.nvim**: Fuzzy finder with FZF native backend
- **which-key.nvim**: Keymap documentation overlay
- **snacks.nvim**: Zen mode, dashboard, notifier, explorer
- **lspsaga.nvim**: Enhanced LSP UI (lightbulb, code lens)
- **bufferline.nvim**: Tab bar for buffer switching
- **render-markdown.nvim**: Markdown rendering in editor

### Publishing Pipeline
- **Custom publishing.lua**: Full workflow for digital garden
  - Aggregates notes marked with `publish: true`
  - Builds static site with Quartz SSG
  - Serves locally for preview
  - Deploys to GitHub Pages

## Adding New Features

### To Add a New Git Investigation Command
1. Edit `lua/plugins/git.lua` (git archaeology section)
2. Add keymap pattern (terminal split for output display)
3. Examples to follow: `gfF` (follow file), `gfm` (message search), `gfh` (show at commit)

### To Add a New Zettelkasten Feature
1. Add keymaps to `lua/plugins/zettelkasten.lua`
2. For spaced rep features: update frontmatter fields (`review_count`, `last_reviewed`, `next_review`)
3. Follow existing patterns for note templates and auto-completion

### To Add Test Automation
1. Edit `lua/plugins/development-algorithm.lua` (test section)
2. Add command to vim-overseer or direct `:!` shell execution
3. Integrate with DAP breakpoints if debugging is needed

### To Enhance Publishing
1. Modify `lua/plugins/publishing.lua` for aggregation logic
2. Update `~/digital-garden/scripts/aggregate-content.sh` if filtering needed
3. Test with `<leader>pc` (check what's publishable)

## Performance Optimizations

- **Treesitter**: Disabled for files >100KB (foldmethod falls back to manual)
- **Lazy Loading**: Plugins load on-demand via events/commands/keymaps
- **Session Persistence**: Automatic workspace restoration (`lua/plugins/persistence.lua`)
- **Completion Caching**: blink.cmp caches completions efficiently
- **Git Blame Toggle**: Use `<leader>gb` to reduce gitsigns overhead in large files
- **Diagnostic Filtering**: `lua/config/diagnostics.lua` filters diagnostics by severity

## Integration Points

### With AI (Claude)
- Open ToggleTerm: `<C-\>` for side-by-side pair programming
- **Workflow**:
  1. Press `<C-\>` to open Claude terminal
  2. Ask Claude to help with Stage 0 understanding or Stage 3 implementation
  3. Share code context and let Claude think with you
- Capture AI insights in Zettelkasten:
  - `<leader>zn` for fleeting insights
  - `<leader>zz` to link back to relevant permanent notes
  - `<leader>zI` to mark for spaced repetition learning

### With Team Knowledge
- **DDRs** (Decision Records) in `docs/ddr/YYYY-MM-DD-*.md` for team decisions
- **Personal insights** in `~/zettelkasten/` for learning
- **Dual documentation**: `<leader>DD` creates both simultaneously in split view
- Link references: Use `[[zettel-note]]` in DDRs to link personal insights

### With Learning Systems
- **Spaced repetition**:
  - Initialize: `<leader>zI` (starts review tracking)
  - Review: `<leader>zR` (show notes due today)
  - Mark reviewed: `<leader>zr` (updates Fibonacci intervals)
- **Pattern extraction**: Fleeting → Permanent notes with `[[wiki-links]]`
- **Git discovery notes**: `<leader>zg` auto-creates during investigations
- **Reflection workflow**: `<leader>zD` for public learning to share

## Common Development Tasks

### Running Tests
```bash
<leader>Dtr         " Run test for current file
<leader>Dta         " Run all tests
<leader>Dtw         " Watch tests (live reload)
<leader>Dtc         " Run with coverage report
<leader>dpt         " Debug specific test
<leader>dpb         " Break on first failure
```

### Committing Code
```bash
<leader>Dgc         " Conventional commit helper (type + scope + message)
<leader>Dgp         " Push with tracking (-u flag)
<leader>Dgpr        " Create pull request via GitHub CLI
```

### Investigating Issues
```bash
<leader>gbi         " Find bug-introducing commit (bisect)
<leader>gB          " Full blame for current line
<leader>gF          " Search when code was added/removed
<leader>gfM         " Compare with main branch
<leader>zg          " Document findings
```

### Code Intelligence
```bash
gd                  " Go to definition
<leader>xl          " Show references (where used)
<leader>xs          " Symbol browser
]d / [d             " Jump diagnostics
<leader>cf          " Format + organize imports
```

## Troubleshooting

### Git Commands Not Working
- Ensure you're in a git repository: `<leader>gg`
- Verify git is installed: `:!git --version`
- Check git status: `:!git status`

### Zettelkasten Links Not Following
- Use `[[double-brackets]]` for wiki-links (case-insensitive)
- Press `<leader>zz` to follow link
- Create note with `<leader>zZ` (word → link → create)
- Link must exist or Telekasten will create it

### Publishing Not Working
- Check directories exist:
  - `~/digital-garden/` (Quartz project)
  - `~/digital-garden/scripts/aggregate-content.sh` (must be executable)
- Verify Quartz installation: `:!ls ~/digital-garden/quartz`
- Check frontmatter: `:!grep -r "publish: true" ~/zettelkasten/`
- Preview pipeline: `<leader>pc` (shows what will publish)
- Test locally: `<leader>pb` (build & serve)

### LSP Issues
- Check language server is installed:
  - `:Mason` - opens Mason UI
  - `:LspInfo` - shows active LSP servers
- Restart LSP: `:LspRestart`
- Check diagnostics: `<leader>qf` (send to quickfix)

### Performance Issues
- Check file size: Treesitter disabled >100KB
- Disable blame in large files: `<leader>gb` to toggle
- Use `:!clear` to clean large command output
- Close unused buffers: `:bw` (wipe buffer)

## Recent Major Enhancements

1. **Mason.nvim Integration** (NEW): Automatic LSP server installation and management
2. **Language-Aware Test Automation** (NEW): Test commands auto-detect Python vs Java
3. **Java Development Support** (NEW): Treesitter syntax, compile/run commands, comprehensive docs
4. **Spaced Repetition System**: Fibonacci-based review intervals with frontmatter tracking
5. **Git Archaeology System**: Complete 15-command investigation toolkit
6. **Dual Documentation**: DDR + Zettel side-by-side creation (`<leader>DD`)
7. **Extended Development Algorithm**: Full TDD workflow with test automation
8. **Publishing Pipeline**: One-command knowledge garden deployment (`<leader>pp`)
9. **Modern Completion**: blink.cmp Rust-based fuzzy matching
10. **Advanced Todo Management**: Central TODO.md with sprint metrics

## Key Documentation Resources

**Start Here:**
- `README.md` - System overview
- `QUICK_REFERENCE.md` - Cheat sheet of essential commands
- This file - Claude Code guidance

**Deep Dives:**
- `DEVELOPMENT_ALGORITHM.md` - Complete 7-stage workflow philosophy
- `GIT_ARCHAEOLOGY_QUICKSTART.md` - 5-minute guide to git investigations
- `ZETTELKASTEN_WORKFLOW.md` - Full knowledge management system
- `STACKED_PR_WORKFLOW.md` - Small, reviewable PR strategy

**Specific Systems:**
- `SPACED_REPETITION_GUIDE.md` - How the SM-2 learning system works
- `DAILY_STRUCTURE.md` - Integrated daily schedule
- `DUAL_DOCUMENTATION.md` - DDR + Zettel workflow
- `PUBLISHING_KEYMAPS.md` - Publishing command reference
- `GIT_BLAME_GUIDE.md` - Git blame in-depth
- `TODO_WORKFLOW.md` - Task management system
- `MASTER_WORKFLOW.md` - Unified system integration

**Language-Specific:**
- `JAVA_DEVELOPMENT_GUIDE.md` - Complete Java setup, jdtls configuration, debugging
- `JAVA_DEVELOPMENT_BEST_PRACTICES_2025.md` - Java coding standards and conventions

**LSP & Tooling:**
- `MASON_INDEX.md` - Navigation guide to all Mason documentation
- `MASON_QUICK_REFERENCE.md` - Quick Mason commands (2-minute read)
- `MASON_MIGRATION_GUIDE.md` - Complete Mason setup guide

**Conceptual:**
- `ZETTELKASTEN_PHILOSOPHY.md` - Why IDEAS not TOPICS
- `MASTER_WORKFLOW.md` - How everything connects

## Quick Start for Common Workflows

**New Feature with TDD:**
```vim
:TodoWrite                " Plan the work
<leader>zn                " Capture requirements
<leader>Dtr               " Run test (red)
<leader>cf                " Format & organize
<leader>Dtr               " Run test (green)
<leader>Dgc               " Commit conventionally
<leader>zg                " Document learning
<leader>zI                " Mark to review later
```

**Debug a Bug:**
```vim
<leader>gbi               " Find breaking commit
<leader>gB                " Understand the change
<leader>gfF               " Follow file history
<leader>zg                " Create discovery note
<leader>db                " Set breakpoint
<leader>dpt               " Debug test
```

**Share a Learning:**
```vim
<leader>zn                " Capture insight
<leader>zL                " Add wiki-links
<leader>zI                " Mark for review
<leader>zR                " Review daily
<leader>zD                " Create public reflection
<leader>pc                " Check what publishes
<leader>pp                " Full publish pipeline
```
- add Mason information to CLAUDE.md