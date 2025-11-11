# feat: Add wonderful Julia programming DX to Neovim config

## Labels
`enhancement`, `language-support`, `documentation`

## Overview

Transform this Neovim configuration into a world-class Julia development environment by integrating LSP (LanguageServer.jl), REPL-driven workflows (vim-slime), debugging (nvim-dap-julia), LaTeX symbol completion, and test automation. This enhancement follows the existing patterns established for Python, Go, TypeScript, and Java to provide a seamless Julia experience.

## Problem Statement / Motivation

Julia is increasingly used for scientific computing, data science, and high-performance numerical analysis. The current Neovim config supports 10+ languages but lacks Julia integration. Adding comprehensive Julia support would:

1. **Enable interactive development**: Julia's REPL-driven workflow (like IPython) requires seamless editor-REPL integration
2. **Support LaTeX symbols**: Julia uses extensive Unicode math symbols (`α`, `β`, `∑`) requiring special input methods
3. **Provide type checking**: LanguageServer.jl offers IntelliSense, go-to-definition, and diagnostics
4. **Enable cell-based workflows**: Scientific computing benefits from Jupyter-style `##` cell execution
5. **Integrate with existing systems**: Leverage Mason.nvim, development algorithm keymaps, and DAP debugging

**Why this matters**: Julia developers switching to this config should have feature parity with Python/TypeScript support.

## Proposed Solution

Implement a modular Julia plugin system following the established architecture:

```
lua/plugins/julia.lua            # Main plugin configuration (LSP, REPL, cells, completion, DAP)
after/ftplugin/julia.lua         # Filetype-specific settings (indentation, keymaps, comments)
JULIA_DEVELOPMENT_GUIDE.md       # Comprehensive setup guide (similar to JAVA_DEVELOPMENT_GUIDE.md)
JULIA_QUICKSTART.md              # 10-minute getting started (similar to QUICK_REFERENCE.md)
```

### Core Components

**1. Language Server (LSP)**
- **Server**: LanguageServer.jl via Mason.nvim (`julials`)
- **Features**: Code completion, go-to-definition, hover docs, diagnostics, formatting (JuliaFormatter.jl)
- **Configuration**: Custom environment at `~/.julia/environments/nvim-lspconfig`

**2. REPL Integration**
- **Plugin**: vim-slime (aligns with existing Python workflow patterns)
- **Target**: tmux right pane (matches project convention)
- **Enhancement**: Revise.jl for auto-reload on file changes

**3. LaTeX Symbol Completion**
- **Plugin**: cmp-latex-symbols (integrates with existing nvim-cmp)
- **Database**: `unimathsymbols.txt` (official Julia REPL symbols)
- **Behavior**: `\alpha<Tab>` → `α` (mimics Julia REPL)

**4. Cell-Based Development**
- **Plugin**: vim-julia-cell (depends on vim-slime)
- **Markers**: `##` (follows Jupyter/MATLAB conventions)
- **Commands**: Execute cell, jump to next/prev, clear REPL

**5. Debugging**
- **Plugin**: nvim-dap-julia (integrates with existing DAP config)
- **Backend**: DebugAdapter.jl
- **Features**: Breakpoints, step-over/into/out, variable inspection

**6. Test Automation**
- **Integration**: Extend `lua/plugins/development-algorithm.lua` with Julia detection
- **Commands**:
  - `<leader>Dtr` — Run test for current file (auto-detect Julia)
  - `<leader>Dta` — Run all tests (`Pkg.test()`)
  - `<leader>Dtc` — Run with coverage (`--code-coverage=user`)
  - `<leader>Dtw` — Watch mode (TestEnv.jl integration)

## Technical Approach

### Architecture Integration

**Follows Established Patterns from**:
- **Python dual LSP** (`lsp.lua:39-76`): Custom server configs in `server_configs` table
- **Java compile-only** (`development-algorithm.lua:48-58`): Language-aware test automation
- **Go/TypeScript** (`ftplugin/go.lua`, `ftplugin/typescript.lua`): Filetype-specific settings
- **Mason auto-install** (`mason.lua:15-38`): Add `julials` to `ensure_installed` list

### File Structure

```
~/.config/nvim/
├── lua/plugins/
│   ├── julia.lua                 # New: Julia plugin configuration
│   ├── mason.lua                 # Modified: Add 'julials' to ensure_installed
│   ├── lsp.lua                   # Modified: Add julials config to server_configs
│   ├── development-algorithm.lua # Modified: Add Julia test automation cases
│   └── treesitter.lua            # Modified: Add 'julia' to ensure_installed
├── after/ftplugin/
│   └── julia.lua                 # New: Julia-specific settings and keymaps
├── JULIA_DEVELOPMENT_GUIDE.md    # New: Comprehensive guide (~12,000 words)
├── JULIA_QUICKSTART.md           # New: 10-minute setup guide
├── JULIA_RESEARCH_SUMMARY.md     # New: Research findings and plugin analysis
├── JULIA_INDEX.md                # New: Documentation navigation hub
└── CLAUDE.md                     # Modified: Add Julia section to "Language-Specific Configuration"
```

### Implementation Phases

#### Phase 1: Foundation (LSP + Treesitter)
**Estimated Effort**: 2 hours

**Tasks**:
- [ ] Add `julials` to `lua/plugins/mason.lua:15-38` ensure_installed list
- [ ] Add `julia` to `lua/plugins/treesitter.lua:9` ensure_installed list
- [ ] Create LSP configuration in `lua/plugins/lsp.lua:28-92` server_configs table
- [ ] Test LSP features: `:LspInfo` should show julials attached
- [ ] Verify Treesitter syntax highlighting in `.jl` file

**Example Code** (`lua/plugins/lsp.lua`):
```lua
local server_configs = {
  -- ... existing configs
  julials = {
    on_new_config = function(new_config, _)
      local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
      if require('lspconfig').util.path.is_file(julia) then
        new_config.cmd[1] = julia
      end
    end,
    settings = {
      julia = {
        format = { useFormatterConfigDefaults = true },
        symbolserverCachePath = vim.fn.stdpath("cache") .. "/julia_symbolserver",
      }
    }
  },
}
```

**Success Criteria**:
- `:LspInfo` shows julials attached to `.jl` buffers
- Code completion works (`gd`, `gr`, `K` keymaps functional)
- Syntax highlighting shows Julia keywords, functions, strings

**Dependencies**: Requires Julia installed and LanguageServer.jl package

**Estimated Effort**: 2 hours

---

#### Phase 2: REPL & Interactive Development
**Estimated Effort**: 3 hours

**Tasks**:
- [ ] Add vim-slime to `lua/plugins/julia.lua` with tmux target configuration
- [ ] Add vim-julia-cell for cell-based execution
- [ ] Configure `<leader>j*` keymaps for Julia-specific commands
- [ ] Create `after/ftplugin/julia.lua` with filetype settings (4-space indent, 92-char limit)
- [ ] Test REPL workflow: `<Ctrl-c><Ctrl-c>` sends code to Julia REPL in tmux

**Example Code** (`lua/plugins/julia.lua`):
```lua
return {
  -- REPL Integration
  {
    'jpalardy/vim-slime',
    ft = { 'julia', 'python', 'r' },
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = {
        socket_name = vim.api.nvim_eval('get(split($TMUX, ","), 0)'),
        target_pane = '{right-of}'
      }
      vim.g.slime_dont_ask_default = 1
    end
  },

  -- Cell-based development
  {
    'mroavi/vim-julia-cell',
    ft = 'julia',
    dependencies = { 'jpalardy/vim-slime' },
    config = function()
      vim.g.julia_cell_delimit_cells_by = 'tags'
      vim.g.julia_cell_tag = '##'
    end
  },

  -- Julia-specific keybindings
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { '<Leader>j', group = 'Julia' },
        { '<Leader>jc', ':JuliaCellExecuteCell<CR>', desc = 'Execute cell' },
        { '<Leader>jr', ':JuliaCellRun<CR>', desc = 'Run file' },
        { '<Leader>jl', ':JuliaCellClear<CR>', desc = 'Clear REPL' },
        { '<Leader>jp', ':JuliaCellPrevCell<CR>', desc = 'Previous cell' },
        { '<Leader>jn', ':JuliaCellNextCell<CR>', desc = 'Next cell' },
      }
    }
  },
}
```

**Success Criteria**:
- `<Ctrl-c><Ctrl-c>` sends Julia code to tmux pane
- `<leader>jc` executes code cell (marked with `##`)
- `<leader>jr` runs entire file in REPL
- Revise.jl auto-reloads changes without restarting REPL

**Dependencies**: Requires tmux running with Julia REPL in right pane

**Estimated Effort**: 3 hours

---

#### Phase 3: Test Automation & Development Algorithm Integration
**Estimated Effort**: 2 hours

**Tasks**:
- [ ] Extend `lua/plugins/development-algorithm.lua:44-100` with Julia filetype detection
- [ ] Add test commands: run, watch, all, coverage
- [ ] Integrate with existing `<leader>Dt*` keymaps (auto-detect Julia like Python/Java)
- [ ] Test workflow: `<leader>Dtr` runs tests for current Julia file
- [ ] Document in `CLAUDE.md` under "Language-Specific Configuration → Julia Development"

**Example Code** (`lua/plugins/development-algorithm.lua`):
```lua
-- Extend existing test automation with Julia support
{ "<leader>Dtr", function()
  local filetype = vim.bo.filetype
  if filetype == "python" then
    -- ... existing Python code
  elseif filetype == "java" then
    -- ... existing Java code
  elseif filetype == "julia" then
    -- Run test for current file (assumes test/test_<filename>.jl)
    local current_file = vim.fn.expand('%:t:r')
    local test_file = 'test/test_' .. current_file .. '.jl'
    if vim.fn.filereadable(test_file) == 1 then
      vim.cmd('!julia --project=. ' .. test_file)
    else
      vim.cmd('!julia --project=. -e "using Pkg; Pkg.test()"')
    end
  else
    vim.notify("Test runner not configured for " .. filetype, vim.log.levels.WARN)
  end
end, desc = "Run test for current file" },

{ "<leader>Dta", function()
  if vim.bo.filetype == "julia" then
    vim.cmd('!julia --project=. -e "using Pkg; Pkg.test()"')
  end
end, desc = "Run all tests" },

{ "<leader>Dtc", function()
  if vim.bo.filetype == "julia" then
    vim.cmd('!julia --startup-file=no --code-coverage=user --project=. -e "using Pkg; Pkg.test(coverage=true)"')
  end
end, desc = "Run tests with coverage" },
```

**Success Criteria**:
- `<leader>Dtr` auto-detects Julia and runs appropriate test command
- `<leader>Dta` runs full test suite (`Pkg.test()`)
- `<leader>Dtc` runs with coverage tracking
- Test output displays in Neovim terminal

**Dependencies**: Requires Julia project with `test/runtests.jl`

**Estimated Effort**: 2 hours

---

#### Phase 4: LaTeX Symbols & Completion
**Estimated Effort**: 1 hour

**Tasks**:
- [ ] Add cmp-latex-symbols to `lua/plugins/julia.lua` nvim-cmp sources
- [ ] Configure with `strategy = 0` (mixed Julia/LaTeX symbols)
- [ ] Test: Typing `\alpha` should suggest `α` in completion menu
- [ ] Test: Typing `\sum` should suggest `∑`

**Example Code** (`lua/plugins/julia.lua`):
```lua
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'kdheepak/cmp-latex-symbols',
  },
  opts = function(_, opts)
    table.insert(opts.sources, {
      name = 'latex_symbols',
      option = { strategy = 0 }  -- 0: mixed, 1: Julia only, 2: LaTeX only
    })
  end
}
```

**Success Criteria**:
- Completion menu shows Unicode symbols for LaTeX commands
- `<Tab>` or `<CR>` inserts Unicode character
- Works in all Julia file types (`.jl`, `.jl.md`)

**Dependencies**: Requires `unimathsymbols.txt` database (bundled with plugin)

**Estimated Effort**: 1 hour

---

#### Phase 5: Debugging Support
**Estimated Effort**: 2 hours

**Tasks**:
- [ ] Add nvim-dap-julia to `lua/plugins/dap.lua` (similar to Python DAP config)
- [ ] Configure debug adapter with DebugAdapter.jl
- [ ] Test: Set breakpoint (`<leader>db`), run debugger (`<F5>`)
- [ ] Verify step-over/into/out commands work (`<F10>`, `<F11>`, `<F12>`)
- [ ] Test variable inspection in DAP UI

**Example Code** (`lua/plugins/dap.lua`):
```lua
-- Add after existing Python DAP configuration
{
  'mfussenegger/nvim-dap',
  dependencies = {
    'kdheepak/nvim-dap-julia',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    require('nvim-dap-julia').setup()
    require('dapui').setup()
    require('nvim-dap-virtual-text').setup()

    -- Julia-specific DAP configuration
    local dap = require('dap')
    dap.configurations.julia = {
      {
        type = "julia",
        name = "Debug current file",
        request = "launch",
        program = "${file}",
        projectDir = "${workspaceFolder}",
        juliaEnv = "${workspaceFolder}",
        stopOnEntry = false,
      }
    }
  end
}
```

**Success Criteria**:
- Breakpoints set in Julia files appear in DAP UI
- `<F5>` starts debugger and stops at breakpoint
- Step commands navigate through Julia code
- Variable values display in DAP UI sidebars

**Dependencies**: Requires DebugAdapter.jl installed (`using Pkg; Pkg.add("DebugAdapter")`)

**Estimated Effort**: 2 hours

---

#### Phase 6: Documentation & Polish
**Estimated Effort**: 4 hours

**Tasks**:
- [ ] Write `JULIA_DEVELOPMENT_GUIDE.md` (~12,000 words, comprehensive reference)
- [ ] Write `JULIA_QUICKSTART.md` (~2,000 words, 10-minute setup)
- [ ] Write `JULIA_RESEARCH_SUMMARY.md` (research findings, plugin ecosystem)
- [ ] Write `JULIA_INDEX.md` (navigation hub for all Julia docs)
- [ ] Update `CLAUDE.md` with Julia section (LSP, REPL, Unicode, debugging, testing)
- [ ] Update `QUICK_REFERENCE.md` with Julia keybindings
- [ ] Add Julia section to `README.md` under "Language Support"

**Documentation Structure**:

**JULIA_DEVELOPMENT_GUIDE.md**:
1. Introduction & Overview
2. LSP Setup (LanguageServer.jl installation, configuration)
3. REPL Integration (vim-slime, Revise.jl workflow)
4. LaTeX Symbols & Unicode Input
5. Cell-Based Development (vim-julia-cell)
6. Debugging with nvim-dap-julia
7. Test Automation & Development Algorithm Integration
8. Performance Optimization (BenchmarkTools.jl, Profile.jl, PProf.jl)
9. Troubleshooting Common Issues
10. Best Practices & Workflows
11. Resources & References

**JULIA_QUICKSTART.md**:
1. Prerequisites (Julia 1.6+, Neovim 0.10+, tmux)
2. Installation (5 commands to copy-paste)
3. Essential Keybindings (table format)
4. Testing Your Setup (checklist)
5. Next Steps (links to comprehensive guide)

**CLAUDE.md Updates** (add after Java section):
````markdown
### Julia Development
- **LSP**: LanguageServer.jl via Mason (`julials`)
  - Full IntelliSense with code completion, go-to-definition, hover docs
  - JuliaFormatter.jl integration (format on save)
  - Symbol server caching for fast project loading
- **REPL Integration**: vim-slime + Revise.jl for interactive development
  - `<Ctrl-c><Ctrl-c>` — Send code to Julia REPL in tmux
  - `<leader>jc` — Execute cell (marked with `##`)
  - `<leader>jr` — Run entire file
  - `<leader>jl` — Clear REPL output
- **LaTeX Symbols**: cmp-latex-symbols for Unicode input
  - `\alpha<Tab>` → `α` (mimics Julia REPL)
  - Integrated with nvim-cmp completion menu
- **Testing**:
  - `<leader>Dtr` — Run test for current file
  - `<leader>Dta` — Run all tests (`Pkg.test()`)
  - `<leader>Dtc` — Run with coverage tracking
  - `<leader>Dtw` — Watch mode (TestEnv.jl)
- **Debugging**: nvim-dap-julia + DebugAdapter.jl
  - `<leader>db` — Toggle breakpoint
  - `<F5>` — Start/continue debugger
  - `<F10>/<F11>/<F12>` — Step over/into/out
- **File settings**: `after/ftplugin/julia.lua` (4-space indents, 92-char colorcolumn)
- **Documentation**: See `JULIA_DEVELOPMENT_GUIDE.md` for comprehensive setup
````

**Success Criteria**:
- All Julia docs follow project conventions (ALL_CAPS.md format)
- CLAUDE.md section matches Python/Java documentation style
- Quick Reference includes all `<leader>j*` keybindings
- Documentation includes file paths with line numbers (e.g., `lsp.lua:39`)

**Estimated Effort**: 4 hours

---

## Acceptance Criteria

### Functional Requirements

- [ ] **LSP Integration**: julials attaches to `.jl` buffers (verify with `:LspInfo`)
- [ ] **Code Completion**: IntelliSense works (`<Ctrl-n>` shows completions)
- [ ] **Go-to-Definition**: `gd` navigates to function definitions
- [ ] **Hover Documentation**: `K` shows docstrings
- [ ] **Formatting**: `<leader>cf` formats Julia code with JuliaFormatter.jl
- [ ] **REPL Integration**: `<Ctrl-c><Ctrl-c>` sends code to Julia REPL in tmux
- [ ] **Cell Execution**: `<leader>jc` executes `##`-marked code cells
- [ ] **LaTeX Symbols**: `\alpha` in completion menu inserts `α`
- [ ] **Test Automation**: `<leader>Dtr` detects Julia and runs tests
- [ ] **Debugging**: Breakpoints work in Julia files, debugger starts with `<F5>`
- [ ] **Syntax Highlighting**: Treesitter highlights Julia syntax correctly

### Non-Functional Requirements

- [ ] **Performance**: LSP startup <3 seconds (SymbolServer cache enabled)
- [ ] **Compatibility**: Works with Julia 1.6+ and Neovim 0.10+
- [ ] **Documentation**: Comprehensive guide + quickstart (total ~15,000 words)
- [ ] **Maintainability**: Follows existing plugin structure (`lua/plugins/julia.lua`)
- [ ] **Accessibility**: Works without external dependencies (except Julia, tmux, LanguageServer.jl)

### Quality Gates

- [ ] **Test Coverage**: All keybindings documented in CLAUDE.md
- [ ] **Documentation Completeness**: All plugins have configuration examples
- [ ] **Code Review Approval**: Follows project conventions (lazy-loading, which-key integration)
- [ ] **Integration Testing**: Tested with sample Julia project (DataFrames.jl, Plots.jl)
- [ ] **No Regressions**: Existing Python/Java/TypeScript workflows unaffected

## Success Metrics

**Quantitative**:
- **Setup Time**: <10 minutes from clone to working Julia LSP
- **REPL Latency**: <100ms from keypress to code execution
- **LSP Features**: 100% parity with Python (completion, diagnostics, hover, format)
- **Documentation Coverage**: 5 documents totaling ~15,000 words
- **Keybindings**: 15+ Julia-specific commands under `<leader>j*`

**Qualitative**:
- **Developer Experience**: Julia feels as first-class as Python/TypeScript
- **Workflow Smoothness**: No context-switching between editor and REPL
- **Discoverability**: which-key shows all Julia commands when pressing `<leader>j`
- **Learnability**: 10-minute quickstart enables basic workflow

## Dependencies & Prerequisites

### External Dependencies

**Required**:
1. **Julia** 1.6+ installed (`brew install julia` or juliaup)
2. **tmux** for REPL integration (`brew install tmux`)
3. **LanguageServer.jl** package (`julia -e 'using Pkg; Pkg.add("LanguageServer")'`)
4. **Revise.jl** for auto-reload (`julia -e 'using Pkg; Pkg.add("Revise")'`)

**Optional (for full features)**:
5. **JuliaFormatter.jl** for format-on-save
6. **DebugAdapter.jl** for debugging
7. **TestEnv.jl** for faster test iteration
8. **BenchmarkTools.jl** for performance testing

### Neovim Plugin Dependencies

**Already Installed**:
- nvim-lspconfig (LSP client)
- nvim-treesitter (syntax highlighting)
- nvim-cmp (completion engine)
- nvim-dap (debugging protocol)
- which-key.nvim (keybinding documentation)
- mason.nvim (LSP server management)

**New Plugins to Add**:
- vim-slime (REPL integration)
- vim-julia-cell (cell-based execution)
- cmp-latex-symbols (Unicode completion)
- nvim-dap-julia (Julia debugging adapter)

### Configuration Files Modified

1. `lua/plugins/mason.lua` — Add `julials` to `ensure_installed`
2. `lua/plugins/lsp.lua` — Add Julia LSP configuration
3. `lua/plugins/development-algorithm.lua` — Add Julia test automation
4. `lua/plugins/treesitter.lua` — Add `julia` parser
5. `CLAUDE.md` — Document Julia support

### Configuration Files Created

1. `lua/plugins/julia.lua` — Main Julia plugin config (~200 lines)
2. `after/ftplugin/julia.lua` — Filetype settings (~50 lines)
3. `JULIA_DEVELOPMENT_GUIDE.md` — Comprehensive guide (~12,000 words)
4. `JULIA_QUICKSTART.md` — Quick setup (~2,000 words)
5. `JULIA_RESEARCH_SUMMARY.md` — Research findings (~3,000 words)
6. `JULIA_INDEX.md` — Documentation hub (~500 words)

## Risk Analysis & Mitigation

### Risk 1: LanguageServer.jl Performance Issues
**Likelihood**: Medium
**Impact**: High (affects core LSP functionality)

**Mitigation**:
- Enable SymbolServer caching to avoid reindexing on every startup
- Set `julia_env_path` to avoid 2-second delay in single-file mode
- Document PackageCompiler.jl sysimage workflow for instant startup (20s → 0.5s)
- Provide fallback: Disable LSP if slow, rely on Treesitter + REPL

### Risk 2: vim-slime Conflicts with Existing Plugins
**Likelihood**: Low
**Impact**: Medium (breaks REPL workflow)

**Mitigation**:
- Test with existing Python workflows (this config already might use REPLs)
- Document vim-slime configuration (ftplugin-based activation, not global)
- Alternative: Provide iron.nvim configuration (pure Neovim terminal, no tmux)

### Risk 3: nvim-dap-julia Instability
**Likelihood**: High
**Impact**: Low (debugging is optional feature)

**Mitigation**:
- Mark debugging as "experimental" in documentation
- DebugAdapter.jl is less mature than Python's debugpy
- Provide fallback: Use `@show`, `@info`, `@warn` for print debugging
- Link to VSCode Julia extension if advanced debugging needed

### Risk 4: Mason.nvim Compatibility
**Likelihood**: Medium
**Impact**: Medium (affects auto-installation)

**Mitigation**:
- Recent reports of julials quitting unexpectedly on Neovim 0.11
- Provide manual installation instructions as primary method
- Mason as convenience, not requirement
- Document Neovim 0.10 as tested version

### Risk 5: Complexity Creep
**Likelihood**: Medium
**Impact**: Medium (harder to maintain)

**Mitigation**:
- Follow modular plugin architecture (single `julia.lua` file)
- Lazy-load all Julia plugins with `ft = 'julia'`
- Document every configuration option with inline comments
- Provide minimal config for users who want basics only

## Resource Requirements

### Time Investment

**Development**:
- Phase 1 (LSP + Treesitter): 2 hours
- Phase 2 (REPL + Cells): 3 hours
- Phase 3 (Test Automation): 2 hours
- Phase 4 (LaTeX Symbols): 1 hour
- Phase 5 (Debugging): 2 hours
- Phase 6 (Documentation): 4 hours
- **Total**: ~14 hours

**Testing**:
- Integration testing: 2 hours
- Documentation review: 1 hour
- Bug fixes: 2 hours
- **Total**: ~5 hours

**Grand Total**: ~19 hours

### Expertise Required

**Essential**:
- Lua programming (Neovim plugin configuration)
- Julia language knowledge (to test features accurately)
- LSP protocol understanding (server configuration)
- tmux/terminal multiplexing (REPL integration)

**Helpful**:
- Mason.nvim architecture (server management)
- nvim-dap protocol (debugging setup)
- Treesitter configuration (syntax highlighting)
- LaTeX symbol systems (Unicode completion)

### Infrastructure Needs

**Local Development**:
- macOS/Linux machine (Neovim + Julia + tmux)
- Test Julia project with dependencies (DataFrames.jl, Plots.jl)
- Multiple tmux panes for REPL testing

**External Services**:
- None required (fully local development environment)

## Future Considerations

### Extensibility

**Potential Enhancements**:
1. **Neotest Integration**: Create `neotest-julia` adapter for inline test results
2. **Pluto.jl Support**: Integrate reactive notebooks (like Jupyter, but Julia-native)
3. **Telescope Extensions**: Julia package browser, function finder, documentation search
4. **Macro Expansion Viewer**: Show expanded macros in floating window
5. **Type Inspector UI**: Display inferred types inline (like Rust's type hints)
6. **PackageCompiler Integration**: One-command sysimage creation for instant startup
7. **Plots.jl Integration**: Display plots in terminal (kitty, wezterm image protocol)
8. **CUDA.jl Support**: GPU programming syntax highlighting and debugging

### Long-Term Vision

**Scientific Computing Hub**:
- Position Neovim as viable alternative to VSCode for Julia
- Integrate with other scientific languages (R, MATLAB, Python) via same REPL workflow
- Create unified data science environment (similar to Jupyter, but terminal-based)

**Community Contributions**:
- Publish `julia.lua` as standalone template for other configs
- Contribute improvements back to julia-vim, nvim-dap-julia
- Write blog post: "Julia Development in Neovim (2025)"

## Documentation Plan

### User-Facing Documentation

**Primary Guides** (already researched and structured):

1. **JULIA_INDEX.md**
   - Navigation hub for all Julia documentation
   - Quick reference with read times (2 min, 10 min, 60 min)
   - Document relationship diagram (Index → Quickstart → Guide → Summary)
   - Common questions with direct answers

2. **JULIA_QUICKSTART.md** (~2,000 words, 10-minute read)
   - **Target Audience**: New users wanting basic Julia support
   - **Structure**:
     - Prerequisites (Julia, tmux, Neovim 0.10+)
     - 5-step setup (copy-paste commands)
     - Essential keybindings (table format)
     - Testing checklist (5 verification steps)
     - Next steps (link to comprehensive guide)

3. **JULIA_DEVELOPMENT_GUIDE.md** (~12,000 words, 60-minute read)
   - **Target Audience**: Users wanting full Julia DX
   - **Structure**:
     - Introduction & Philosophy (REPL-driven development)
     - LSP Setup (LanguageServer.jl, Mason, manual installation)
     - REPL Integration (vim-slime, Revise.jl, cell execution)
     - LaTeX Symbols & Unicode (cmp-latex-symbols, julia-vim)
     - Debugging (nvim-dap-julia, DebugAdapter.jl)
     - Test Automation (Pkg.test, TestEnv.jl, coverage)
     - Performance Optimization (BenchmarkTools.jl, Profile.jl, PProf.jl, PackageCompiler)
     - Common Issues (7+ troubleshooting scenarios)
     - Best Practices (workflows, project organization)
     - Resources (40+ cited sources, official docs, tutorials)

4. **JULIA_RESEARCH_SUMMARY.md** (~3,000 words)
   - **Target Audience**: Contributors, maintainers
   - **Structure**:
     - Executive Summary
     - Plugin Ecosystem Analysis (Tier 1-3 plugins)
     - Gaps in Ecosystem (opportunities for contribution)
     - Comparison with VSCode/Vim Julia support
     - Integration Recommendations
     - Research Sources (40+ links)

### Internal Documentation

**CLAUDE.md Updates**:
- Add "Julia Development" section under "Language-Specific Configuration"
- Follow Python/Java documentation format
- Include keybindings, LSP features, testing commands
- Link to JULIA_INDEX.md for navigation

**QUICK_REFERENCE.md Updates**:
- Add Julia keybindings table (15+ commands)
- Group under "Language-Specific Commands → Julia"

**README.md Updates**:
- Add Julia to "Supported Languages" list
- Brief feature summary (1 paragraph)
- Link to JULIA_QUICKSTART.md

### Code Documentation

**Inline Comments** (in `lua/plugins/julia.lua`):
- Plugin purpose and features
- Configuration options explained
- Integration points with other plugins
- Performance considerations
- External dependencies noted

**Configuration Examples**:
- Every keybinding documented with `desc` parameter (which-key integration)
- Every plugin option explained with inline comment
- Links to official plugin documentation

### Maintenance Documentation

**What Needs Updating When**:
- **Julia version changes**: Update prerequisite versions in JULIA_QUICKSTART.md
- **LanguageServer.jl updates**: Review LSP configuration, test features
- **Plugin updates**: Check for breaking changes (vim-slime, nvim-dap-julia)
- **Neovim 0.11+ changes**: Test LSP compatibility, update vim.lsp.config syntax
- **New Julia features**: Document new language features, update examples

## References & Research

### Official Julia Resources

**Core Tools**:
- **LanguageServer.jl**: https://github.com/julia-vscode/LanguageServer.jl
  - Official Julia LSP server implementation
  - Used by VSCode Julia extension (battle-tested)
  - Full IntelliSense support (completion, hover, diagnostics)
- **LanguageServer.jl Docs**: https://www.julia-vscode.org/LanguageServer.jl/dev/
  - Configuration reference
  - SymbolServer caching explained
  - Performance optimization tips

**Julia Development Tools**:
- **Revise.jl**: https://timholy.github.io/Revise.jl/stable/
  - Auto-reload on file changes (no REPL restart)
  - Cornerstone of Julia interactive development
- **BenchmarkTools.jl**: https://github.com/JuliaCI/BenchmarkTools.jl
  - Statistical benchmarking (`@benchmark` macro)
  - Performance regression testing
- **Profile.jl**: https://docs.julialang.org/en/v1/manual/profile/
  - CPU profiling (flame graphs)
  - Built into Julia standard library
- **PProf.jl**: https://github.com/JuliaPerf/PProf.jl
  - Interactive web-based profiling UI
  - Google pprof integration
- **TestEnv.jl**: https://github.com/JuliaTesting/TestEnv.jl
  - Faster test iteration (avoids Pkg.test() overhead)
  - Activate test environment directly
- **TestItemRunner.jl**: https://github.com/julia-vscode/TestItemRunner.jl
  - VSCode-style `@testitem` macros
  - Granular test execution (run single test)

### Neovim Plugin Repositories

**Required Plugins**:
- **nvim-treesitter**: https://github.com/nvim-treesitter/nvim-treesitter
  - Julia parser status: ✅ Fully supported (H, L, F, I, J)
  - AST-based syntax highlighting
- **julia-vim**: https://github.com/JuliaEditorSupport/julia-vim
  - LaTeX-to-Unicode substitution (`\alpha<Tab>` → `α`)
  - Block-wise navigation (`]]`, `[[`, `aj`, `ij`)
  - Note: Conflicts with some completion plugins
- **vim-slime**: https://github.com/jpalardy/vim-slime
  - Language-agnostic REPL integration
  - Supports tmux, screen, kitty, neovim terminal
  - Mature, stable (10+ years development)
- **vim-julia-cell**: https://github.com/mroavi/vim-julia-cell
  - Jupyter-style cell execution (`##` markers)
  - Depends on vim-slime
- **cmp-latex-symbols**: https://github.com/kdheepak/cmp-latex-symbols
  - nvim-cmp source for LaTeX symbols
  - Uses `unimathsymbols.txt` database
- **nvim-dap-julia**: https://github.com/kdheepak/nvim-dap-julia
  - DAP adapter for Julia debugging
  - Wraps DebugAdapter.jl

**Alternative Plugins**:
- **iron.nvim**: https://github.com/Vigemus/iron.nvim
  - Alternative to vim-slime (no tmux required)
  - Uses Neovim built-in terminal
  - Floating window support
- **nvim-cmp-lua-latex-symbols**: https://github.com/amarz45/nvim-cmp-lua-latex-symbols
  - Pure Lua alternative to cmp-latex-symbols

### Community Resources

**Tutorials & Setup Guides**:
- **kdheepak's Guide**: https://kdheepak.com/blog/neovim-languageserver-julia/
  - Comprehensive LanguageServer.jl setup walkthrough
  - Author maintains several Julia Neovim plugins
- **NeoVim + Tmux for Julia**: https://forem.julialang.org/navi/set-up-neovim-tmux-for-a-data-science-workflow-with-julia-3ijk
  - Data science workflow focused
  - tmux configuration examples
- **Must-Have Julia Plugins**: https://dev.to/uncomfyhalomacro/the-must-have-neovim-plugins-for-julia-3j3m
  - Plugin recommendations (2024)
  - Performance tips
- **Julia Discourse - Tooling**: https://discourse.julialang.org/c/tooling/11
  - Community discussions (100+ posts)
  - Troubleshooting common issues

**Example Configurations**:
- **uncomfyhalomacro/erudite-vim**: https://github.com/uncomfyhalomacro/erudite-vim
  - Complete Julia Neovim config
  - Well-documented with inline comments
- **nvim-lua/kickstart.nvim**: https://github.com/nvim-lua/kickstart.nvim
  - Starter template with Julia support

### Integration References

**Internal File References** (this config):
- **Python Dual LSP Pattern**: `lua/plugins/lsp.lua:39-76` (Ruff + basedpyright)
- **Java Compile-Only Pattern**: `lua/plugins/development-algorithm.lua:48-58` (treesitter + manual javac)
- **Go LSP Setup**: `lua/plugins/lsp.lua:104-114` (gopls with auto-format)
- **Mason Auto-Install**: `lua/plugins/mason.lua:15-38` (ensure_installed list)
- **DAP Python Config**: `lua/plugins/dap.lua:74-149` (nvim-dap-python + pytest)
- **Test Automation Pattern**: `lua/plugins/development-algorithm.lua:44-100` (filetype detection)
- **Filetype Settings**: `after/ftplugin/python.lua`, `after/ftplugin/java.lua`, `after/ftplugin/go.lua`

**Documentation Templates**:
- **Comprehensive Guide**: `JAVA_DEVELOPMENT_GUIDE.md` (~8,000 words)
- **Best Practices**: `JAVA_DEVELOPMENT_BEST_PRACTICES_2025.md` (~6,000 words)
- **Quick Reference**: `QUICK_REFERENCE.md` (2-minute read)
- **Master Index**: `MASON_INDEX.md` (navigation hub)

### Research Methodology

**Sources Verified** (40+ authoritative sources):
- ✅ Official Julia projects (LanguageServer.jl, julia-vim)
- ✅ Official Neovim projects (nvim-lspconfig, nvim-treesitter, nvim-dap)
- ✅ Maintained community plugins (kdheepak's suite, vim-slime)
- ✅ Julia Discourse discussions (Tooling category)
- ✅ JuliaBloggers tutorials
- ✅ GitHub issues and pull requests

**No unverified sources used** — All recommendations traceable to official docs or widely-adopted community projects.

---

## Implementation Notes

**Alignment with Existing Systems**:
- Follows Mason.nvim architecture (`mason.lua:15-38` pattern)
- Integrates with development algorithm (`<leader>Dt*` keymaps)
- Uses established LSP patterns (`lsp.lua:28-92` server_configs)
- Follows filetype plugin conventions (`after/ftplugin/<language>.lua`)
- Documentation matches project style (ALL_CAPS.md, comprehensive guides)

**Minimal Invasiveness**:
- No changes to core Neovim config (`init.lua` untouched)
- No changes to existing language configurations
- Lazy-loads all Julia plugins (`ft = 'julia'`)
- Julia-specific keymaps under `<leader>j*` (no conflicts)

**AI-Era Development Considerations**:
- REPL-driven workflow complements AI pair programming
- Quick iteration with Revise.jl enables rapid prototyping
- Cell-based execution allows testing AI-generated code snippets
- Comprehensive documentation enables AI assistants to help users
