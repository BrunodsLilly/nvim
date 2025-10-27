print('advent of neovim!');

-- install Lazy.nvim
require('config.lazy');

-- refresh vim config
vim.keymap.set('n', '<space><space>x', '<cmd>source ~/.config/nvim/init.lua<CR>');

-- run current lines
vim.keymap.set('n', '<space>x', ':.lua<CR>');
vim.keymap.set('v', '<space>x', ':.lua<CR>');

-- highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank',
        { clear = true }),
    callback = function ()
        vim.highlight.on_yank();
    end,
});

-- quickfix
vim.keymap.set('n', '<M-k>', '<cmd>cprev<CR>')
vim.keymap.set('n', '<M-j>', '<cmd>cnext<CR>')
vim.keymap.set('n', '<M-c>', '<cmd>cclose<CR>')

-- terminal
vim.keymap.set('n', '<space>st', function ()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd('J')
    vim.api.nvim_win_set_height(0, 15)
    vim.cmd.normal { 'i', bang = true }
end
)

-- Oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })


-- set vim options
vim.opt.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.wo.number = true
vim.wo.relativenumber = true
vim.cmd.setnotermguicolors = true
vim.cmd.colorscheme('desert')

-- diagnostics
vim.keymap.set('n', ']d',
    function () vim.diagnostic.jump { count = 1, float = true } end)
vim.keymap.set('n', '[d',
    function () vim.diagnostic.jump { count = -1, float = true } end)
vim.keymap.set(
    'n',
    '<space>qf',
    require('config.diagnostics').cwd_diagnostics_to_qf,
    { desc = 'Diagnostics (cwd) → quickfix' }
)

-- View full messages (no truncation)
vim.keymap.set('n', '<leader>m', '<cmd>messages<cr>', { desc = 'Show messages' })

-- lsp
vim.keymap.set('n', 'gd', function () vim.lsp.buf.definition() end)

-- Format with import sorting and auto-fixes
vim.keymap.set('n', '<leader>cf', function()
  -- First organize imports (Ruff)
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
  -- Then format
  vim.lsp.buf.format({ async = false })
end, { desc = 'Format and organize imports' })

-- Quick format without organizing imports
vim.keymap.set('n', '<leader>cF', function()
  vim.lsp.buf.format({ async = false })
end, { desc = 'Format only (no import sort)' })

-- Folding
vim.opt.foldmethod = 'expr'  -- Use expression folding (treesitter)
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99  -- Start with all folds open
vim.opt.foldlevelstart = 99  -- Open all folds when opening a file
vim.opt.foldenable = true

-- Fold keybindings (easy to remember)
vim.keymap.set('n', 'za', 'za', { desc = 'Toggle fold under cursor' })
vim.keymap.set('n', 'zA', 'zA', { desc = 'Toggle fold recursively' })
vim.keymap.set('n', 'zc', 'zc', { desc = 'Close fold' })
vim.keymap.set('n', 'zC', 'zC', { desc = 'Close all folds recursively' })
vim.keymap.set('n', 'zo', 'zo', { desc = 'Open fold' })
vim.keymap.set('n', 'zO', 'zO', { desc = 'Open all folds recursively' })
vim.keymap.set('n', 'zm', 'zm', { desc = 'Fold more (close one level)' })
vim.keymap.set('n', 'zM', 'zM', { desc = 'Close all folds' })
vim.keymap.set('n', 'zr', 'zr', { desc = 'Fold less (open one level)' })
vim.keymap.set('n', 'zR', 'zR', { desc = 'Open all folds' })

-- Extra convenient mappings
vim.keymap.set('n', '<leader>za', 'za', { desc = 'Toggle fold' })
vim.keymap.set('n', '<leader>zM', 'zM', { desc = 'Close all folds' })
vim.keymap.set('n', '<leader>zR', 'zR', { desc = 'Open all folds' })
