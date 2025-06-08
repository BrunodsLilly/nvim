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
vim.cmd.colorscheme('tokyonight')

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

-- lsp
vim.keymap.set('n', 'gd', function () vim.lsp.buf.definition() end)
