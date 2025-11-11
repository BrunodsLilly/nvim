-- Digital Garden Publishing
-- Keymaps for aggregating content and building Quartz site

return {
  {
    "nvim-lua/plenary.nvim",
    keys = {
      -- Aggregate content from Zettelkasten to digital garden
      {
        "<leader>pa",
        function()
          local script = vim.fn.expand("~/digital-garden/scripts/aggregate-content.sh")

          -- Check if script exists
          if vim.fn.filereadable(script) == 0 then
            vim.notify("❌ Aggregate script not found: " .. script, vim.log.levels.ERROR)
            return
          end

          vim.notify("📦 Aggregating content to digital garden...", vim.log.levels.INFO)

          -- Run the script in a terminal
          vim.cmd("split")
          vim.cmd("terminal bash " .. script)
          vim.cmd("resize 15")

          -- Auto-close terminal after script completes
          vim.defer_fn(function()
            vim.cmd("wincmd p")
          end, 3000)
        end,
        desc = "Aggregate Content to Digital Garden",
      },

      -- Build and serve Quartz (preview)
      {
        "<leader>pb",
        function()
          local quartz_dir = vim.fn.expand("~/digital-garden/quartz")

          -- Check if quartz directory exists
          if vim.fn.isdirectory(quartz_dir) == 0 then
            vim.notify("❌ Quartz directory not found: " .. quartz_dir, vim.log.levels.ERROR)
            return
          end

          vim.notify("🏗️  Building and serving Quartz site...", vim.log.levels.INFO)

          -- Run build and serve in terminal
          vim.cmd("split")
          vim.cmd("terminal cd " .. quartz_dir .. " && npx quartz build --serve")
          vim.cmd("resize 15")

          vim.notify("✅ Quartz serving at http://localhost:8080", vim.log.levels.INFO)
        end,
        desc = "Build & Serve Quartz (Preview)",
      },

      -- Deploy to GitHub Pages
      {
        "<leader>pd",
        function()
          local quartz_dir = vim.fn.expand("~/digital-garden/quartz")

          -- Check if quartz directory exists
          if vim.fn.isdirectory(quartz_dir) == 0 then
            vim.notify("❌ Quartz directory not found: " .. quartz_dir, vim.log.levels.ERROR)
            return
          end

          -- Confirm deployment
          local confirm = vim.fn.input("Deploy to GitHub Pages? (y/N): ")
          if confirm:lower() ~= "y" then
            vim.notify("❌ Deployment cancelled", vim.log.levels.WARN)
            return
          end

          local commit_msg = vim.fn.input("Commit message (default: Weekly update): ")
          if commit_msg == "" then
            commit_msg = "Weekly update"
          end

          vim.notify("🚀 Deploying to GitHub Pages...", vim.log.levels.INFO)

          -- Run sync command
          vim.cmd("split")
          vim.cmd(string.format("terminal cd %s && npx quartz sync --commit '%s'", quartz_dir, commit_msg))
          vim.cmd("resize 15")
        end,
        desc = "Deploy to GitHub Pages",
      },

      -- Full workflow: Aggregate + Build + Preview
      {
        "<leader>pp",
        function()
          local script = vim.fn.expand("~/digital-garden/scripts/aggregate-content.sh")
          local quartz_dir = vim.fn.expand("~/digital-garden/quartz")

          vim.notify("📦 Running full publishing workflow...", vim.log.levels.INFO)

          -- Run the full workflow
          vim.cmd("split")
          vim.cmd(string.format(
            "terminal bash %s && cd %s && npx quartz build --serve",
            script,
            quartz_dir
          ))
          vim.cmd("resize 15")

          vim.notify("✅ Workflow complete! Preview at http://localhost:8080", vim.log.levels.INFO)
        end,
        desc = "Publish: Aggregate + Build + Preview",
      },

      -- Check what will be published (dry run)
      {
        "<leader>pc",
        function()
          local zettel_dir = vim.fn.expand("~/zettelkasten")

          vim.notify("🔍 Checking publishable notes...", vim.log.levels.INFO)

          -- Find all notes with publish: true
          vim.cmd("split")
          vim.cmd(string.format(
            "terminal cd %s && echo '📋 Notes marked for publishing:' && echo '' && grep -r '^publish: true' . --include='*.md' -l | wc -l | awk '{print \"Total: \" $1 \" notes\"}' && echo '' && grep -r '^publish: true' . --include='*.md' -l",
            zettel_dir
          ))
          vim.cmd("resize 20")
        end,
        desc = "Check Publishable Notes",
      },
    },
  },
}
