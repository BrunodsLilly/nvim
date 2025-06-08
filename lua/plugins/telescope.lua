return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function ()
    print('telescope')
    require('telescope').setup {
      pickers = {
        find_files = {
          theme = 'ivy'
        }
      },
      extensions = {
        fzf = {} -- load fzf native
      }
    }

    -- load fzf native
    require('telescope').load_extension('fzf')

    local builtin = require('telescope.builtin')
    -- find file
    vim.keymap.set('n', '<space>ff', builtin.find_files)

    -- help tags
    vim.keymap.set('n', '<space>fh', builtin.help_tags)

    -- find file in config
    vim.keymap.set('n', '<space>fc', function ()
      -- local themes = require("telescope.themes")
      -- local opts = themes.get_ivy({
      --   cwd = vim.fn.stdpath("config")
      -- })
      -- builtin.find_files(opts)
      builtin.find_files {
        cwd = vim.fn.stdpath('config')
      }
    end
    )

    -- find word
    vim.keymap.set('n', '<space>fw', function ()
      builtin.grep_string {
        search = vim.fn.input('Find word: ')
      }
    end
    )

    -- edit plugin package
    vim.keymap.set('n', '<space>ep', function ()
      builtin.find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
      }
    end
    )
  end
}
