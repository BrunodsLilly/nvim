local M = {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function ()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'python', 'rust', 'typescript', 'javascript', 'html', 'css', 'ninja', 'rst' },
      auto_install = false,
      sync_install = true,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        disable = function (lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat,
            vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
    }

    -- Setup treesitter-context (sticky headers)
    require('treesitter-context').setup {
      enable = true,
      max_lines = 3,
    }
  end
}

return { M }
