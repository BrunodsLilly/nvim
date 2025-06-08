-- lua/config/diagnostics.lua
local M = {}

-- Put all diagnostics *from buffers in the current working directory* into qf
function M.cwd_diagnostics_to_qf()
  local cwd = vim.fn.getcwd()                     -- e.g. /home/bruno/project
  if cwd:sub(-1) ~= '/' then cwd = cwd .. '/' end -- ensure trailing slash

  local qf_items = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(bufnr) -- absolute path

    -- skip unnamed / non-file buffers and those outside the cwd
    if name ~= '' and name:sub(1, #cwd) == cwd then
      local diags = vim.diagnostic.get(bufnr) -- all severities
      -- convert diagnostics to qf items and attach buffer number
      vim.list_extend(qf_items, vim.diagnostic.toqflist(diags))
    end
  end

  -- Replace quick-fix list and open it
  vim.fn.setqflist({}, ' ', { title = 'Diagnostics (cwd)', items = qf_items })
  if #qf_items > 0 then vim.cmd('copen') end
end

return M
