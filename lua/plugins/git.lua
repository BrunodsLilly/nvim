return {
  -- Gitsigns: Git integration with blame, hunks, and more
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true, -- Show blame inline
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    keys = {
      -- Git blame
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Inline Git Blame" },
      { "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Show Full Blame" },

      -- Hunk navigation
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Next Git Hunk" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Previous Git Hunk" },

      -- Hunk actions
      { "<leader>ghs", function() require("gitsigns").stage_hunk() end, desc = "Stage Hunk" },
      { "<leader>ghr", function() require("gitsigns").reset_hunk() end, desc = "Reset Hunk" },
      { "<leader>ghS", function() require("gitsigns").stage_buffer() end, desc = "Stage Buffer" },
      { "<leader>ghu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo Stage Hunk" },
      { "<leader>ghR", function() require("gitsigns").reset_buffer() end, desc = "Reset Buffer" },
      { "<leader>ghp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },

      -- Visual mode hunk staging
      { "<leader>ghs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, mode = "v", desc = "Stage Hunk" },
      { "<leader>ghr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, mode = "v", desc = "Reset Hunk" },

      -- Text objects
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Select Git Hunk" },
    },
  },

  -- Vim Fugitive: Advanced git operations
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git Status (Fugitive)" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git Commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git Push" },
      { "<leader>gP", "<cmd>Git pull<cr>", desc = "Git Pull" },
      { "<leader>gl", "<cmd>Git log<cr>", desc = "Git Log" },
      { "<leader>gL", "<cmd>Git log --oneline<cr>", desc = "Git Log (Oneline)" },
      { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Git Fetch" },
      { "<leader>gD", "<cmd>Gdiffsplit<cr>", desc = "Git Diff Split" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git Write (Stage Current File)" },
      { "<leader>gr", "<cmd>Gread<cr>", desc = "Git Read (Checkout Current File)" },
    },
  },

  -- Git Blame in floating window
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false, -- Start disabled (toggle with command)
      message_template = " <author> • <date> • <summary>",
      date_format = "%Y-%m-%d %H:%M",
      virtual_text_column = 80,
    },
    keys = {
      { "<leader>gbt", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame (Virtual Text)" },
      { "<leader>gbo", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Open Commit in Browser" },
      { "<leader>gbc", "<cmd>GitBlameCopySHA<cr>", desc = "Copy Commit SHA" },
      { "<leader>gbf", "<cmd>GitBlameCopyFileURL<cr>", desc = "Copy File URL" },
    },
  },

  -- Git Archaeology: Investigation tools for bug discovery and learning
  {
    "nvim-lua/plenary.nvim",
    keys = {
      -- Git Pickaxe: Find when code was added/removed
      {
        "<leader>gF",
        function()
          local word = vim.fn.expand("<cword>")
          local search = vim.fn.input("Search for code (default: " .. word .. "): ", word)
          if search == "" then return end

          vim.cmd("split")
          vim.cmd(string.format("terminal git log -S '%s' -p --all", search))
          vim.cmd("resize 20")
          vim.notify("🔍 Searching git history for: " .. search, vim.log.levels.INFO)
        end,
        desc = "Git Pickaxe: Find when code was added/removed",
      },

      -- Follow file through renames
      {
        "<leader>gfF",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            vim.notify("❌ No file open", vim.log.levels.ERROR)
            return
          end

          vim.cmd("split")
          vim.cmd(string.format("terminal git log --follow -p -- %s", file))
          vim.cmd("resize 20")
          vim.notify("📜 Following file history through renames", vim.log.levels.INFO)
        end,
        desc = "Git: Follow file through renames",
      },

      -- Search commit messages
      {
        "<leader>gfm",
        function()
          local search = vim.fn.input("Search commit messages: ")
          if search == "" then return end

          vim.cmd("split")
          vim.cmd(string.format("terminal git log --grep='%s' --oneline --all", search))
          vim.cmd("resize 20")
          vim.notify("🔍 Searching commit messages for: " .. search, vim.log.levels.INFO)
        end,
        desc = "Git: Search commit messages",
      },

      -- Show what changed in a specific time period
      {
        "<leader>gft",
        function()
          local since = vim.fn.input("Show commits since (e.g., '1 week ago', '2024-01-01'): ", "1 week ago")
          if since == "" then return end

          vim.cmd("split")
          vim.cmd(string.format("terminal git log --since='%s' --oneline --graph --all", since))
          vim.cmd("resize 20")
          vim.notify("📅 Showing commits since: " .. since, vim.log.levels.INFO)
        end,
        desc = "Git: Show commits since date",
      },

      -- Find who changed specific lines (region blame)
      {
        "<leader>gfr",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            vim.notify("❌ No file open", vim.log.levels.ERROR)
            return
          end

          local start_line = vim.fn.line("'<")
          local end_line = vim.fn.line("'>")

          if start_line == 0 or end_line == 0 then
            vim.notify("❌ Select lines in visual mode first", vim.log.levels.ERROR)
            return
          end

          vim.cmd("split")
          vim.cmd(string.format("terminal git blame -L %d,%d %s", start_line, end_line, file))
          vim.cmd("resize 20")
          vim.notify(string.format("👥 Showing blame for lines %d-%d", start_line, end_line), vim.log.levels.INFO)
        end,
        mode = "v",
        desc = "Git: Blame selected lines",
      },

      -- Show file at specific commit
      {
        "<leader>gfh",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            vim.notify("❌ No file open", vim.log.levels.ERROR)
            return
          end

          local commit = vim.fn.input("Show file at commit (SHA or HEAD~N): ", "HEAD~1")
          if commit == "" then return end

          vim.cmd("vsplit")
          vim.cmd(string.format("terminal git show %s:%s", commit, vim.fn.expand("%:.")))
          vim.notify(string.format("📜 Showing file at commit: %s", commit), vim.log.levels.INFO)
        end,
        desc = "Git: Show file at commit",
      },

      -- Interactive git bisect helper
      {
        "<leader>gbi",
        function()
          local action = vim.fn.input("Git bisect [start/good/bad/reset/log]: ", "start")
          if action == "" then return end

          if action == "start" then
            local bad = vim.fn.input("Bad commit (default: HEAD): ", "HEAD")
            local good = vim.fn.input("Good commit: ", "")
            if good == "" then return end

            vim.cmd("split")
            vim.cmd(string.format("terminal git bisect start %s %s", bad, good))
            vim.cmd("resize 10")
            vim.notify("🔍 Git bisect started. Test code, then use <leader>gbi again", vim.log.levels.INFO)
          elseif action == "good" or action == "bad" then
            vim.cmd("split")
            vim.cmd(string.format("terminal git bisect %s", action))
            vim.cmd("resize 10")
          elseif action == "reset" then
            vim.cmd("split")
            vim.cmd("terminal git bisect reset")
            vim.cmd("resize 10")
            vim.notify("✅ Git bisect session ended", vim.log.levels.INFO)
          elseif action == "log" then
            vim.cmd("split")
            vim.cmd("terminal git bisect log")
            vim.cmd("resize 15")
          end
        end,
        desc = "Git Bisect: Find bug-introducing commit",
      },

      -- Show contributors to current file
      {
        "<leader>gfa",
        function()
          local file = vim.fn.expand("%:p")
          if file == "" then
            vim.notify("❌ No file open", vim.log.levels.ERROR)
            return
          end

          vim.cmd("split")
          vim.cmd(string.format("terminal git log --format='%%an' %s | sort | uniq -c | sort -rn", file))
          vim.cmd("resize 15")
          vim.notify("👥 Showing contributors to current file", vim.log.levels.INFO)
        end,
        desc = "Git: Show file contributors",
      },

      -- Reflog: See all recent changes
      {
        "<leader>gfR",
        function()
          vim.cmd("split")
          vim.cmd("terminal git reflog --all")
          vim.cmd("resize 20")
          vim.notify("🕐 Showing git reflog (all recent changes)", vim.log.levels.INFO)
        end,
        desc = "Git: Show reflog",
      },

      -- Compare with main/master branch
      {
        "<leader>gfM",
        function()
          local main_branch = vim.fn.input("Compare with branch (default: main): ", "main")
          if main_branch == "" then main_branch = "main" end

          vim.cmd("split")
          vim.cmd(string.format("terminal git log %s..HEAD --oneline", main_branch))
          vim.cmd("resize 15")
          vim.notify(string.format("📊 Commits on current branch not in %s", main_branch), vim.log.levels.INFO)
        end,
        desc = "Git: Compare branch with main",
      },
    },
  },
}

