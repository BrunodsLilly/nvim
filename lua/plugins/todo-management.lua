-- TODO Management Plugin Configuration
-- Central task tracking and progress monitoring

return {
  -- Todo comments highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {
      keywords = {
        FIX = { icon = "🐛", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "📝", color = "info" },
        HACK = { icon = "🔥", color = "warning" },
        WARN = { icon = "⚠️", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "⚡", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "📌", color = "hint", alt = { "INFO" } },
        TEST = { icon = "🧪", color = "info", alt = { "TESTING", "PASSED", "FAILED" } },
        DONE = { icon = "✅", color = "hint", alt = { "COMPLETED", "FINISHED" } },
      },
    },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODO comments" },
      { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX<cr>", desc = "Find TODO/FIX only" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
    },
  },

  -- Quick access to central TODO.md - Standalone keymaps
  {
    "folke/lazy.nvim",
    keys = {
      {
        "<leader>td",
        function()
          vim.cmd("edit " .. vim.fn.stdpath("config") .. "/TODO.md")
        end,
        desc = "Open central TODO.md"
      },
      {
        "<leader>tD",
        function()
          -- Open TODO.md in a vertical split
          vim.cmd("vsplit " .. vim.fn.stdpath("config") .. "/TODO.md")
        end,
        desc = "Open TODO.md in split"
      },
      {
        "<leader>tt",
        function()
          -- Quick add task to TODO.md
          local task = vim.fn.input("New task: ")
          if task ~= "" then
            local todo_file = vim.fn.stdpath("config") .. "/TODO.md"
            local lines = vim.fn.readfile(todo_file)

            -- Find the "Active Tasks" section and add the new task
            local insert_line = 0
            for i, line in ipairs(lines) do
              if line:match("^### Today's Focus") then
                insert_line = i + 1
                -- Find the next empty line or section
                while insert_line <= #lines and lines[insert_line]:match("^%- %[") do
                  insert_line = insert_line + 1
                end
                break
              end
            end

            if insert_line > 0 then
              table.insert(lines, insert_line, "- [ ] " .. task)
              vim.fn.writefile(lines, todo_file)
              vim.notify("Task added to TODO.md", vim.log.levels.INFO)
            end
          end
        end,
        desc = "Quick add task to TODO.md"
      },
      {
        "<leader>tm",
        function()
          -- Show today's metrics in a floating window
          local todo_file = vim.fn.stdpath("config") .. "/TODO.md"
          local lines = vim.fn.readfile(todo_file)
          local metrics = {}
          local in_metrics = false

          for _, line in ipairs(lines) do
            if line:match("^## 📊 Current Sprint Metrics") then
              in_metrics = true
            elseif in_metrics and line:match("^## ") then
              break
            elseif in_metrics and line:match("^|") then
              table.insert(metrics, line)
            end
          end

          if #metrics > 0 then
            -- Create floating window with metrics
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, metrics)

            local width = 60
            local height = #metrics
            local win = vim.api.nvim_open_win(buf, true, {
              relative = "editor",
              width = width,
              height = height,
              col = (vim.o.columns - width) / 2,
              row = (vim.o.lines - height) / 2,
              style = "minimal",
              border = "rounded",
              title = " Sprint Metrics ",
              title_pos = "center",
            })

            -- Close on any key press
            vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', {noremap = true, silent = true})
            vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', {noremap = true, silent = true})
          end
        end,
        desc = "Show sprint metrics"
      },
    },
  },

  -- Integration with which-key for TODO commands
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        { "<leader>t", group = "todo", icon = "📝" },
        { "<leader>td", desc = "Open TODO.md" },
        { "<leader>tD", desc = "TODO.md in split" },
        { "<leader>tt", desc = "Quick add task" },
        { "<leader>tm", desc = "Show metrics" },
        { "<leader>ft", desc = "Find TODOs" },
        { "<leader>fT", desc = "Find TODO/FIX" },
      })
      return opts
    end,
  },
}

-- Additional TODO utilities can be added here:
--
-- 1. Task completion tracking
-- 2. Metric auto-update
-- 3. Weekly review automation
-- 4. Progress visualization
-- 5. GitHub issue integration
-- 6. Time tracking
-- 7. Pomodoro integration
-- 8. Notification system