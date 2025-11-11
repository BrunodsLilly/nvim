-- Mason.nvim: Neovim Language Server Manager
-- Automatically installs and manages LSP servers, formatters, linters, and debuggers

return {
  {
    'williamboman/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate' },
    build = ':MasonUpdate',
    opts = {
      -- Use this to change the default installation directory.
      install_root_dir = vim.fn.stdpath 'data' .. '/mason',

      -- A list of all tools you want to ensure are installed upon
      -- start, or start + update
      ensure_installed = {
        -- Language Servers
        'lua-language-server',      -- Lua (lua_ls)
        'python-lsp-server',        -- Python (pylsp) - alternative, but we use ruff + basedpyright
        'basedpyright',             -- Python type checking
        'ruff',                     -- Python linting and import organization
        'gopls',                    -- Go
        'ts_ls',                    -- TypeScript/JavaScript
        'rust-analyzer',            -- Rust
        'clangd',                   -- C/C++
        'elixir-ls',                -- Elixir
        'gleam',                    -- Gleam
        'jdtls',                    -- Java
        'julials',                  -- Julia

        -- Formatters (optional but good to have)
        'prettier',                 -- JavaScript, TypeScript, JSON, CSS, etc.
        'stylua',                   -- Lua
        'gofmt',                    -- Go (built-in but Mason can manage it)
        'black',                    -- Python (optional, Ruff handles most formatting)
        'google-java-format',       -- Java (Google Style Guide)

        -- Debuggers
        'debugpy',                  -- Python debugging (for nvim-dap)
      },

      -- Options for presenting UI prompts
      ui = {
        -- Whether the Mason window should be opened when you invoke the `Mason` command for the first time.
        check_outdated_packages_on_open = true,

        -- the width of the window
        width = 80,

        -- the height of the window
        height = 30,

        -- Window decorations
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },

        keymaps = {
          -- Keymap to expand a package
          toggle_package_expand = '<CR>',
          -- Keymap to install the package under the current cursor position
          install_package = 'i',
          -- Keymap to update the package under the current cursor position
          update_package = 'u',
          -- Keymap to check for new version for the package under the current cursor position
          check_package_version = 'c',
          -- Keymap to update all installed packages
          update_all_packages = 'U',
          -- Keymap to check outdated packages
          check_outdated_packages = 'C',
          -- Keymap to uninstall a package
          uninstall_package = 'X',
          -- Keymap to cancel a package installation
          cancel_installation = '<C-c>',
          -- Keymap to apply language filter
          apply_language_filter = '<C-f>',
        },
      },

      -- log level
      log_level = vim.log.levels.INFO,

      -- Limit for the maximum amount of packages to be installed/updated at the same time. Default is unlimited.
      max_concurrent_installers = 4,

      -- [Advanced setting]
      -- The registries to source packages from. Accepts multiple sources.
      -- See https://github.com/mason-org/mason-registry for more information.
      registries = {
        'github:mason-org/mason-registry',
      },

      -- The provider implementations to use by default (order matters!)
      providers = {
        'mason.providers.registry-api',
        'mason.providers.client',
      },
    },
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      -- Automatically configure language servers installed via Mason
      automatic_installation = true,

      -- Available as soon as `require("mason-lspconfig").setup_handlers(...)` is called
      handlers = {
        -- Default handler for all servers
        function(server_name)
          require('lspconfig')[server_name].setup {}
        end,

        -- Custom handlers for specific servers (see lsp.lua for details)
        -- These are defined in lsp.lua via setup_handlers
      },
    },
  },
}
