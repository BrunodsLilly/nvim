# Julia Neovim Quick Start Guide

**Goal:** Get Julia development working in Neovim in 10 minutes.

**For comprehensive details, see:** [JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md](/Users/brunodossantos/.config/nvim/JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md)

---

## Step 1: Install LanguageServer.jl (2 minutes)

```bash
# Install in dedicated Neovim environment
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
```

**Why this path?** nvim-lspconfig expects LanguageServer here by default.

---

## Step 2: Add Julia Plugins to Neovim (3 minutes)

Create `~/.config/nvim/lua/plugins/julia.lua`:

```lua
return {
  -- Treesitter for syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { 'julia' })
    end,
  },

  -- LSP setup
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        julials = {},  -- Julia Language Server
      },
    },
  },

  -- Julia syntax and Unicode tab completion
  {
    'JuliaEditorSupport/julia-vim',
    ft = 'julia',
  },

  -- REPL integration with tmux
  {
    'jpalardy/vim-slime',
    ft = 'julia',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = { socket_name = 'default', target_pane = '{last}' }
    end,
  },
}
```

**If you're using this config:** The Julia LSP is already in Mason's `ensure_installed`, so it will auto-install on next Neovim start.

---

## Step 3: Instantiate Your Julia Project (1 minute)

```bash
cd /path/to/your/julia-project
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

**This is required** for the LSP to recognize your project's dependencies.

---

## Step 4: Open Julia File and Test LSP (2 minutes)

```bash
nvim src/main.jl
```

**Wait for LSP to start** (first time: 20-30 seconds, shows "Received new data from Julia Symbol Server")

**Test features:**
- Type `\alpha<Tab>` → Should substitute to `α` (Unicode completion)
- Type `using` and see completion suggestions (LSP working)
- Hover over function name with `K` (shows documentation)
- `gd` on function call → Go to definition

---

## Step 5: REPL Integration (2 minutes)

**In tmux:**
1. Split pane: `<C-b>%` (vertical) or `<C-b>"` (horizontal)
2. Start Julia REPL: `julia --project=.`
3. In REPL: `using Revise` (for auto-reloading)
4. Back in Neovim: Position cursor in function, press `<C-c><C-c>` (sends to REPL)
5. See code execute in REPL pane

**Not using tmux?** Change vim-slime target:
```lua
vim.g.slime_target = 'neovim'  -- or 'kitty', 'wezterm'
```

---

## Essential Keybindings

**LSP (works automatically):**
- `gd` - Go to definition
- `gr` - Show references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

**Julia-vim (Unicode):**
- `\alpha<Tab>` → `α`
- `\sum<Tab>` → `∑`
- `\in<Tab>` → `∈`
- Full list: [Julia Unicode Input](https://docs.julialang.org/en/v1/manual/unicode-input/)

**vim-slime (REPL):**
- `<C-c><C-c>` - Send paragraph to REPL
- Visual select + `<C-c><C-c>` - Send selection to REPL

---

## Common First-Time Issues

**Issue:** "Package LanguageServer not found"
```bash
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
```

**Issue:** LSP doesn't recognize my packages
```bash
cd /path/to/project
julia --project=. -e 'using Pkg; Pkg.instantiate()'
:LspRestart  # In Neovim
```

**Issue:** Unicode tab completion doesn't work
```lua
-- Check that julia-vim is loaded for .jl files
:echo &filetype  " Should show 'julia'
:echo g:latex_to_unicode_tab  " Should be 1
```

---

## Next Steps

**Want instant LSP startup?** Create a PackageCompiler sysimage:
- See [Performance Optimization section](JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md#performance-optimization)
- Reduces startup from 20s → 0.5s

**Want debugging?** Add nvim-dap:
- See [Debugging Configuration section](JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md#debugging-configuration)
- Breakpoints, step-through, variable inspection

**Want plotting in terminal?** Install KittyTerminalImages.jl:
- See [Plotting and Visualization section](JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md#plotting-and-visualization)
- Requires Kitty terminal

---

## Testing Your Setup

Create `test.jl`:

```julia
using Test

# Test Unicode input works
α = 1
β = 2
∑ = α + β

@testset "Basic Tests" begin
    @test ∑ == 3
end

# Test LSP hover (hover over 'sum' with K in Neovim)
function sum_numbers(x, y)
    return x + y
end

# Test go-to-definition (gd on 'sum_numbers' below)
result = sum_numbers(5, 10)
```

**Open in Neovim:** `nvim test.jl`

**Test checklist:**
- [ ] Syntax highlighting works
- [ ] `\alpha<Tab>` creates `α`
- [ ] Hover on `sum_numbers` with `K` shows signature
- [ ] `gd` on `sum_numbers` goes to definition
- [ ] `<C-c><C-c>` sends code to REPL (if tmux open)

**All working?** You're ready for Julia development!

---

## Minimal Configuration Summary

**Required:**
1. LanguageServer.jl installed in `~/.julia/environments/nvim-lspconfig`
2. nvim-lspconfig with `julials` server
3. julia-vim for syntax + Unicode
4. Project instantiated with `Pkg.instantiate()`

**Recommended:**
5. vim-slime for REPL integration
6. nvim-treesitter for modern syntax highlighting
7. Revise.jl in Julia for auto-reloading

**Optional but powerful:**
8. PackageCompiler.jl sysimage (speed)
9. nvim-dap + DebugAdapter.jl (debugging)
10. KittyTerminalImages.jl (plotting)

---

**Time to productivity:** 10 minutes
**Full documentation:** [JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md](JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md)
**Questions?** See [Common Issues section](JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md#common-issues-and-solutions)
