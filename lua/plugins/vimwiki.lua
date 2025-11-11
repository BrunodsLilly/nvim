return {
  {
    'vimwiki/vimwiki',
    event = 'BufEnter *.md', -- Only load when opening markdown files
    init = function ()
      -- Define your wiki list. You can have multiple wikis.
      -- The 'path' should be the root of your GitHub repository.
      vim.g.vimwiki_list = {
        {
          path = '~/BrunodsLilly.github.io/',
          syntax = 'markdown',
          ext = '.md',
          diary_rel_path = 'diary/',
          diary_index = 'index',
          custom_wiki2html = 'vimwiki_markdown',
          auto_diary_index = 1,
          auto_tags = 1,
          auto_generate_links = 1,
          auto_generate_tags = 1
        }
      }

      -- Optional: Prevent Vimwiki from treating *all* markdown files as wiki files
      vim.g.vimwiki_global_ext = 0
      -- vim.g.vimwiki_ext2syntax = [] -- Ensures other .md files aren't treated as wiki files

      -- Optional: Auto-create header for diary notes (e.g., # YYYY-MM-DD)
      vim.g.vimwiki_auto_header = 1
    end,
    -- Keymaps for Vimwiki (optional, LazyVim often has defaults, but you can override)
    keys = {
      { '<leader>ww',        '<cmd>VimwikiIndex<CR>',         desc = 'Open Vimwiki Index' },
      { '<leader>wt',        '<cmd>VimwikiTOC<CR>',           desc = 'Open Vimwiki Table of Contents' },
      { '<leader><leader>d', '<cmd>VimwikiMakeDiaryNote<CR>', desc = 'Create Vimwiki Diary Note' },
      -- Add more keymaps as you like, e.g., for linking, converting, etc.
    }
  },
  {
    'michal-h21/vim-zettel',
    ft = 'vimwiki', -- Load only when in a vimwiki buffer
    dependencies = { 'vimwiki/vimwiki', 'junegunn/fzf', 'junegunn/fzf.vim' },
    init = function ()
      -- g:zettel_options is a list of tables. Since you have one wiki,
      -- we configure the first entry.
      vim.g.zettel_options = {
        {
          -- This is the key: it tells zettel to place new notes
          -- inside the 'zettel/' directory of your wiki path.
          rel_path = 'zettel/',

          -- We will add the template path here in the next step.
          template = os.getenv('HOME') ..
            '/.config/nvim/templates/zettel_template.md'
        }
      }

      -- Optional: Make filenames more descriptive by including the title.
      -- This creates a file like: 250702-1030-My-Note-Title.md
      vim.g.zettel_format = '%y%m%d-%H%M-%title'
      vim.g.zettel_default_title = 'untitled-zettel'
    end,
    -- Your keys section remains the same
    keys = {
      { '<leader>zn', '<cmd>ZettelNew<CR>',       desc = 'New Zettel Note' },
      { '<leader>zf', '<cmd>ZettelSearch<CR>',    desc = 'Find Zettel Note' },
      { '<leader>zs', '<cmd>ZettelSearchAll<CR>', desc = 'Search All Zettel Notes' },
      { 'gl',         '<Plug>ZettelBacklinks',    desc = 'Show Backlinks' },
      { '[[',         '<Plug>ZettelSearchMap',    mode = 'i',                      desc = 'Insert Zettel Link' },
    },
  }
}
