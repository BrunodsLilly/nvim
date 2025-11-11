# Julia Neovim Research Summary

**Research Date:** 2025-11-11
**Research Scope:** Comprehensive Julia development setup for Neovim based on 2025 standards

---

## Executive Summary

Julia development in Neovim is **mature and production-ready** in 2025, with excellent LSP support, REPL integration, debugging, and visualization capabilities. The ecosystem has converged on best practices that rival or exceed VSCode's Julia extension.

**Key Finding:** The bottleneck is LSP startup time (20-30s), solvable with PackageCompiler sysimages (reduces to 0.5s).

---

## Documents Created

1. **JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md** - Comprehensive guide (12,000+ words)
   - Authoritative sources cited throughout
   - Step-by-step configurations
   - Troubleshooting for common issues
   - Community recommendations

2. **JULIA_QUICKSTART.md** - 10-minute setup guide
   - Minimal working configuration
   - Copy-paste ready code
   - Essential keybindings
   - Testing checklist

3. **This file (JULIA_RESEARCH_SUMMARY.md)** - Research findings overview

---

## Research Questions Answered

### 1. Julia LSP Setup

**Recommended LSP:** LanguageServer.jl (official implementation)
- **Installation:** `julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'`
- **Features:** Completions, go-to-definition, hover docs, diagnostics, formatting, refactoring
- **Performance:** 20-30s first response (fixable with PackageCompiler sysimage → 0.5s)
- **Configuration:** Works seamlessly with nvim-lspconfig and Mason.nvim

**Key Gotcha:** Projects must be instantiated (`Pkg.instantiate()`) for LSP to recognize dependencies.

**Sources:**
- [julia-vscode/LanguageServer.jl](https://github.com/julia-vscode/LanguageServer.jl)
- [nvim-lspconfig Julia configuration](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/julials.lua)
- [Julia Discourse: Neovim + LanguageServer.jl](https://discourse.julialang.org/t/neovim-languageserver-jl/37286) (100+ community posts)

---

### 2. Julia Development Tools

#### REPL Integration

**Winner:** vim-slime (most popular, stable, simple)
- **Alternatives:** iron.nvim (more complex), REPLSmuggler.jl (experimental)
- **Best workflow:** Neovim + tmux + Julia REPL + Revise.jl
  - Send code with `<C-c><C-c>`
  - Revise.jl auto-reloads source changes
  - No REPL restarts needed
- **Tmux workflow:** Split pane, start Julia REPL, send code from buffer
- **Kitty alternative:** Works well, enables graphics with KittyTerminalImages.jl

**Sources:**
- [jpalardy/vim-slime](https://github.com/jpalardy/vim-slime)
- [Julia + Neovim + Tmux workflow](https://forem.julialang.org/navi/set-up-neovim-tmux-for-a-data-science-workflow-with-julia-3ijk)

#### Debugging Tools

**Solution:** nvim-dap + DebugAdapter.jl + nvim-dap-julia
- **Status:** DebugAdapter.jl support merged July 2024, actively maturing
- **Features:** Breakpoints, step-through, variable inspection, DAP UI
- **Plugins:**
  - [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) - Core DAP client
  - [kdheepak/nvim-dap-julia](https://github.com/kdheepak/nvim-dap-julia) - Julia adapter
  - [rcarriga/nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - Visual debugger UI
- **Limitation:** Not as mature as VSCode Julia debugger yet

**Sources:**
- [Discourse: Neovim + DebugAdapter.jl](https://discourse.julialang.org/t/neovim-debugadapter-jl/116529)
- [nvim-dap Julia configuration discussion](https://github.com/mfussenegger/nvim-dap/discussions/531)

#### Test Runners

**Two approaches:**

1. **Pkg.test() - Thorough testing**
   - Creates isolated environment
   - Checks all dependencies
   - Run before commits, in CI/CD
   - Slow (30s-2min)

2. **Interactive REPL testing - Rapid iteration**
   - `using Revise; using TestEnv; TestEnv.activate()`
   - `include("test/runtests.jl")`
   - No startup time, instant feedback
   - Best for development

**No mature Neotest adapter yet** - Opportunity for contribution!

**Sources:**
- [Julia Testing Best Practices](https://erikexplores.substack.com/p/julia-testing-best-pratice)
- [Julia Test stdlib documentation](https://docs.julialang.org/en/v1/stdlib/Test/)

#### Package Management

**Built-in Pkg.jl** - No Neovim-specific integration needed
- Manage via Julia REPL (REPL mode: `]`)
- `add Package`, `remove Package`, `update`, `status`
- **No Telescope extension exists** for package browsing (yet)

**Note:** No telescope-pkg.jl or similar plugin found in research.

#### Formatter

**JuliaFormatter.jl** - Integrated with LanguageServer.jl
- **Configuration:** `.JuliaFormatter.toml` in project root
- **LSP formatting:** Works via `vim.lsp.buf.format()`
- **Format on save:** Configure in LSP `on_attach`
- **Performance:** Slow (10-20s), fixable with PackageCompiler sysimage (1-2s)

**Plugin alternatives:**
- [kdheepak/JuliaFormatter.vim](https://github.com/kdheepak/JuliaFormatter.vim) - Standalone plugin
- **Note:** LSP formatting preferred in 2025, plugin may be unnecessary

**Gotcha:** LSP root detection - formatter doesn't search parent directories for `.JuliaFormatter.toml`

**Sources:**
- [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)
- [Discourse: Formatter configuration](https://discourse.julialang.org/t/configuring-julia-formatter-and-linter-with-nvim-lspconfig-for-neovim/114746)

---

### 3. Julia-Specific Features

#### Plotting Integration

**Four approaches:**

1. **KittyTerminalImages.jl** (Best for Kitty terminal)
   - Displays plots inline using Kitty Graphics Protocol
   - Requires: Kitty terminal, macOS/Linux
   - Limitation: Doesn't work with tmux/screen
   - Source: [KittyTerminalImages.jl](https://github.com/simonschoelly/KittyTerminalImages.jl)

2. **image.nvim** (Best for rich media)
   - Displays saved PNG/JPG files in Neovim
   - Works with Kitty + tmux
   - Workflow: `savefig("plot.png")` then view in Neovim
   - Source: [3rd/image.nvim](https://github.com/3rd/image.nvim)

3. **UnicodePlots.jl** (Best for tmux/SSH)
   - ASCII art plots in terminal
   - Works everywhere, even slow SSH
   - Lower quality but universal
   - Source: [UnicodePlots.jl](https://github.com/JuliaPlots/UnicodePlots.jl)

4. **External window** (Fallback)
   - `gr()` backend opens separate window
   - Traditional approach, always works
   - Best for high-quality publication figures

**Recommendation matrix:**
- Kitty (no tmux) → KittyTerminalImages.jl
- Kitty + tmux → image.nvim + savefig()
- iTerm2/Alacritty → UnicodePlots.jl
- SSH/Remote → UnicodePlots.jl
- WSL/Windows → External window (gr)

#### Notebook Support

**vim-pluto** - Pluto.jl notebook integration
- Edit `.jl` notebook files in Neovim
- Sync with Pluto web UI
- Insert cells with commands
- **Status:** Active development (main = helper, dev = full frontend)
- **Source:** [hasundue/vim-pluto](https://github.com/hasundue/vim-pluto)

**Alternative:** Use Jupyter with Pluto kernel (standard Jupyter workflows apply)

#### Unicode Input Methods

**Three methods:**

1. **julia-vim Tab completion** (Recommended - muscle memory from REPL)
   - Type `\alpha<Tab>` → `α`
   - Partial matches show completion list
   - Works exactly like Julia REPL
   - Limitation: May conflict with other Tab completions

2. **cmp-latex-symbols** (Recommended for nvim-cmp users)
   - Integrates with nvim-cmp completion pipeline
   - Shows Unicode preview in completion menu
   - Uses same Julia REPL symbol database
   - Source: [kdheepak/cmp-latex-symbols](https://github.com/kdheepak/cmp-latex-symbols)

3. **Auto-as-you-type** (julia-vim advanced mode)
   - `vim.g.latex_to_unicode_auto = 1`
   - Automatically substitutes without Tab
   - Fastest but can be surprising

**Community consensus:** julia-vim Tab completion or cmp-latex-symbols, depending on completion setup.

**Symbol database:** Uses Julia's `unimathsymbols.txt` (700+ symbols)
- Full list: [Julia Unicode Input](https://docs.julialang.org/en/v1/manual/unicode-input/)

#### Macro Expansion

**No dedicated tool found** - Gap in ecosystem
- LSP provides basic macro understanding
- No visual macro expansion viewer like VSCode
- Workaround: Use `@macroexpand` in REPL

**Opportunity for plugin development!**

#### Type Inspection

**LSP hover provides:**
- Function signatures with types
- Type definitions
- Docstrings

**No dedicated type inspector** like VSCode's Julia extension
- Workaround: Use `typeof()`, `fieldnames()`, `methods()` in REPL

---

### 4. Community Recommendations

#### Popular Configurations

**Top Neovim frameworks with Julia support:**

| Framework | Stars | Maturity | Julia Setup |
|-----------|-------|----------|-------------|
| [NvChad](https://nvchad.com/) | 25k+ | Stable | Via Mason, documented |
| [AstroNvim](https://astronvim.com/) | 13k+ | Stable | Built-in, extensive |
| [LunarVim](https://www.lunarvim.org/) | 18k+ | Stable | Documented examples |
| [LazyVim](https://www.lazyvim.org/) | 17k+ | Stable | Via Mason, conform.nvim |

**Recommendation:** Start with AstroNvim or NvChad for batteries-included setup.

#### Key Dotfile References

1. **Fredrik Ekre's .dotfiles**
   - URL: https://github.com/fredrikekre/.dotfiles
   - Notable: Makefile for LanguageServer sysimage
   - Audience: Performance enthusiasts

2. **LunarVim Julia docs**
   - URL: https://www.lunarvim.org/docs/features/supported-languages/julia
   - Notable: Pre-configured setup
   - Audience: Quick start users

#### Community Resources

**Blogs:**
- [Setting Up Julia LSP for Neovim (Jacob Zelko)](https://jacobzelko.com/08312022162228-julia-lsp-setup/)
- [Neovim + Tmux for Julia Data Science (Navi)](https://forem.julialang.org/navi/set-up-neovim-tmux-for-a-data-science-workflow-with-julia-3ijk)
- [Must-Have Neovim Plugins for Julia (DEV Community)](https://dev.to/uncomfyhalomacro/the-must-have-neovim-plugins-for-julia-3j3m)

**Discourse Threads:**
- [Neovim + LanguageServer.jl](https://discourse.julialang.org/t/neovim-languageserver-jl/37286) - 100+ posts, most active
- [Neovim and Julia - setup advice](https://discourse.julialang.org/t/neovim-and-julia-setup-advice/17393) - Beginner-friendly

#### Known Issues & Gotchas

**Top 7 issues from research:**

1. **"Package LanguageServer not found"**
   - Cause: Not installed in correct environment
   - Fix: `julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'`

2. **LSP doesn't recognize project packages**
   - Cause: Project not instantiated
   - Fix: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`

3. **Missing reference warnings for stdlib**
   - Cause: SymbolServer cache issues
   - Fix: Clear cache or disable warnings in LSP settings

4. **julia-vim conflicts with nvim-cmp**
   - Cause: Tab mapping collision
   - Fix: Use cmp-latex-symbols or `<C-X><C-U>` instead

5. **Slow formatting (10-20s)**
   - Cause: JIT compilation overhead
   - Fix: PackageCompiler sysimage

6. **Formatter ignores .JuliaFormatter.toml**
   - Cause: LSP root is subfolder
   - Fix: Configure root_dir pattern or duplicate config file

7. **Treesitter context errors**
   - Cause: Julia parser updates
   - Fix: Disable context for Julia or update parser

**Sources:** Compiled from GitHub issues, Discourse posts, Stack Overflow questions.

---

### 5. Performance Optimization

**Problem:** LanguageServer.jl startup time (20-30s)

**Solution:** PackageCompiler.jl custom sysimage
- **Impact:** 20-30s → 0.5s (40-60x speedup)
- **Disk space:** 500MB (uncompressed), 150MB (compressed, 2025 improvement)
- **Setup complexity:** Moderate (one-time, well-documented)

**Implementation:**
1. Install PackageCompiler.jl
2. Create precompile script capturing LSP operations
3. Build sysimage with `create_sysimage([:LanguageServer, :SymbolServer])`
4. Create wrapper Julia executable
5. Configure nvim-lspconfig to use wrapper

**Sources:**
- [PackageCompiler.jl documentation](https://julialang.github.io/PackageCompiler.jl/dev/)
- [Discourse: PackageCompiled LanguageServer](https://discourse.julialang.org/t/neovim-native-lsp-with-julials-using-packagecompiled-languageserver/57659)
- [Fredrik Ekre's Makefile](https://github.com/fredrikekre/.dotfiles)

**Recent improvements (2025):**
- Sysimage compression: ~70% size reduction
- Startup improvements in Julia 1.11+

---

## Plugin Ecosystem Summary

### Must-Have Plugins (Tier 1)

| Plugin | Purpose | Authority | Stars |
|--------|---------|-----------|-------|
| nvim-lspconfig | LSP client | Official Neovim | 10k+ |
| julia-vim | Syntax + Unicode | JuliaEditorSupport | 400+ |
| nvim-treesitter | Modern syntax | nvim-treesitter org | 10k+ |

### Recommended Plugins (Tier 2)

| Plugin | Purpose | Maintained By | Stars |
|--------|---------|---------------|-------|
| vim-slime | REPL integration | jpalardy | 1.8k+ |
| cmp-latex-symbols | Unicode completion | kdheepak | 80+ |
| nvim-dap | Debugging | mfussenegger | 5k+ |
| nvim-dap-julia | Julia DAP adapter | kdheepak | 10+ |

### Optional Plugins (Tier 3)

| Plugin | Purpose | Use Case | Stars |
|--------|---------|----------|-------|
| vim-pluto | Notebook editing | Pluto.jl users | 20+ |
| image.nvim | Image display | Data science | 800+ |
| JuliaFormatter.vim | Formatting | If not using LSP | 100+ |

**Note:** LSP formatting has replaced standalone formatter plugins for most users.

---

## Gaps in Ecosystem (Opportunities)

Research identified these missing pieces:

1. **Neotest Julia adapter** - Test runner integration with `@testset` parsing
2. **Macro expansion viewer** - Visual tool for `@macroexpand` results
3. **Type inspector UI** - Interactive type browser like VSCode Julia extension
4. **Telescope package manager** - Browse Julia packages via Telescope
5. **Advanced plot integration** - Better tmux + graphics protocol support

**All are feasible plugin projects!**

---

## Best Practices Summary

### Essential Setup (30 minutes)

1. Install LanguageServer.jl in `~/.julia/environments/nvim-lspconfig`
2. Add julia-vim, nvim-lspconfig, vim-slime to Neovim
3. Instantiate project with `Pkg.instantiate()`
4. Configure LSP format-on-save
5. Set up tmux + Julia REPL workflow

**Result:** Production-ready Julia development

### Recommended Enhancements (2 hours)

6. Build PackageCompiler sysimage (instant LSP startup)
7. Configure nvim-dap for debugging
8. Set up plotting (KittyTerminalImages or UnicodePlots)
9. Add cmp-latex-symbols for better Unicode completion
10. Learn Revise.jl workflow for rapid iteration

**Result:** VSCode-equivalent or better experience

### Advanced Optimization (4+ hours)

11. Create JuliaFormatter sysimage (instant formatting)
12. Configure vim-pluto for notebook editing
13. Set up REPLSmuggler for better diagnostics
14. Customize LSP settings (disable noisy warnings)
15. Create project-specific .JuliaFormatter.toml

**Result:** Elite Julia development environment

---

## Comparison with Other Editors

| Feature | Neovim (2025) | VSCode Julia | Vim + Plugins |
|---------|---------------|--------------|---------------|
| LSP Support | Excellent (LS.jl) | Excellent | Good (requires setup) |
| REPL Integration | Excellent (slime) | Excellent | Good (vim-slime) |
| Debugging | Good (improving) | Excellent | Limited |
| Plotting | Good (terminal-dep) | Excellent | Limited |
| Unicode Input | Excellent | Excellent | Excellent |
| Startup Time | Instant (sysimage) | Slow | Instant |
| Performance | Excellent | Good | Excellent |
| Customization | Extreme | Moderate | Moderate |
| Learning Curve | Steep | Gentle | Moderate |

**Verdict:** Neovim rivals VSCode for Julia development, with better performance and customization at the cost of steeper initial setup.

---

## Authoritative Sources

All research based on:

**Official Julia Projects:**
- julia-vscode/LanguageServer.jl
- JuliaEditorSupport/julia-vim
- Julia documentation and Pkg.jl

**Official Neovim Projects:**
- neovim/nvim-lspconfig
- nvim-treesitter/nvim-treesitter
- mfussenegger/nvim-dap

**Community Plugins:**
- kdheepak's Julia plugins (cmp-latex-symbols, nvim-dap-julia, JuliaFormatter.vim)
- jpalardy/vim-slime
- 3rd/image.nvim

**Community Discussions:**
- Julia Discourse (Tooling category)
- Neovim Discourse
- GitHub issues and discussions

**Blogs and Tutorials:**
- Jacob Zelko (Julia LSP setup)
- Navi (Neovim + Tmux + Julia workflow)
- DEV Community (Must-have plugins)
- Erik Engheim (Julia testing best practices)

**No Reddit/Twitter/unverified sources used** - All recommendations traceable to official docs or widely-adopted community projects.

---

## Integration with This Neovim Config

### Current State

**Already configured:**
- nvim-lspconfig (supports julials via Mason)
- nvim-treesitter (can install julia parser)
- nvim-dap (debugging infrastructure)
- Mason.nvim (auto-install julials)

**Not yet configured:**
- julia-vim (Unicode completion)
- vim-slime (REPL integration)
- Julia-specific keymaps
- Format-on-save for Julia

### Recommended Additions

**Add to `lua/plugins/mason.lua`:**
```lua
ensure_installed = {
  'julials',  -- Add to existing list
  -- ... other servers
}
```

**Create `lua/plugins/julia.lua`:**
```lua
-- See JULIA_QUICKSTART.md for complete configuration
```

**Create `after/ftplugin/julia.lua`:**
```lua
-- Julia-specific settings (see best practices doc)
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.commentstring = '# %s'
```

**Add language-aware test commands:**
```lua
-- In lua/plugins/development-algorithm.lua
-- Add Julia detection to test automation
```

---

## Conclusion

Julia development in Neovim is **production-ready** with excellent tooling:

**Strengths:**
- Mature LSP (LanguageServer.jl)
- Excellent REPL integration (vim-slime + Revise.jl)
- Perfect Unicode input (julia-vim or cmp-latex-symbols)
- Performance optimization available (PackageCompiler)
- Active community support

**Weaknesses:**
- LSP startup time without sysimage (fixable)
- Debugging less mature than VSCode (improving)
- No Neotest adapter yet (gap)
- Terminal graphics limited (terminal-dependent)

**Recommendation:** Julia in Neovim matches or exceeds VSCode for most workflows, especially with PackageCompiler optimization.

---

**Research completed:** 2025-11-11
**Documents created:** 3 (Best Practices, Quickstart, Summary)
**Total sources reviewed:** 40+ (GitHub repos, Discourse threads, documentation)
**Setup time estimate:** 10 min (basic) to 6 hours (elite)
**Next steps:** Implement julia.lua plugin configuration, test with real Julia project
