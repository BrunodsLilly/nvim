return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",  -- Python debugging support
    },
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
      { "<leader>dB", function()
        require("dap").clear_breakpoints()
        vim.notify("All breakpoints cleared", vim.log.levels.INFO)
      end, desc = "Clear All Breakpoints" },
      { "<leader>dL", function()
        require("dap").list_breakpoints()
        vim.cmd("copen")
      end, desc = "List Breakpoints" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
      { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
      { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
      { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dx", function()
        require("dap").terminate()
        require("dapui").close()
      end, desc = "Stop and Close DAP UI" },
      { "<leader>dr", "<cmd>DapToggleRepl<cr>", desc = "Toggle REPL" },
      -- Python-specific keybindings
      { "<leader>dpt", function() require("dap-python").test_method() end, desc = "Debug Python Test Method" },
      { "<leader>dpc", function() require("dap-python").test_class() end, desc = "Debug Python Test Class" },
      { "<leader>dpf", function()
        -- Debug all tests in current file
        local filepath = vim.fn.expand("%:p")
        require("dap-python").test_method({ pytest = filepath })
      end, desc = "Debug All Tests in File" },
      { "<leader>dpp", function()
        -- Debug all tests in project (run pytest from project root)
        require("dap-python").test_method({ pytest = "." })
      end, desc = "Debug All Tests in Project" },
      { "<leader>dpl", function() require("dap-python").debug_selection() end, desc = "Debug Selection", mode = "v" },
      -- Break-on-failure mode (like pytest --pdb)
      { "<leader>dpb", function()
        require("config.dap-pytest-pdb").test_with_break()
      end, desc = "Debug Test (Break on Failure)" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Don't auto-close on termination - let user see the final state
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end

      -- Only auto-close on clean exit (not on errors/failures)
      dap.listeners.before.event_exited["dapui_config"] = function(session, body)
        -- Keep UI open if there was an error (non-zero exit code)
        if body and body.exitCode and body.exitCode == 0 then
          dapui.close()
        end
        -- Otherwise, leave it open so user can inspect the error
      end

      -- Python debugging setup
      local dap_python = require("dap-python")
      dap_python.setup("python3")  -- Use system python3
      -- If you use a virtual environment, you can specify the path:
      -- dap_python.setup("~/.virtualenvs/debugpy/bin/python")

      -- Python test runner configuration
      dap_python.test_runner = "pytest"

      -- Override the pytest runner to add --pdb-trace flag
      dap_python.test_runner = function(classname, methodname)
        local pytest_args = {
          "-v",
          "-s",  -- No capture, show output
          "--tb=short",  -- Short traceback format
        }

        -- Build the test selection
        local test_path = vim.fn.expand("%:p")
        if classname and methodname then
          table.insert(pytest_args, test_path .. "::" .. classname .. "::" .. methodname)
        elseif methodname then
          table.insert(pytest_args, test_path .. "::" .. methodname)
        else
          table.insert(pytest_args, test_path)
        end

        return "pytest", pytest_args
      end

      -- Configure Python adapter to break on exceptions (including AssertionError)
      for _, config in ipairs(dap.configurations.python) do
        config.justMyCode = false
        config.stopOnEntry = false

        -- This is the key: raise on exception
        config.exceptionOptions = {
          {
            path = {
              {
                negate = false,
                names = { "Python Exceptions" }
              }
            },
            breakMode = "always"  -- Break on all exceptions, including AssertionError
          }
        }
      end

      -- Configure pytest to break on assertion failures
      -- This modifies the default pytest configuration
      for _, config in pairs(dap.configurations.python) do
        if config.request == "test" then
          config.exceptionOptions = {
            {
              path = {
                {
                  negate = false,
                  names = { "Python Exceptions" }
                }
              },
              breakMode = "always"
            }
          }
        end
      end

      -- Custom DAP signs (optional - makes breakpoints more visible)
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "⚫", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped" })

      -- Setup custom pytest break-on-failure configuration
      require("config.dap-pytest-pdb").setup()
    end,
  },
}
