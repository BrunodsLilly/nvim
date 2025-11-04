-- ~/.config/nvim/lua/plugins/java-dev.lua

return {
  ------------------------------------------------------------------
  -- 1. MASON CORE AND LSP BRIDGE
  -- This must be set up first so other plugins can use it.
  ------------------------------------------------------------------
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function ()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'jdtls' },
      })
    end,
  },

  ------------------------------------------------------------------
  -- 2. JAVA LSP AND TOOLING SETUP (jdtls)
  -- This now depends on mason-lspconfig to ensure it loads after.
  ------------------------------------------------------------------
  {
    'mfussenegger/nvim-jdtls',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function ()
      -- The main setup is now triggered by mason-lspconfig,
      -- but we still need to provide the specific command for jdtls.
      local java_home = '/opt/homebrew/opt/openjdk'
      local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
      local cmd = {
        java_home .. '/bin/java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1.JavaLanguageServerImpl',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher.jar',
        '-configuration', jdtls_path .. '/config_mac',
        '-data', vim.fn.stdpath('data') ..
      '/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
      }

      require('lspconfig').jdtls.setup({
        cmd = cmd,
      })
    end,
  },

  ------------------------------------------------------------------
  -- 3. DEBUGGER CORE (nvim-dap)
  ------------------------------------------------------------------
  {
    'mfussenegger/nvim-dap',
    config = function ()
      -- Keymaps for debugging
      vim.keymap.set('n', '<F5>', function () require('dap').continue() end,
        { desc = 'DAP: Continue' })
      vim.keymap.set('n', '<F6>', function () require('dap').step_over() end,
        { desc = 'DAP: Step Over' })
      vim.keymap.set('n', '<F7>', function () require('dap').step_into() end,
        { desc = 'DAP: Step Into' })
      vim.keymap.set('n', '<F8>', function () require('dap').step_out() end,
        { desc = 'DAP: Step Out' })
      vim.keymap.set('n', '<Leader>b',
        function () require('dap').toggle_breakpoint() end,
        { desc = 'DAP: Toggle Breakpoint' })
    end,
  },

  ------------------------------------------------------------------
  -- 4. DEBUGGER UI (nvim-dap-ui)
  ------------------------------------------------------------------
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function ()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function ()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function ()
        dapui.close()
      end
    end,
  },
}
