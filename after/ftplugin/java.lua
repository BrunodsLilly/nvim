-- Java file-type plugin
-- Java standard: 4-space indentation, 120-char line length

vim.opt_local.expandtab = true       -- Use spaces, not tabs
vim.opt_local.tabstop = 4            -- Tab display width
vim.opt_local.shiftwidth = 4         -- Indent size
vim.opt_local.softtabstop = 4        -- Consistent backspace behavior
vim.opt_local.colorcolumn = '120'    -- Common Java convention (120 chars)
