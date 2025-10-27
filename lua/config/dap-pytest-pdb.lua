-- Custom pytest configuration that breaks on assertion failures
local M = {}

function M.setup()
  local dap = require("dap")

  -- Add a custom pytest configuration that breaks on exceptions
  table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Pytest: Break on Failure",
    module = "pytest",
    args = function()
      local args = { "-v", "-s" }

      -- Get current test
      local line = vim.fn.line(".")
      local filepath = vim.fn.expand("%:p")

      -- Try to find the test function/class at cursor
      local test_name = vim.fn.search("^\\s*\\(def\\|class\\) \\(test_\\w\\+\\)", "bnW")
      if test_name > 0 then
        local test_line = vim.fn.getline(test_name)
        local name = test_line:match("def%s+(test_%w+)") or test_line:match("class%s+(Test%w+)")
        if name then
          table.insert(args, filepath .. "::" .. name)
        else
          table.insert(args, filepath)
        end
      else
        table.insert(args, filepath)
      end

      return args
    end,
    console = "integratedTerminal",
    justMyCode = false,
    -- KEY: This makes debugpy break on ALL exceptions including AssertionError
    postDebugTask = nil,
    exceptionOptions = {
      raised = {
        "AssertionError",
        "Exception",
      },
    },
  })
end

-- Function to run pytest with break-on-failure
function M.test_with_break()
  local dap = require("dap")

  -- Find and use our custom configuration
  for _, config in ipairs(dap.configurations.python) do
    if config.name == "Pytest: Break on Failure" then
      dap.run(config)
      return
    end
  end

  vim.notify("Pytest break-on-failure config not found", vim.log.levels.ERROR)
end

return M
