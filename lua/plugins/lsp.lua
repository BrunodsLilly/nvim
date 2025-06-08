return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
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
      local servers = { 'lua_ls', 'pyright', 'gopls', 'rust_analyzer',
        'sourcekit' }
      local custom = {
        lua_ls = {
          settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
        },
        sourcekit = {                         -- Swift
          cmd          = { 'sourcekit-lsp' }, -- or full path to Xcode’s binary
          filetypes    = { 'swift', 'objective-c', 'objective-cpp' },
          capabilities = {
            workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
          },
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
