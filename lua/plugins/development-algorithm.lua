-- Development Algorithm Integration
-- Keybindings and commands to support the development workflow

return {
  -- Plugin to add development workflow commands
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({
        -- Development Algorithm shortcuts
        { "<leader>D", group = "Dev Algorithm" },
        { "<leader>Dj", "<cmd>!~/.config/nvim/scripts/journal.sh<cr>", desc = "Open Today's Journal" },
        { "<leader>Dd", "<cmd>e ~/.config/nvim/DEVELOPMENT_ALGORITHM.md<cr>", desc = "Open Dev Algorithm" },
        { "<leader>Dq", "<cmd>e ~/.config/nvim/QUICK_REFERENCE.md<cr>", desc = "Quick Reference" },
        { "<leader>DD", function()
          -- Prompt for feature name using Neovim's input UI
          vim.ui.input({ prompt = "Feature/Decision name (kebab-case): " }, function(feature_name)
            if feature_name and feature_name ~= "" then
              -- Create the files using the script
              local result = vim.fn.system("~/.config/nvim/scripts/dual-doc.sh " .. vim.fn.shellescape(feature_name))

              -- Parse the output to get file paths
              local ddr_file = result:match("DDR: ([^\n]+)")
              local zettel_file = result:match("ZETTEL: ([^\n]+)")

              if ddr_file and zettel_file then
                -- Open both files in vertical splits
                vim.cmd("vsplit " .. vim.fn.fnameescape(ddr_file))
                vim.cmd("wincmd l")
                vim.cmd("edit " .. vim.fn.fnameescape(zettel_file))
                vim.cmd("wincmd h")
                vim.notify("Dual documentation created!", vim.log.levels.INFO)
              else
                vim.notify("Error creating files. Check :messages for details", vim.log.levels.ERROR)
              end
            else
              vim.notify("Feature name is required", vim.log.levels.ERROR)
            end
          end)
        end, desc = "Create Dual Documentation" },
        { "<leader>Dr", "<cmd>e ~/.config/nvim/DUAL_DOCUMENTATION.md<cr>", desc = "Dual Doc Guide" },
        { "<leader>Dt", group = "TDD" },
        { "<leader>Dtr", function()
          local filetype = vim.bo.filetype
          if filetype == "python" then
            vim.cmd("!pytest %:p:h/test_%:t:r.py -xvs")
          elseif filetype == "java" then
            local file = vim.fn.expand('%:p')
            local dir = vim.fn.expand('%:p:h')
            vim.cmd('!cd "' .. dir .. '" && javac "' .. vim.fn.expand('%:t') .. '" && java ' .. vim.fn.expand('%:t:r'))
          elseif filetype == "julia" then
            local file = vim.fn.expand('%:p')
            vim.cmd('!julia --project=. "' .. file .. '"')
          else
            vim.notify("Test runner not configured for " .. filetype, vim.log.levels.WARN)
          end
        end, desc = "Run test for current file" },
        { "<leader>Dtw", function()
          local filetype = vim.bo.filetype
          if filetype == "python" then
            vim.cmd("!pytest-watch %:p:h/test_%:t:r.py")
          elseif filetype == "julia" then
            vim.notify("Watch mode not yet implemented for Julia", vim.log.levels.INFO)
          else
            vim.notify("Watch mode not configured for " .. filetype, vim.log.levels.WARN)
          end
        end, desc = "Watch test for current file" },
        { "<leader>Dta", function()
          local filetype = vim.bo.filetype
          if filetype == "python" then
            vim.cmd("!pytest")
          elseif filetype == "java" then
            vim.cmd('!find . -name "*.java" -type f -print0 | xargs -0 javac')
          elseif filetype == "julia" then
            vim.cmd('!julia --project=. -e "using Pkg; Pkg.test()"')
          else
            vim.notify("Test all not configured for " .. filetype, vim.log.levels.WARN)
          end
        end, desc = "Run all tests" },
        { "<leader>Dtc", function()
          local filetype = vim.bo.filetype
          if filetype == "python" then
            vim.cmd("!pytest --cov --cov-report=term-missing")
          elseif filetype == "java" then
            local file = vim.fn.expand('%:p')
            local dir = vim.fn.expand('%:p:h')
            vim.cmd('!cd "' .. dir .. '" && time javac "' .. vim.fn.expand('%:t') .. '" && time java ' .. vim.fn.expand('%:t:r'))
          elseif filetype == "julia" then
            vim.cmd('!julia --startup-file=no --code-coverage=user --project=. -e "using Pkg; Pkg.test()"')
          else
            vim.notify("Coverage not configured for " .. filetype, vim.log.levels.WARN)
          end
        end, desc = "Test coverage/timing" },

        -- Git workflow enhancements
        { "<leader>Dg", group = "Git Flow" },
        { "<leader>Dgn", function()
          -- Create new feature branch
          vim.ui.input({ prompt = "Feature name: " }, function(name)
            if name then
              vim.cmd("!git checkout main && git pull && git checkout -b feature/" .. name)
            end
          end)
        end, desc = "New feature branch" },
        { "<leader>Dgc", function()
          -- Commit with conventional commit
          vim.ui.select(
            { "feat", "fix", "test", "refactor", "docs", "style", "perf", "chore" },
            { prompt = "Commit type: " },
            function(type)
              if type then
                vim.ui.input({ prompt = "Scope (optional): " }, function(scope)
                  vim.ui.input({ prompt = "Description: " }, function(desc)
                    if desc then
                      local msg = type
                      if scope and scope ~= "" then
                        msg = msg .. "(" .. scope .. ")"
                      end
                      msg = msg .. ": " .. desc
                      vim.cmd("!git add -A && git commit -m '" .. msg .. "'")
                    end
                  end)
                end)
              end
            end
          )
        end, desc = "Conventional commit" },
        { "<leader>Dgp", "<cmd>!git push -u origin HEAD<cr>", desc = "Push current branch" },
        { "<leader>Dgpr", "<cmd>!gh pr create<cr>", desc = "Create PR" },

        -- Metrics tracking
        { "<leader>Dm", group = "Metrics" },
        { "<leader>Dmt", function()
          -- Quick time tracker
          local start_time = vim.g.task_start_time
          if start_time then
            local elapsed = os.time() - start_time
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            vim.notify(string.format("Task time: %dh %dm", hours, minutes))
            vim.g.task_start_time = nil
          else
            vim.g.task_start_time = os.time()
            vim.notify("Task timer started")
          end
        end, desc = "Toggle task timer" },
      })
      return opts
    end,
  },

  -- Add a startup dashboard reminder
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard or {}, {
        sections = {
          {
            section = "header",
            text = {
              "╭─────────────────────────────────────╮",
              "│     Development Algorithm Active     │",
              "│                                     │",
              "│  1. Understand → 2. Test → 3. Code  │",
              "│  4. Refactor → 5. Commit → 6. Learn │",
              "│                                     │",
              "│     'Discipline equals freedom'     │",
              "╰─────────────────────────────────────╯",
            },
          },
          { section = "keys" },
          { section = "recent_files" },
          {
            section = "custom",
            title = "Quick Actions",
            content = {
              { key = "j", desc = "Today's Journal", action = "!~/.config/nvim/scripts/journal.sh" },
              { key = "d", desc = "Dev Algorithm", action = "e ~/.config/nvim/DEVELOPMENT_ALGORITHM.md" },
              { key = "q", desc = "Quick Reference", action = "e ~/.config/nvim/QUICK_REFERENCE.md" },
              { key = "t", desc = "TODO List", action = "TodoWrite" },
            },
          },
        },
      })
      return opts
    end,
  },
}