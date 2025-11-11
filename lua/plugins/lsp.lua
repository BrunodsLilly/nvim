return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      }
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
      if not mason_lspconfig_ok then
        vim.notify('mason-lspconfig not loaded', vim.log.levels.ERROR)
        return
      end

      -- Define server-specific configurations
      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' }
              }
            }
          }
        },

        ruff = {
          -- Ruff handles linting and import organization
          init_options = {
            settings = {
              -- Enable import sorting (organizeImports)
              organizeImports = true,
              -- Enable auto-fixing
              fixAll = true,
            }
          }
        },

        basedpyright = {
          -- basedpyright handles type checking only
          settings = {
            basedpyright = {
              -- Disable import organizing (Ruff handles it)
              disableOrganizeImports = true,
              analysis = {
                -- Enable type checking but disable style/linting rules (Ruff handles those)
                typeCheckingMode = "basic",
                -- Only disable specific diagnostic categories that overlap with Ruff
                diagnosticSeverityOverrides = {
                  -- Let Ruff handle these:
                  reportUnusedImport = "none",
                  reportUnusedVariable = "none",
                  reportUnusedFunction = "none",
                  reportUnusedClass = "none",
                  -- Keep type checking enabled:
                  reportGeneralTypeIssues = "warning",
                  reportOptionalMemberAccess = "warning",
                  reportArgumentType = "warning",
                  reportCallIssue = "warning",
                },
              }
            }
          }
        },

        elixirls = {
          filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
          settings = {
            elixirLS = {
              dialyzerEnabled = false,        -- Disable dialyzer by default (can be slow)
              fetchDeps = false,              -- Don't auto-fetch dependencies
            }
          }
        },

        -- jdtls = {
        --   -- DISABLED: jdtls doesn't support Java 24 yet
        --   -- Uncomment and configure when using Java 21 or earlier
        -- },
      }

      -- Setup mason-lspconfig
      mason_lspconfig.setup({
        automatic_installation = true,
      })

      -- Setup each LSP server with custom configuration
      for server_name, config in pairs(server_configs) do
        lspconfig[server_name].setup(config)
      end

      -- Setup sourcekit-lsp manually (not available in Mason for macOS)
      -- sourcekit-lsp comes with Xcode
      local has_sourcekit = vim.fn.executable('sourcekit-lsp') == 1
      if has_sourcekit then
        lspconfig.sourcekit.setup({
          filetypes = { 'swift', 'objective-c', 'objective-cpp' },
          capabilities = {
            workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
          },
        })
      end

      -- Auto-format on save for all LSP clients that support formatting
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP: Auto-format on save',
        group = vim.api.nvim_create_augroup('LSP-format-on-save', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- Only auto-format if the client supports formatting
          if client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              group = vim.api.nvim_create_augroup('LSP-format', { clear = false }),
              callback = function()
                vim.lsp.buf.format({
                  bufnr = args.buf,
                  id = client.id,
                  async = false,
                })
              end,
              desc = 'Format buffer before save',
            })
          end
        end,
      })
    end,
  }
}
