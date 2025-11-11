-- Julia Development Configuration
-- Based on JULIA_DEVELOPMENT_BEST_PRACTICES_2025.md
--
-- To activate:
-- 1. Rename this file from julia.lua.template to julia.lua
-- 2. Install LanguageServer.jl:
--    julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
-- 3. Restart Neovim
-- 4. See JULIA_QUICKSTART.md for testing instructions

return {
  -- Treesitter for modern syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'julia' })
      end
    end,
  },

  -- LSP configuration (julials already in Mason ensure_installed)
  -- Actual configuration is in lua/plugins/lsp.lua in the server_configs table
  -- This ensures it follows the same pattern as other language servers

  -- Julia syntax highlighting and Unicode tab completion
  -- Note: julia-vim is DISABLED due to autocmd conflicts with snacks.nvim and blink.cmp
  -- Alternative: Use cmp-latex-symbols (commented out below) or manual Unicode input
  -- {
  --   'JuliaEditorSupport/julia-vim',
  --   ft = 'julia',
  --   init = function()
  --     -- Disable julia-vim's autocmds that conflict with other plugins
  --     vim.g.latex_to_unicode_auto = 0 -- Disable auto-completion (use Tab instead)
  --     vim.g.latex_to_unicode_tab = 1 -- Enable Tab mapping for Julia files only
  --     vim.g.latex_to_unicode_file_types = 'julia' -- Only enable for Julia files
  --   end,
  -- },

  -- REPL integration with tmux (or kitty/neovim/wezterm)
  {
    'jpalardy/vim-slime',
    ft = 'julia',
    config = function()
      -- Configure for tmux (change if using different terminal)
      vim.g.slime_target = 'tmux' -- or 'kitty', 'neovim', 'wezterm'
      vim.g.slime_paste_file = vim.fn.expand('$HOME/.slime_paste')

      -- Tmux-specific settings
      vim.g.slime_default_config = {
        socket_name = 'default',
        target_pane = '{last}', -- Send to last active pane
      }

      -- Keybindings (vim-slime defaults to <C-c><C-c>)
      -- <C-c><C-c> - Send paragraph to REPL
      -- Visual select + <C-c><C-c> - Send selection to REPL

      -- Optional: Custom keybinding to send entire file
      vim.keymap.set('n', '<leader>jrf', 'ggVG<C-c><C-c>', {
        desc = 'Julia: Send entire file to REPL',
        buffer = true,
        remap = true,
      })
    end,
  },

  -- Unicode completion for nvim-cmp users
  -- Note: Use this OR julia-vim tab completion, not both
  -- Uncomment if you prefer cmp integration over Tab mapping
  --[[ {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'kdheepak/cmp-latex-symbols',
    },
    opts = function(_, opts)
      local sources = opts.sources or {}
      table.insert(sources, {
        name = 'latex_symbols',
        priority = 500,
        option = {
          strategy = 0, -- 0: mixed (Julia + LaTeX), 1: julia, 2: latex
        },
      })
      opts.sources = sources
      return opts
    end,
  }, ]]

  -- Julia debugging with DAP
  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      {
        'kdheepak/nvim-dap-julia',
        config = function()
          require('dap-julia').setup()
        end,
      },
    },
  },

  -- Julia-specific keymaps
  {
    'folke/which-key.nvim',
    optional = true,
    opts = {
      spec = {
        { '<leader>j', group = 'Julia', icon = '' },
      },
    },
  },
}

-- Julia-specific keybindings (will be loaded for .jl files only)
-- Add to after/ftplugin/julia.lua for file-type specific settings
--
-- Example keybindings to add:
--
-- vim.keymap.set('n', '<leader>jt', ':!julia --project=. -e "using Pkg; Pkg.test()"<CR>',
--   { desc = 'Julia: Run Pkg.test()', buffer = true })
--
-- vim.keymap.set('n', '<leader>ji', ':!julia --project=. -e "using Pkg; Pkg.instantiate()"<CR>',
--   { desc = 'Julia: Instantiate project', buffer = true })
--
-- vim.keymap.set('n', '<leader>jr', ':!julia --project=.<CR>',
--   { desc = 'Julia: Start REPL', buffer = true })
--
-- vim.keymap.set('n', '<leader>jf', function() vim.lsp.buf.format({ async = false }) end,
--   { desc = 'Julia: Format file', buffer = true })
