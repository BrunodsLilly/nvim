# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an advanced Neovim configuration implementing a comprehensive developer productivity system combining:
- **7-Stage Development Algorithm** with TDD and Git archaeology
- **Zettelkasten knowledge management** for learning capture and pattern extraction
- **Digital Garden publishing** system for knowledge sharing
- **Extensive automation** via 200+ custom keymaps and workflows

The configuration emphasizes learning from code history, systematic problem-solving, and knowledge compounding through deliberate practice.

## Critical Commands for Development

### Core Workflows

```vim
" Development Algorithm
<leader>gg          " LazyGit - Check git status/branch
:TodoWrite          " Create/manage task breakdown
<leader>qf          " Send diagnostics to quickfix
<leader>cf          " Format code and organize imports

" Git Archaeology (investigating code history)
<leader>gb          " Toggle inline git blame (see who/when/why)
<leader>gF          " Pickaxe: Find when code was added/removed
<leader>gbi         " Interactive bisect to find bug-introducing commit
<leader>gB          " Full blame popup with commit details
<leader>gfa         " Show file contributors (find experts)

" Knowledge Capture (Zettelkasten)
<leader>zd          " Daily note (private journal)
<leader>zn          " New fleeting note (quick capture)
<leader>zg          " Git discovery note (document investigations)
<leader>zD          " Public reflection (sharable learning)
<leader>zz          " Follow wiki-link [[like-this]]

" Publishing & Sharing
<leader>pp          " Full publish: Aggregate + Build + Preview
<leader>pd          " Deploy to GitHub Pages
<leader>pc          " Check what will be published (publish: true)
```

### Testing & Debugging

```vim
" Python-specific (with pytest integration)
<leader>dpt         " Debug pytest test under cursor
<leader>db          " Toggle breakpoint
<leader>dc          " Continue execution
<leader>du          " Toggle DAP UI

" Run tests (varies by language)
:!pytest %          " Run current Python file tests
:!go test -v        " Run Go tests
:!npm test          " Run JavaScript tests
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
│                   Zettelkasten                       │
│  Fleeting → Literature → Permanent → Project        │
│  Quick capture → Process → Distill → Apply         │
└─────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────┐
│                  Digital Garden                      │
│  Aggregate (publish: true) → Build → Deploy         │
│  Private knowledge → Public sharing                 │
└─────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **Dual LSP Strategy**: Python uses Ruff (fast linting) + basedpyright (intelligence)
2. **Git-First Learning**: Every code investigation starts with git history
3. **Privacy-By-Default**: All notes have `publish: false` unless explicitly shared
4. **Modular Plugin System**: Each plugin in separate file under `lua/plugins/`
5. **Session Persistence**: Automatic workspace restoration via Persistence.nvim

### Directory Structure Impact

```
~/zettelkasten/               # Knowledge base (mostly private)
├── daily/                    # Daily notes (never published)
├── fleeting/                 # Quick captures (inbox)
├── permanent/                # Atomic insights (selectively published)
├── projects/                 # Active work documentation
├── git-discoveries/          # Git archaeology findings
├── reflections/              # Public learning (publish: true by default)
└── templates/                # Note templates with frontmatter

~/digital-garden/             # Public website
├── quartz/                  # Static site generator
│   └── content/            # Aggregated public notes
└── scripts/
    └── aggregate-content.sh # Copies publish: true notes
```

## Development Workflows

### Workflow 1: Bug Investigation with Git Archaeology

```vim
" 1. Find when bug was introduced
<leader>gbi         " Start bisect
" Enter: bad commit (HEAD), good commit (v1.0.0)
" Test at each commit, mark good/bad
" Git finds exact breaking commit

" 2. Understand the change
<leader>gB          " Full blame on problematic line
:Git show <sha>     " See complete commit context

" 3. Document discovery
<leader>zg          " Create git discovery note
" Title: "Bug: Authentication fails after refactoring"

" 4. Extract pattern if applicable
<leader>zn          " Create permanent note
" Title: "Pattern: Middleware ordering matters"
```

### Workflow 2: Learning from Expert Code

```vim
" 1. Find who knows this code best
<leader>gfa         " Show file contributors

" 2. Study their evolution
<leader>gfF         " Follow file through renames
<leader>gl          " Study commit messages

" 3. Search for patterns
<leader>gF          " Pickaxe: Find similar code
" Enter search term (e.g., "FactoryPattern")

" 4. Capture learnings
<leader>zn          " Create permanent note with pattern
```

### Workflow 3: TDD with Knowledge Capture

```vim
" Stage 0: UNDERSTAND
<leader>zn          " Capture requirements as fleeting note
<leader>gF          " Search for similar implementations

" Stage 2: TEST-FIRST
" Write failing test first
:!pytest test_feature.py -xvs

" Stage 3: IMPLEMENT
" Write minimal code to pass

" Stage 7: LEARN
<leader>zg          " Document what you learned
<leader>zD          " Create public reflection if valuable
```

### Workflow 4: Publishing Knowledge

```vim
" 1. Mark notes for publishing
" Edit frontmatter: publish: false → publish: true

" 2. Check what will be published
<leader>pc          " Shows all publish: true notes

" 3. Preview locally
<leader>pp          " Aggregate + Build + Serve
" Visit http://localhost:8080

" 4. Deploy to GitHub Pages
<leader>pd          " Push to production
```

## Language-Specific Configuration

### Python Development
- **LSP**: Ruff + basedpyright (dual server setup)
- **Debugging**: nvim-dap-python with pytest integration
- **Testing**: `<leader>dpt` for debugging tests
- **File settings**: `after/ftplugin/python.lua` (4-space indents)

### Go Development
- **LSP**: gopls
- **Testing**: `:!go test -v`
- **Debugging**: Delve via nvim-dap

### TypeScript/JavaScript
- **LSP**: ts_ls
- **Formatting**: Auto-format on save
- **File settings**: `after/ftplugin/typescript.lua` (2-space indents)

## Adding New Features

### To Add a New Git Investigation Command
1. Edit `lua/plugins/git.lua`
2. Add keymap in the Git Archaeology section
3. Follow pattern of existing commands (terminal split for output)

### To Add a New Zettelkasten Template
1. Create template in `~/zettelkasten/templates/`
2. Include YAML frontmatter with `publish: false` default
3. Update `lua/plugins/zettelkasten.lua` if needs custom command

### To Enhance the Development Algorithm
1. Edit `DEVELOPMENT_ALGORITHM.md`
2. Add new stage or enhance existing stage
3. Update keymaps if needed in relevant plugin files

## Performance Optimizations

- **Treesitter**: Disabled for files >100KB
- **Lazy Loading**: Plugins load on-demand via events/commands
- **Session Management**: `<leader>qs` restores workspace instantly
- **Git Blame**: Toggle with `<leader>gb` to reduce overhead

## Integration Points

### With AI (Claude)
- Use `<C-\>` for ToggleTerm with Claude
- Capture AI insights in Zettelkasten
- Use prompts from Development Algorithm Stage 0 and 3

### With Team Knowledge
- DDRs in `docs/ddr/` for team decisions
- Personal insights in `~/zettelkasten/`
- Bidirectional linking between both

### With Learning Systems
- Spaced repetition: `<leader>zI` to initialize, `<leader>zr` to review
- Weekly reviews: `<leader>zw` for weekly note
- Pattern extraction: Fleeting → Permanent notes

## Troubleshooting

### Git Commands Not Working
- Ensure you're in a git repository
- Check `<leader>gg` for git status
- Verify with `:!git status`

### Zettelkasten Links Not Following
- Use `[[double-brackets]]` for wiki-links
- Press `<leader>zz` to follow link
- Ensure note exists or will be created

### Publishing Not Working
- Check `~/digital-garden/` exists
- Verify Quartz is installed
- Run `<leader>pc` to see publishable notes
- Ensure notes have `publish: true` in frontmatter

## Recent Major Enhancements

1. **Git Archaeology System**: Complete investigation toolkit with 10+ commands
2. **Spaced Repetition**: Custom SRS with frontmatter tracking
3. **Public/Private Diary**: Dual-layer note system for sharing
4. **Publishing Pipeline**: One-command knowledge garden deployment
5. **Development Algorithm**: 7-stage TDD workflow with git integration

## Documentation Resources

**Core Guides:**
- `DEVELOPMENT_ALGORITHM.md` - Complete 7-stage workflow
- `GIT_ARCHAEOLOGY_QUICKSTART.md` - 5-minute git investigation guide
- `ZETTELKASTEN_WORKFLOW.md` - Knowledge management system
- `DAILY_STRUCTURE.md` - Integrated daily schedule

**Quick References:**
- `PUBLISHING_KEYMAPS.md` - Publishing commands
- `GIT_BLAME_GUIDE.md` - Git blame workflows
- `FOLDING_GUIDE.md` - Code folding commands
- `QUICK_REFERENCE.md` - Common operations

**Philosophy:**
- `ZETTELKASTEN_PHILOSOPHY.md` - IDEAS not TOPICS
- `MASTER_WORKFLOW.md` - Unified system integration