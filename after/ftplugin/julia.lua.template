-- Julia filetype-specific settings
-- Based on JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md
--
-- To activate:
-- 1. Rename from julia.lua.template to julia.lua
-- 2. Open any .jl file to see settings applied
--
-- This file is automatically loaded for Julia files only

-- Indentation settings (Julia standard: 4 spaces)
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true -- Use spaces, not tabs

-- Line length (Julia style guide: 92 characters recommended)
vim.bo.textwidth = 92
vim.wo.colorcolumn = '92'

-- Comments
vim.bo.commentstring = '# %s'

-- Folding (optional - use Treesitter for better folding)
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldenable = false -- Start with folds open

-----------------------------------------------------------
-- Julia-specific keybindings
-----------------------------------------------------------

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = 'Julia: ' .. desc })
end

-- Package management
map('n', '<leader>jt', ':!julia --project=. -e "using Pkg; Pkg.test()"<CR>', 'Run Pkg.test()')
map('n', '<leader>ji', ':!julia --project=. -e "using Pkg; Pkg.instantiate()"<CR>', 'Instantiate project')
map('n', '<leader>ju', ':!julia --project=. -e "using Pkg; Pkg.update()"<CR>', 'Update packages')
map('n', '<leader>js', ':!julia --project=. -e "using Pkg; Pkg.status()"<CR>', 'Show package status')

-- REPL workflow
map('n', '<leader>jr', ':split | terminal julia --project=.<CR>', 'Start Julia REPL')
map('n', '<leader>jR', ':vsplit | terminal julia --project=.<CR>', 'Start REPL (vertical)')

-- Testing workflow
map('n', '<leader>jtr', function()
  -- Send test execution to REPL (assumes vim-slime is configured)
  vim.fn.setreg('*', 'include("test/runtests.jl")\n')
  vim.notify('Run include("test/runtests.jl") in REPL', vim.log.levels.INFO)
end, 'Run tests in REPL')

-- Formatting
map('n', '<leader>jf', function()
  vim.lsp.buf.format({ async = false })
end, 'Format file')

-- Documentation lookup (LSP hover)
map('n', '<leader>jh', function()
  vim.lsp.buf.hover()
end, 'Show hover documentation')

-- Macro expansion (open in split for manual @macroexpand)
map('n', '<leader>jm', function()
  vim.cmd('vsplit')
  vim.cmd('terminal julia --project=.')
  vim.notify('Use @macroexpand in REPL to expand macros', vim.log.levels.INFO)
end, 'Open REPL for macro expansion')

-----------------------------------------------------------
-- Development algorithm integration
-----------------------------------------------------------

-- Add Julia test automation to existing development algorithm keymaps
-- These integrate with <leader>Dt* commands if development-algorithm.lua exists

-- Test runner that detects Julia and uses appropriate command
local function run_julia_test_current_file()
  local file = vim.fn.expand('%:p')
  if vim.bo.filetype == 'julia' then
    -- Run file in Julia REPL
    vim.cmd('!julia --project=. ' .. vim.fn.shellescape(file))
  end
end

local function run_julia_test_all()
  -- Run all tests via Pkg.test()
  vim.cmd('!julia --project=. -e "using Pkg; Pkg.test()"')
end

-- Map to development algorithm test commands if they exist
if vim.fn.mapcheck('<leader>Dtr', 'n') == '' then
  map('n', '<leader>Dtr', run_julia_test_current_file, 'Run current file')
  map('n', '<leader>Dta', run_julia_test_all, 'Run all tests (Pkg.test)')
end

-----------------------------------------------------------
-- LSP-specific settings
-----------------------------------------------------------

-- Enhance LSP experience for Julia
local lsp_group = vim.api.nvim_create_augroup('JuliaLSP', { clear = true })

-- Show notification when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  buffer = vim.api.nvim_get_current_buf(),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'julials' then
      vim.notify('Julia LSP attached - waiting for SymbolServer...', vim.log.levels.INFO)

      -- Add LSP-specific keybindings
      local lsp_map = function(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { buffer = true, desc = 'LSP: ' .. desc })
      end

      lsp_map('gd', vim.lsp.buf.definition, 'Go to definition')
      lsp_map('gr', vim.lsp.buf.references, 'Show references')
      lsp_map('gi', vim.lsp.buf.implementation, 'Go to implementation')
      lsp_map('gt', vim.lsp.buf.type_definition, 'Go to type definition')
      lsp_map('K', vim.lsp.buf.hover, 'Hover documentation')
      lsp_map('<leader>jr', vim.lsp.buf.rename, 'Rename symbol')
      lsp_map('<leader>ja', vim.lsp.buf.code_action, 'Code actions')
    end
  end,
})

-----------------------------------------------------------
-- Helpful autocmds
-----------------------------------------------------------

local julia_group = vim.api.nvim_create_augroup('JuliaSettings', { clear = true })

-- Highlight trailing whitespace in Julia files
vim.api.nvim_create_autocmd('BufEnter', {
  group = julia_group,
  pattern = '*.jl',
  callback = function()
    vim.cmd([[match ExtraWhitespace /\s\+$/]])
  end,
})

-- Auto-remove trailing whitespace on save (optional - comment out if unwanted)
--[[ vim.api.nvim_create_autocmd('BufWritePre', {
  group = julia_group,
  pattern = '*.jl',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
}) ]]

-- Notify when opening Julia file without instantiated project
vim.api.nvim_create_autocmd('BufRead', {
  group = julia_group,
  pattern = '*.jl',
  callback = function()
    local project_file = vim.fn.findfile('Project.toml', '.;')
    if project_file ~= '' then
      local manifest_file = vim.fn.findfile('Manifest.toml', '.;')
      if manifest_file == '' then
        vim.notify(
          'Project.toml found but no Manifest.toml - run <leader>ji to instantiate',
          vim.log.levels.WARN
        )
      end
    end
  end,
})

-----------------------------------------------------------
-- Unicode symbol helpers
-----------------------------------------------------------

-- Common Julia Unicode symbols quick reference
-- Access with :JuliaSymbols command
vim.api.nvim_create_user_command('JuliaSymbols', function()
  local symbols = {
    'Common Julia Unicode Symbols (type LaTeX + Tab):',
    '',
    '  \\alpha<Tab>  → α     (alpha)',
    '  \\beta<Tab>   → β     (beta)',
    '  \\gamma<Tab>  → γ     (gamma)',
    '  \\Delta<Tab>  → Δ     (Delta)',
    '  \\nabla<Tab>  → ∇     (nabla/gradient)',
    '  \\sum<Tab>    → ∑     (summation)',
    '  \\int<Tab>    → ∫     (integral)',
    '  \\infty<Tab>  → ∞     (infinity)',
    '  \\sqrt<Tab>   → √     (square root)',
    '  \\in<Tab>     → ∈     (element of)',
    '  \\subseteq<Tab> → ⊆   (subset or equal)',
    '  \\forall<Tab> → ∀     (for all)',
    '  \\exists<Tab> → ∃     (there exists)',
    '',
    'See :help julia-vim or https://docs.julialang.org/en/v1/manual/unicode-input/',
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, symbols)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

  local width = 70
  local height = #symbols + 2
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
    title = ' Julia Unicode Symbols ',
    title_pos = 'center',
  })

  vim.keymap.set('n', 'q', ':q<CR>', { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', ':q<CR>', { buffer = buf, silent = true })
end, { desc = 'Show Julia Unicode symbol reference' })

-- Add keybinding to show symbols
map('n', '<leader>jU', ':JuliaSymbols<CR>', 'Show Unicode symbol reference')

-----------------------------------------------------------
-- Performance settings
-----------------------------------------------------------

-- Disable some expensive features for large Julia files (>1000 lines)
vim.api.nvim_create_autocmd('BufReadPost', {
  group = julia_group,
  pattern = '*.jl',
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count > 1000 then
      vim.notify('Large Julia file detected - disabling some features for performance', vim.log.levels.INFO)
      vim.wo.foldmethod = 'manual' -- Treesitter folding expensive on large files
      vim.bo.syntax = '' -- Disable regex syntax (Treesitter still active)
    end
  end,
})

-----------------------------------------------------------
-- Integration with existing config
-----------------------------------------------------------

-- This file integrates with:
-- - lua/plugins/lsp.lua (LSP configuration)
-- - lua/plugins/development-algorithm.lua (test automation)
-- - lua/plugins/dap.lua (debugging, if nvim-dap-julia installed)
-- - after/ftplugin/python.lua (similar structure for reference)
--
-- See JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md for complete documentation

print('Julia filetype settings loaded - see <leader>jU for Unicode symbols')
