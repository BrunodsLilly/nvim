# Julia Development Best Practices for Neovim (2025)

This document provides comprehensive, research-backed best practices for setting up Julia development in Neovim based on current industry standards, community recommendations, and official documentation.

---

## Table of Contents

1. [Quick Start Summary](#quick-start-summary)
2. [Julia LSP Setup](#julia-lsp-setup)
3. [Essential Plugins](#essential-plugins)
4. [REPL Integration](#repl-integration)
5. [Debugging Configuration](#debugging-configuration)
6. [Formatting and Linting](#formatting-and-linting)
7. [Unicode Input Methods](#unicode-input-methods)
8. [Testing Workflows](#testing-workflows)
9. [Plotting and Visualization](#plotting-and-visualization)
10. [Performance Optimization](#performance-optimization)
11. [Common Issues and Solutions](#common-issues-and-solutions)
12. [Popular Community Configurations](#popular-community-configurations)

---

## Quick Start Summary

**Must-Have Components (Minimum Viable Setup):**
1. **LanguageServer.jl** - LSP for completions, go-to-definition, diagnostics
2. **nvim-lspconfig** - Neovim's built-in LSP client configuration
3. **julia-vim** - Syntax highlighting + Unicode tab completion
4. **vim-slime** or **iron.nvim** - REPL integration
5. **nvim-treesitter** - Modern syntax highlighting and code navigation

**Recommended for Production:**
- PackageCompiler.jl sysimage for instant LSP startup
- nvim-dap + DebugAdapter.jl for debugging
- JuliaFormatter.jl integration for consistent formatting
- cmp-latex-symbols for nvim-cmp Unicode completion

---

## Julia LSP Setup

### Installation

**Step 1: Install LanguageServer.jl in dedicated environment**

```bash
# Create dedicated environment for Neovim LSP
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
```

**Why a dedicated environment?** This prevents conflicts with your project dependencies and ensures the LSP is always available regardless of which Julia project you're working on.

**Step 2: Update existing installation**

```bash
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
```

### Basic nvim-lspconfig Configuration

Add to your `lua/plugins/lsp.lua` or equivalent:

```lua
-- Basic setup
require('lspconfig').julials.setup{}

-- Or with Mason.nvim integration
require('mason-lspconfig').setup({
  ensure_installed = {
    'julials',
    -- other servers...
  },
})
```

### Advanced Configuration with Custom Julia Executable

For faster startup with a custom sysimage (see [Performance Optimization](#performance-optimization)):

```lua
require('lspconfig').julials.setup({
  on_new_config = function(new_config, _)
    local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
    if require('lspconfig').util.path.is_file(julia) then
      new_config.cmd[1] = julia
    end
  end,
  settings = {
    julia = {
      -- Optional: disable lint hints if too noisy
      lint = {
        missingrefs = "none",
      },
    },
  },
})
```

### Project-Specific Setup

**CRITICAL:** For LanguageServer.jl to pick up your project's dependencies, you must instantiate the project:

```bash
cd /path/to/my/julia-project
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

Without this, the LSP won't recognize your project-specific packages.

### First-Time Behavior

When you first open a `.jl` file:
1. LanguageServer.jl starts (may take 20-30 seconds initially)
2. SymbolServer.jl begins caching symbols for all loaded packages
3. You'll see "Received new data from Julia Symbol Server" when ready
4. Subsequent opens are faster as symbols are cached

**Authoritative Source:** [julia-vscode/LanguageServer.jl](https://github.com/julia-vscode/LanguageServer.jl) (Official implementation)

---

## Essential Plugins

### Must-Have (Tier 1)

#### 1. **nvim-lspconfig**
```lua
{
  'neovim/nvim-lspconfig',
  config = function()
    require('lspconfig').julials.setup{}
  end,
}
```
**Purpose:** Native LSP client configuration for Neovim
**Authority:** Official Neovim project
**Source:** [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

#### 2. **julia-vim**
```lua
{
  'JuliaEditorSupport/julia-vim',
  ft = 'julia',
}
```
**Features:**
- LaTeX-to-Unicode tab completion (\alpha<Tab> → α)
- Enhanced syntax highlighting
- Julia-specific indentation rules
- Block selection helpers

**Configuration:**
```lua
-- Enable LaTeX-to-Unicode substitution (default is enabled)
vim.g.latex_to_unicode_auto = 0  -- Disable auto-mode (use Tab trigger)
vim.g.latex_to_unicode_tab = 1   -- Enable Tab completion (recommended)
```

**Alternative completion:** `<C-X><C-U>` in insert mode (doesn't require Tab mapping)

**Authority:** JuliaEditorSupport organization (official Julia community)
**Source:** [JuliaEditorSupport/julia-vim](https://github.com/JuliaEditorSupport/julia-vim)

#### 3. **nvim-treesitter**
```lua
{
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'julia', 'lua', 'python', 'markdown' },
      highlight = { enable = true },
      incremental_selection = { enable = true },
      textobjects = { enable = true },
    })
  end,
}
```
**Why Treesitter?** Modern AST-based syntax highlighting, better than regex-based highlighting
**Julia-specific feature:** Embedded syntax highlighting for SQL/shell code in Julia strings

**Install Julia parser:**
```vim
:TSInstall julia
```

**Source:** [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### Recommended (Tier 2)

#### 4. **vim-slime** (REPL Integration - Most Popular)
```lua
{
  'jpalardy/vim-slime',
  ft = 'julia',
  config = function()
    vim.g.slime_target = 'tmux'  -- or 'kitty', 'neovim', 'wezterm'
    vim.g.slime_paste_file = vim.fn.expand("$HOME/.slime_paste")
    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = "{last}",
    }
  end,
}
```
**Workflow:**
1. Open Julia REPL in tmux split: `<C-b>%` (vertical) or `<C-b>"` (horizontal)
2. Start Julia: `julia --project=.`
3. Send code from buffer: `<C-c><C-c>` (paragraph) or visual selection
4. REPL executes code like in VSCode

**Why vim-slime over iron.nvim?** Community prefers vim-slime for Julia based on discourse discussions and blog posts. It's simpler, more stable, and works seamlessly with tmux/kitty.

**Source:** [jpalardy/vim-slime](https://github.com/jpalardy/vim-slime)

**Alternative:** [iron.nvim](https://github.com/Vigemus/iron.nvim) - More complex but provides built-in REPL management

#### 5. **cmp-latex-symbols** (Unicode Completion for nvim-cmp)
```lua
{
  'hrsh7th/nvim-cmp',
  dependencies = {
    'kdheepak/cmp-latex-symbols',
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
        {
          name = 'latex_symbols',
          option = {
            strategy = 0,  -- 0: mixed, 1: julia, 2: latex
          },
        },
        { name = 'buffer' },
      },
    })
  end,
}
```
**Purpose:** Replaces julia-vim's Tab completion if you use nvim-cmp
**Data source:** Uses Julia REPL's unimathsymbols.txt
**Why use this?** Integrates Unicode completion with your existing completion pipeline instead of separate Tab mapping

**Note:** If julia-vim conflicts with nvim-cmp, use this plugin instead.

**Source:** [kdheepak/cmp-latex-symbols](https://github.com/kdheepak/cmp-latex-symbols)

### Optional but Powerful (Tier 3)

#### 6. **JuliaFormatter.vim**
```lua
{
  'kdheepak/JuliaFormatter.vim',
  ft = 'julia',
}
```
**NOTE:** LanguageServer.jl now includes JuliaFormatter.jl support, so you may not need this plugin if you use LSP formatting.

**Keybindings (if using the plugin):**
```lua
vim.keymap.set('n', '<leader>jf', ':JuliaFormatterFormat<CR>', { desc = 'Format Julia file' })
```

**Source:** [kdheepak/JuliaFormatter.vim](https://github.com/kdheepak/JuliaFormatter.vim)

#### 7. **vim-pluto** (Pluto.jl Notebook Integration)
```lua
{
  'hasundue/vim-pluto',
  ft = 'julia',
}
```
**Workflow:**
- Edit `.jl` notebook files in Neovim
- Open same notebook in Pluto web UI
- Changes sync between editor and browser
- Insert cells with `:PlutoCellAbove` / `:PlutoCellBelow`

**Status:** Active development, main branch is minimal helper, dev branch is full front-end

**Source:** [hasundue/vim-pluto](https://github.com/hasundue/vim-pluto)

---

## REPL Integration

### Best Practice Workflow: Neovim + Tmux + Julia REPL

**Setup:**
1. Start tmux session: `tmux`
2. Open Julia project in Neovim: `nvim src/main.jl`
3. Split tmux pane: `<C-b>%` (vertical) or `<C-b>"` (horizontal)
4. Start Julia REPL in split: `julia --project=.`
5. Activate Revise.jl for auto-reload:
   ```julia
   using Revise
   using MyPackage
   ```

**Sending Code to REPL (with vim-slime):**
- Send current paragraph: `<C-c><C-c>`
- Send visual selection: `V` (select lines) then `<C-c><C-c>`
- Send entire file: `ggVG<C-c><C-c>`

**Why Revise.jl?** Automatically reloads source code changes without restarting REPL, dramatically speeding up iteration.

### Alternative: Kitty Terminal with vim-slime

```lua
vim.g.slime_target = 'kitty'
vim.g.slime_default_config = {
  window_type = "tab",  -- or "window"
}
```

**Kitty workflow:**
1. `kitty --start-as=fullscreen`
2. `<C-Shift-Enter>` to create new window
3. Start Julia in new window
4. Send code with `<C-c><C-c>` from Neovim

**Advantage over tmux:** Native image display with Kitty Graphics Protocol (see [Plotting](#plotting-and-visualization))

### REPLSmuggler.jl (Advanced - Diagnostics from REPL)

```bash
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("REPLSmuggler")'
```

**Purpose:** Sends code to Julia REPL and gets diagnostics back in Neovim
**Use case:** Correct line numbering in exceptions, better error messages
**Source:** [REPLSmuggler.jl announcement](https://discourse.julialang.org/t/ann-replsmuggler-jl-send-code-to-your-julia-repl-and-get-neo-vim-diagnostics-in-return/111420)

---

## Debugging Configuration

### nvim-dap Setup for Julia

**Step 1: Install Julia Debug Adapter**

```bash
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("DebugAdapter")'
```

**Step 2: Install Neovim DAP Plugins**

```lua
{
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'kdheepak/nvim-dap-julia',  -- Simplified Julia adapter
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Option 1: Use nvim-dap-julia (easiest)
    require('dap-julia').setup()

    -- Option 2: Manual configuration
    dap.adapters.julia = {
      type = 'server',
      host = '127.0.0.1',
      port = function()
        local port = 31234  -- Can be any available port
        return port
      end,
    }

    dap.configurations.julia = {
      {
        type = 'julia',
        request = 'launch',
        name = 'Launch Julia',
        program = '${file}',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- DAP UI configuration
    dapui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
  end,
}
```

**Step 3: Keybindings**

```lua
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'DAP: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'DAP: Continue' })
vim.keymap.set('n', '<leader>dso', function() require('dap').step_over() end, { desc = 'DAP: Step Over' })
vim.keymap.set('n', '<leader>dsi', function() require('dap').step_into() end, { desc = 'DAP: Step Into' })
vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end, { desc = 'DAP: Open REPL' })
vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'DAP: Toggle UI' })
```

**Debugging Workflow:**
1. Set breakpoint: `<leader>db`
2. Start debugger: `<leader>dc`
3. Step through code: `<leader>dso` (over), `<leader>dsi` (into)
4. Inspect variables in DAP UI or REPL: `<leader>dr`

**Sources:**
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) - Official DAP client
- [kdheepak/nvim-dap-julia](https://github.com/kdheepak/nvim-dap-julia) - Julia adapter
- [Discourse discussion: DebugAdapter.jl](https://discourse.julialang.org/t/neovim-debugadapter-jl/116529)

### Known Limitations

- DebugAdapter.jl support merged recently (July 2024), still maturing
- Some advanced features may not work as smoothly as VSCode Julia debugger
- Test-specific debugging (like pytest in Python) not yet standardized

---

## Formatting and Linting

### LanguageServer.jl Built-in Formatting (Recommended)

LanguageServer.jl now includes JuliaFormatter.jl support, so format-on-save works via LSP:

```lua
-- In your LSP on_attach function
local function on_attach(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

require('lspconfig').julials.setup({
  on_attach = on_attach,
})
```

### JuliaFormatter Configuration (.JuliaFormatter.toml)

Create `.JuliaFormatter.toml` in your project root:

```toml
indent = 4
margin = 92
always_for_in = true
whitespace_typedefs = true
whitespace_ops_in_indices = true
remove_extra_newlines = true
```

**Important:** If you have `.JuliaFormatter.toml` at root but open files in subfolders with their own `Project.toml`, the LSP root may be the subfolder, and the formatter doesn't search parent directories by design.

**Solution:** Place `.JuliaFormatter.toml` at repository root AND in each project subdirectory, or configure LSP root detection:

```lua
require('lspconfig').julials.setup({
  root_dir = require('lspconfig.util').root_pattern('.git', '.JuliaFormatter.toml'),
})
```

### Performance Issue: Formatting is Slow

**Problem:** JuliaFormatter can take 10-20 seconds to format files due to JIT compilation overhead.

**Solution:** Create precompiled sysimage with PackageCompiler (see [Performance Optimization](#performance-optimization))

### Alternative: null-ls / none-ls Integration

**Note:** null-ls is deprecated, use [none-ls](https://github.com/nvimtools/none-ls.nvim) instead.

```lua
{
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require('null-ls')
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.juliaformatter,  -- If available
      },
    })
  end,
}
```

**Status:** none-ls doesn't have built-in JuliaFormatter support yet, requires custom formatter factory.

**Community consensus:** Use LSP formatting instead of null-ls for Julia in 2025.

**Sources:**
- [JuliaFormatter.jl documentation](https://github.com/domluna/JuliaFormatter.jl)
- [Discourse: Formatting subfolders](https://discourse.julialang.org/t/neovim-julia-lsp-formatting-on-subfolders-respecting-juliaformatter-toml/105900)

---

## Unicode Input Methods

Julia uses extensive Unicode for mathematical notation (α, β, ∇, ∑, etc.). Three methods for Unicode input:

### Method 1: julia-vim Tab Completion (Recommended for most users)

**How it works:**
1. Type LaTeX command: `\alpha`
2. Press `<Tab>`
3. See completion: `α`

**Partial matches:**
- Type `\al<Tab>` → Shows list: `\aleph`, `\allequal`, `\alpha`
- Type more characters to refine
- When one match left, `<Tab>` completes, second `<Tab>` substitutes to Unicode

**Configuration:**
```lua
vim.g.latex_to_unicode_auto = 0  -- Manual trigger (recommended)
vim.g.latex_to_unicode_tab = 1   -- Enable Tab mapping (default)
```

**Alternative trigger:** `<C-X><C-U>` in insert mode (doesn't require Tab mapping)

**Pros:** Works exactly like Julia REPL, muscle memory transfers
**Cons:** May conflict with other Tab-based completions

**Source:** [JuliaEditorSupport/julia-vim](https://github.com/JuliaEditorSupport/julia-vim)

### Method 2: cmp-latex-symbols (Recommended for nvim-cmp users)

**How it works:**
1. Type `\alpha`
2. nvim-cmp shows completion menu with `α`
3. Accept with `<CR>` or `<Tab>` (depending on your cmp config)

**Configuration:**
```lua
require('cmp').setup({
  sources = {
    { name = 'nvim_lsp', priority = 1000 },
    {
      name = 'latex_symbols',
      priority = 500,
      option = {
        strategy = 0,  -- 0: mixed (Julia + LaTeX), 1: julia, 2: latex
      },
    },
    { name = 'buffer', priority = 100 },
  },
})
```

**Pros:** Integrates with existing completion pipeline, shows Unicode preview
**Cons:** Requires nvim-cmp setup

**Source:** [kdheepak/cmp-latex-symbols](https://github.com/kdheepak/cmp-latex-symbols)

### Method 3: Auto-as-you-type (julia-vim advanced mode)

```lua
vim.g.latex_to_unicode_auto = 1  -- Enable auto-substitution
```

**How it works:** Automatically substitutes `\alpha` → `α` as you type without pressing Tab

**Pros:** Fastest input, no manual trigger
**Cons:** Can be surprising if you want to type literal LaTeX, may interfere with other workflows

### Unicode Symbol Reference

Common Julia mathematical symbols:

| LaTeX | Unicode | Description |
|-------|---------|-------------|
| `\alpha` | α | Alpha |
| `\beta` | β | Beta |
| `\gamma` | γ | Gamma |
| `\Delta` | Δ | Delta (capital) |
| `\nabla` | ∇ | Nabla (gradient) |
| `\sum` | ∑ | Summation |
| `\int` | ∫ | Integral |
| `\infty` | ∞ | Infinity |
| `\sqrt` | √ | Square root |
| `\in` | ∈ | Element of |
| `\subseteq` | ⊆ | Subset or equal |
| `\forall` | ∀ | For all |
| `\exists` | ∃ | There exists |

**Full symbol list:** [Julia Manual - Unicode Input](https://docs.julialang.org/en/v1/manual/unicode-input/)

---

## Testing Workflows

### Test.jl Standard Library

Julia's built-in testing framework:

```julia
# test/runtests.jl
using Test
using MyPackage

@testset "MyPackage Tests" begin
    @testset "Basic Operations" begin
        @test 1 + 1 == 2
        @test MyPackage.add(2, 3) == 5
    end

    @testset "Edge Cases" begin
        @test_throws DomainError sqrt(-1)
        @test isnan(0/0)
    end
end
```

### Running Tests from Neovim

#### Method 1: Pkg.test() - Thorough Testing

**In Julia REPL (via vim-slime):**
```julia
using Pkg
Pkg.activate(".")
Pkg.test()
```

**Keybinding (terminal command):**
```lua
vim.keymap.set('n', '<leader>jt', ':!julia --project=. -e "using Pkg; Pkg.test()"<CR>',
  { desc = 'Julia: Run Pkg.test()' })
```

**When to use:**
- Before commits
- CI/CD validation
- Checking dependency compatibility
- Ensuring reproducible environment

**Behavior:**
- Creates isolated temporary environment
- Checks all dependencies are up-to-date
- Runs all tests in `test/` directory
- Can be slow (30s-2min) due to environment setup

**Source:** [Julia Pkg documentation](https://pkgdocs.julialang.org/v1/)

#### Method 2: Interactive Testing with Revise - Rapid Iteration

**Best practice for development:**

```julia
# In Julia REPL
using Revise
using TestEnv
TestEnv.activate()
using MyPackage

# Run specific test file
include("test/runtests.jl")

# Or run specific testset
include("test/test_module.jl")
```

**Why this is faster:**
- No Julia startup time (REPL already running)
- Revise auto-reloads source changes
- No environment recreation
- Can run individual testsets

**Workflow:**
1. Open Julia REPL in tmux split: `julia --project=.`
2. Load Revise + TestEnv once at session start
3. Edit code in Neovim
4. Send test execution to REPL: `<C-c><C-c>` (vim-slime)
5. See results immediately
6. Revise detects changes, no REPL restart needed

**Keybinding to send test file:**
```lua
vim.keymap.set('n', '<leader>jtr', function()
  vim.fn.setreg('*', 'include("test/runtests.jl")')
  vim.cmd('normal! "*p')
  -- Then send to REPL with vim-slime
end, { desc = 'Julia: Run tests in REPL' })
```

**Source:** [Julia Testing Best Practices](https://erikexplores.substack.com/p/julia-testing-best-pratice)

#### Method 3: Neotest Integration (Experimental)

**Status (2025):** No mature Julia adapter exists for Neotest yet.

**Alternative:** Create custom Overseer.nvim task or nvim-test configuration:

```lua
-- With nvim-test
require('nvim-test').setup({
  runners = {
    julia = 'julia --project=. -e "using Pkg; Pkg.test()"'
  }
})
```

**Community need:** Julia-specific Neotest adapter could parse `@testset` blocks and provide:
- Run test under cursor
- Run file tests
- Test result decorations
- Failed test navigation

**Opportunity for contribution!**

### Test Organization Best Practices

**Recommended structure:**
```
MyPackage/
├── src/
│   └── MyPackage.jl
├── test/
│   ├── runtests.jl           # Main test entry point
│   ├── test_module_a.jl      # Module-specific tests
│   ├── test_module_b.jl
│   └── test_integration.jl   # Integration tests
└── Project.toml
```

**test/runtests.jl pattern:**
```julia
using Test

@testset "MyPackage.jl" begin
    include("test_module_a.jl")
    include("test_module_b.jl")
    include("test_integration.jl")
end
```

**Sources:**
- [Julia Testing Documentation](https://docs.julialang.org/en/v1/stdlib/Test/)
- [Package Testing Best Practices](https://www.juliabloggers.com/best-practices-for-testing-your-julia-packages/)

---

## Plotting and Visualization

Julia plotting in Neovim requires different approaches depending on your terminal emulator and workflow preferences.

### Option 1: Kitty Terminal + KittyTerminalImages.jl (Best for Interactive Work)

**Prerequisites:**
- Kitty terminal emulator
- macOS or Linux (not Windows)
- Does NOT work with tmux/screen (Kitty limitation)

**Installation:**
```julia
using Pkg
Pkg.add("KittyTerminalImages")
```

**Usage:**
```julia
using Plots
using KittyTerminalImages

plot(sin, 0, 2π)  # Plot displays directly in terminal
```

**How it works:** Calls `display` on plot objects, which triggers Kitty's Graphics Protocol to render images inline in terminal

**Gotcha:** Plots.jl or Gadfly.jl may override KittyTerminalImages on display stack, requiring manual re-registration:
```julia
using KittyTerminalImages
KittyTerminalImages.register_display()
```

**Source:** [KittyTerminalImages.jl](https://github.com/simonschoelly/KittyTerminalImages.jl)

### Option 2: image.nvim Plugin (Best for Rich Media)

**Prerequisites:**
- Kitty terminal OR terminal supporting Kitty Graphics Protocol
- Works with tmux if configured properly

**Installation:**
```lua
{
  '3rd/image.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    backend = "kitty",  -- or "ueberzug"
    integrations = {
      markdown = {
        enabled = true,
        download_remote_images = true,
      },
    },
  },
}
```

**Workflow:**
1. Generate plot in Julia REPL: `savefig("output.png")`
2. image.nvim automatically displays PNGs in markdown files
3. Useful for data science notebooks and literate programming

**Use case:** Viewing saved plot files rather than live REPL plots

**Source:** [3rd/image.nvim](https://github.com/3rd/image.nvim)

### Option 3: UnicodePlots.jl (Best for Tmux/SSH)

**Installation:**
```julia
using Pkg
Pkg.add("UnicodePlots")
```

**Usage:**
```julia
using UnicodePlots

lineplot(1:10, rand(10))
```

**Output example:**
```
      ┌────────────────────────────────────────┐
    1 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
      │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠤⠒⠊⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
      │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠖⠋⠁⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
      │⠤⠤⠤⠤⠤⠤⠤⠤⢤⣤⠤⠤⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│
      └────────────────────────────────────────┘
      0                                        10
```

**Pros:**
- Works everywhere (even SSH over slow connections)
- No image display needed
- Fast rendering
- Works perfectly with tmux

**Cons:**
- Lower quality than graphical plots
- Limited for complex visualizations

**Source:** [UnicodePlots.jl](https://github.com/JuliaPlots/UnicodePlots.jl)

### Option 4: External Window (Fallback)

**Switch backend in REPL:**
```julia
using Plots
gr()  # Default backend, opens external window

plot(sin, 0, 2π)  # Opens in separate window
```

**When to use:**
- When terminal graphics aren't available
- When you need high-quality, interactive plots
- Presentation or publication-quality figures

**Backends:**
- `gr()` - GR framework (default, fast)
- `pyplot()` - Matplotlib (Python interop)
- `plotlyjs()` - Interactive web-based

### Workflow Recommendation by Environment

| Environment | Recommended Solution | Reason |
|-------------|----------------------|--------|
| Kitty (no tmux) | KittyTerminalImages.jl | Native inline display, seamless |
| Kitty + tmux | image.nvim + savefig() | Tmux blocks Kitty protocol for live display |
| iTerm2 / Alacritty | UnicodePlots.jl | No graphics protocol support |
| SSH / Remote | UnicodePlots.jl | Works over text-only connection |
| WSL / Windows | External window (gr) | Terminal graphics limited on Windows |

**Sources:**
- [Discourse: Plots in terminal with sixel](https://discourse.julialang.org/t/plots-in-the-terminal-with-sixel/22503)
- [Julia + Neovim + Tmux workflow](https://forem.julialang.org/navi/set-up-neovim-tmux-for-a-data-science-workflow-with-julia-3ijk)

---

## Performance Optimization

### The Problem: Slow LSP Startup

**Symptom:** LanguageServer.jl takes 20-30 seconds to respond after opening `.jl` file

**Cause:** Julia's JIT compiler must compile LanguageServer.jl and dependencies on every startup

**Solution:** PackageCompiler.jl creates a precompiled system image (sysimage) that eliminates JIT overhead

### Creating a Custom Sysimage for LanguageServer.jl

**Step 1: Install PackageCompiler**
```julia
using Pkg
Pkg.add("PackageCompiler")
```

**Step 2: Create precompile script**

Create `~/.julia/environments/nvim-lspconfig/precompile_ls.jl`:

```julia
using LanguageServer
using SymbolServer

# Simulate common LSP operations to capture for precompilation
LanguageServer.toplevel_expr_hints(nothing)
LanguageServer.diagnostic_hints(nothing)
SymbolServer.load_package_cache()
```

**Step 3: Build sysimage**

```bash
julia --project=~/.julia/environments/nvim-lspconfig
```

```julia
using PackageCompiler

create_sysimage(
    [:LanguageServer, :SymbolServer],
    sysimage_path = joinpath(homedir(), ".julia", "environments", "nvim-lspconfig", "bin", "LanguageServerSysimage.so"),
    precompile_execution_file = joinpath(homedir(), ".julia", "environments", "nvim-lspconfig", "precompile_ls.jl"),
)
```

**Step 4: Create wrapper Julia executable**

Create `~/.julia/environments/nvim-lspconfig/bin/julia` (make executable with `chmod +x`):

```bash
#!/bin/bash
exec /usr/local/bin/julia --sysimage="$HOME/.julia/environments/nvim-lspconfig/bin/LanguageServerSysimage.so" "$@"
```

**Step 5: Configure Neovim to use custom Julia**

```lua
require('lspconfig').julials.setup({
  on_new_config = function(new_config, _)
    local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
    if require('lspconfig').util.path.is_file(julia) then
      new_config.cmd[1] = julia
    end
  end,
})
```

**Result:** LanguageServer now starts **instantly** (0.5s vs 20s)

### Sysimage for JuliaFormatter (Formatting Speed)

**Problem:** Formatting takes 10-20 seconds

**Solution:** Same PackageCompiler approach, but include JuliaFormatter:

```julia
create_sysimage(
    [:JuliaFormatter],
    sysimage_path = joinpath(homedir(), ".julia", "environments", "nvim-lspconfig", "bin", "JuliaFormatterSysimage.so"),
)
```

**Invoke formatter with sysimage:**
```bash
julia --sysimage="$HOME/.julia/environments/nvim-lspconfig/bin/JuliaFormatterSysimage.so" -e 'using JuliaFormatter; format("src/")'
```

### Recent Improvements (2025)

**Sysimage compression:** PackageCompiler now compresses sysimages by ~70%, reducing disk space from ~500MB to ~150MB for large sysimages

**Source:** [This Month in Julia World (August 2025)](https://julialang.org/blog/2025/09/this-month-in-julia-world/index.html)

### Community Examples

**Fredrik Ekre's dotfiles:** Up-to-date Makefile for building LanguageServer sysimage
**Source:** [fredrikekre/.dotfiles](https://github.com/fredrikekre/.dotfiles)

### Performance Best Practices Summary

| Operation | Without Sysimage | With Sysimage | Speedup |
|-----------|------------------|---------------|---------|
| LSP first response | 20-30s | 0.5-1s | 20-30x |
| File formatting | 10-20s | 1-2s | 5-10x |
| Sysimage size (uncompressed) | N/A | 500MB | - |
| Sysimage size (compressed, 2025) | N/A | 150MB | 70% reduction |

**Authoritative Sources:**
- [PackageCompiler.jl Documentation](https://julialang.github.io/PackageCompiler.jl/dev/)
- [Discourse: PackageCompiled LanguageServer](https://discourse.julialang.org/t/neovim-native-lsp-with-julials-using-packagecompiled-languageserver/57659)

---

## Common Issues and Solutions

### Issue 1: "Package LanguageServer not found"

**Error message:**
```
ArgumentError: Package LanguageServer not found in current path
```

**Cause:** LanguageServer.jl not installed in correct environment

**Solution:**
```bash
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
```

**Source:** [nvim-lspconfig issue #1848](https://github.com/neovim/nvim-lspconfig/issues/1848)

### Issue 2: "Missing Reference" Warnings for Standard Library

**Symptom:** LSP shows "Missing reference" warnings for `using Dates`, `using Test`, etc.

**Cause:** SymbolServer cache corruption or outdated Julia version

**Solutions:**

**Option A: Clear SymbolServer cache**
```bash
rm -rf ~/.julia/environments/nvim-lspconfig/compiled
rm -rf ~/.julia/logs/LanguageServer
```

**Option B: Update LanguageServer.jl**
```bash
julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.update()'
```

**Option C: Disable missing reference warnings**
```lua
require('lspconfig').julials.setup({
  settings = {
    julia = {
      lint = {
        missingrefs = "none",  -- Disable noisy warnings
      },
    },
  },
})
```

**Source:** [LanguageServer.jl issue #1106](https://github.com/neovim/nvim-lspconfig/issues/1106)

### Issue 3: LSP Doesn't Recognize Project Dependencies

**Symptom:** LSP shows errors for packages listed in Project.toml

**Cause:** Project not instantiated

**Solution:**
```bash
cd /path/to/project
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

Then restart LSP: `:LspRestart`

**Source:** [Setting Up Julia LSP for Neovim](https://www.juliabloggers.com/setting-up-julia-lsp-for-neovim/)

### Issue 4: julia-vim Conflicts with nvim-cmp

**Symptom:** Tab completion doesn't work, or nvim-cmp menu disappears

**Cause:** julia-vim's Tab mapping conflicts with nvim-cmp

**Solution:** Use `cmp-latex-symbols` instead:

```lua
-- Disable julia-vim Tab mapping
vim.g.latex_to_unicode_tab = 0

-- Use cmp-latex-symbols
require('cmp').setup({
  sources = {
    { name = 'latex_symbols' },
  },
})
```

**Alternative:** Use `<C-X><C-U>` for julia-vim completion without Tab mapping

**Source:** [coc.nvim issue #2120](https://github.com/neoclide/coc.nvim/issues/2120)

### Issue 5: Treesitter Context Errors with Julia

**Symptom:** Errors related to Julia context queries in nvim-treesitter-context

**Cause:** Julia treesitter parser updates breaking context queries

**Solution:** Disable treesitter-context for Julia:

```lua
require('treesitter-context').setup({
  enable = true,
  disable = { 'julia' },  -- Disable for Julia if errors occur
})
```

Or update parsers: `:TSUpdate julia`

**Source:** [nvim-treesitter-context issue #428](https://github.com/nvim-treesitter/nvim-treesitter-context/issues/428)

### Issue 6: Deprecation Warnings from SymbolServer

**Symptom:** Console shows "Threads.Mutex is deprecated, use ReentrantLock instead"

**Cause:** SymbolServer.jl using deprecated Julia APIs

**Impact:** Harmless warnings, doesn't affect functionality

**Solution:** Wait for SymbolServer update, or suppress warnings:

```bash
julia --project=~/.julia/environments/nvim-lspconfig --depwarn=no
```

**Source:** [Various LanguageServer errors issue #735](https://github.com/julia-vscode/LanguageServer.jl/issues/735)

### Issue 7: Formatter Doesn't Find .JuliaFormatter.toml

**Symptom:** Formatting doesn't respect project configuration

**Cause:** LSP root is subfolder, formatter doesn't search parent directories

**Solution:** Configure LSP root detection:

```lua
require('lspconfig').julials.setup({
  root_dir = require('lspconfig.util').root_pattern('.git', '.JuliaFormatter.toml'),
})
```

Or place `.JuliaFormatter.toml` in each project subdirectory

**Source:** [Discourse: Formatting subfolders](https://discourse.julialang.org/t/neovim-julia-lsp-formatting-on-subfolders-respecting-juliaformatter-toml/105900)

---

## Popular Community Configurations

### Recommended Dotfile References

1. **Fredrik Ekre's .dotfiles** (LanguageServer sysimage expert)
   - **URL:** https://github.com/fredrikekre/.dotfiles
   - **Notable features:** Makefile for LanguageServer sysimage, optimized LSP config
   - **Audience:** Advanced users wanting maximum performance

2. **LunarVim Julia Configuration**
   - **URL:** https://www.lunarvim.org/docs/features/supported-languages/julia
   - **Notable features:** Pre-configured Julia support with LSP, DAP, formatting
   - **Audience:** Users wanting batteries-included setup

3. **Neovim from Scratch - Julia Setup**
   - **URL:** Multiple community examples on GitHub (search: "neovim julia dotfiles")
   - **Notable features:** Minimal configurations showcasing core plugins
   - **Audience:** Beginners learning to configure from scratch

### Popular Neovim Frameworks with Julia Support

| Framework | Stars | Julia LSP | Julia Formatter | Notes |
|-----------|-------|-----------|-----------------|-------|
| [NvChad](https://nvchad.com/) | 25k+ | ✅ Via Mason | ✅ Via none-ls | Fast, beautiful UI, easy customization |
| [AstroNvim](https://astronvim.com/) | 13k+ | ✅ Via Mason | ✅ Built-in | Feature-rich, extensible architecture |
| [LunarVim](https://www.lunarvim.org/) | 18k+ | ✅ Documented | ✅ Documented | Opinionated IDE layer |
| [LazyVim](https://www.lazyvim.org/) | 17k+ | ✅ Via Mason | ✅ Via conform | Fast, lazy-loading focused |

**Recommendation:** Start with a framework (NvChad or AstroNvim) if you're new to Neovim, or build from scratch using this guide if you prefer full control.

### Community Resources

**Blogs and Tutorials:**
- [Setting Up Julia LSP for Neovim (Jacob Zelko)](https://jacobzelko.com/08312022162228-julia-lsp-setup/) - Step-by-step guide
- [Neovim + Tmux for Julia Data Science (Navi)](https://forem.julialang.org/navi/set-up-neovim-tmux-for-a-data-science-workflow-with-julia-3ijk) - Complete workflow
- [The Must-Have Neovim Plugins for Julia (DEV Community)](https://dev.to/uncomfyhalomacro/the-must-have-neovim-plugins-for-julia-3j3m) - Plugin recommendations

**Discourse Threads:**
- [Neovim + LanguageServer.jl (Julia Discourse)](https://discourse.julialang.org/t/neovim-languageserver-jl/37286) - 100+ posts, active community discussion
- [Neovim and Julia - setup advice?](https://discourse.julialang.org/t/neovim-and-julia-setup-advice/17393) - Beginner-friendly advice thread

**Reddit Communities:**
- r/neovim - Julia-related posts and configurations
- r/Julia - Editor setup discussions

---

## Authoritative Sources Summary

All recommendations in this guide are based on:

**Official Julia Projects:**
- [julia-vscode/LanguageServer.jl](https://github.com/julia-vscode/LanguageServer.jl) - Official LSP implementation
- [JuliaEditorSupport/julia-vim](https://github.com/JuliaEditorSupport/julia-vim) - Official Vim support
- [Julia Documentation](https://docs.julialang.org/) - Language reference
- [Pkg.jl Documentation](https://pkgdocs.julialang.org/) - Package management

**Official Neovim Projects:**
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter integration
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol

**Community Plugins (Well-Maintained):**
- [kdheepak/cmp-latex-symbols](https://github.com/kdheepak/cmp-latex-symbols) - Unicode completion
- [kdheepak/nvim-dap-julia](https://github.com/kdheepak/nvim-dap-julia) - Julia debugging
- [jpalardy/vim-slime](https://github.com/jpalardy/vim-slime) - REPL integration
- [3rd/image.nvim](https://github.com/3rd/image.nvim) - Image display

**Julia Community:**
- [Julia Discourse - Tooling Category](https://discourse.julialang.org/c/tools/13) - Active discussions
- [JuliaBloggers](https://www.juliabloggers.com/) - Aggregated tutorials and guides

---

## Quick Reference: Minimal Working Configuration

Here's a minimal `lazy.nvim` configuration for Julia development (copy-paste ready):

```lua
-- ~/.config/nvim/lua/plugins/julia.lua
return {
  -- Treesitter for syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'julia' },
        highlight = { enable = true },
      })
    end,
  },

  -- LSP configuration
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').julials.setup({
        -- Auto-format on save
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })
    end,
  },

  -- Julia syntax and Unicode completion
  {
    'JuliaEditorSupport/julia-vim',
    ft = 'julia',
  },

  -- REPL integration
  {
    'jpalardy/vim-slime',
    ft = 'julia',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = {
        socket_name = 'default',
        target_pane = '{last}',
      }
    end,
  },

  -- Completion (if using nvim-cmp)
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'kdheepak/cmp-latex-symbols',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'latex_symbols', option = { strategy = 0 } },
        },
      })
    end,
  },
}
```

**After installation:**
1. Install LanguageServer: `julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'`
2. Instantiate your project: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
3. Open a `.jl` file and wait for LSP to initialize
4. Start Julia REPL in tmux split and send code with `<C-c><C-c>`

---

## Conclusion

Julia development in Neovim in 2025 is mature and powerful, with excellent LSP support, REPL integration, and debugging capabilities. The key to a great experience is:

1. **Use LanguageServer.jl with a custom sysimage** for instant startup
2. **Integrate Julia REPL with vim-slime + Revise.jl** for rapid iteration
3. **Choose Unicode input method** that fits your completion workflow
4. **Configure proper testing workflow** with Pkg.test() and REPL testing
5. **Optimize for your terminal** (Kitty for graphics, tmux for flexibility)

This configuration rivals or exceeds VSCode for Julia development, with the benefits of Neovim's modal editing, extensibility, and performance.

---

**Document Version:** 1.0 (2025-11-11)
**Last Updated:** 2025-11-11
**Maintained By:** Research compiled from Julia and Neovim community resources
**Feedback:** Open issues or discussions in your Neovim configuration repository
