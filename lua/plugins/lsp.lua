return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      }
    },
    config = function ()
      local servers = { 'lua_ls', 'ruff', 'basedpyright', 'gopls', 'rust_analyzer',
        'sourcekit', 'ts_ls', 'elixirls', 'gleam', 'clangd', 'jdtls' }
      local custom = {
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
        },
        ruff = {
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
        sourcekit = {                         -- Swift (not managed by Mason)
          cmd          = { 'sourcekit-lsp' }, -- or full path to Xcode's binary
          filetypes    = { 'swift', 'objective-c', 'objective-cpp' },
          capabilities = {
            workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
          },
        },
        elixirls = {                          -- Elixir
          filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
          settings = {
            elixirLS = {
              dialyzerEnabled = false,        -- Disable dialyzer by default (can be slow)
              fetchDeps = false,              -- Don't auto-fetch dependencies
            }
          },
          cmd = { "/Users/L021136/.local/bin/elixir-ls-v0.29.2/language_server.sh" },
        },
      }


      for _, name in ipairs(servers) do
        if custom[name] then
          vim.lsp.config(name, custom[name])
        end
        local ok, msg = pcall(vim.lsp.enable, name)
        if ok then
          print('Loaded ' .. name)
        else
          print('Failed to load ' .. name .. ' MSG: ' .. msg)
        end
      end

      -- auto fmt before save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function (args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method('textDocument/formatting', 0) then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function ()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
