-- Spaced Repetition System for Zettelkasten
-- Stores review state in frontmatter

return {
  {
    "renerocksai/telekasten.nvim",
    opts = function(_, opts)
      -- Extend existing Telekasten config
      return opts
    end,
    keys = {
      -- Review commands
      {
        "<leader>zR",
        function()
          local notes_dir = vim.fn.expand("~/zettelkasten")
          local today = os.date("%Y-%m-%d")

          -- Build grep pattern to find notes due for review
          local cmd = string.format(
            "rg --files-with-matches 'next_review: (\\d{4}-\\d{2}-\\d{2})' %s | xargs grep -l 'next_review: [0-2][0-9][0-9][0-9]-.*' | while read f; do awk '/next_review:/ {if ($2 <= \"%s\") print FILENAME}' \"$f\"; done | sort -u",
            notes_dir,
            today
          )

          -- Simple version: just search for notes with review frontmatter
          require('telescope.builtin').grep_string({
            search = "next_review:",
            search_dirs = {notes_dir},
            prompt_title = "Notes Due for Review",
          })
        end,
        desc = "Show notes due for review",
      },

      -- Mark note as reviewed
      {
        "<leader>zr",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, 30, false)

          -- Find frontmatter
          local fm_start, fm_end
          local in_frontmatter = false
          for i, line in ipairs(lines) do
            if line == "---" then
              if not in_frontmatter then
                fm_start = i
                in_frontmatter = true
              else
                fm_end = i
                break
              end
            end
          end

          if not fm_start or not fm_end then
            print("⚠️  No frontmatter found. Add frontmatter first.")
            return
          end

          -- Parse existing review data
          local review_count = 0
          local last_reviewed_line = nil
          local next_review_line = nil
          local review_count_line = nil

          for i = fm_start, fm_end - 1 do
            local line = lines[i]
            if line:match("^review_count:") then
              review_count = tonumber(line:match("%d+")) or 0
              review_count_line = i
            elseif line:match("^last_reviewed:") then
              last_reviewed_line = i
            elseif line:match("^next_review:") then
              next_review_line = i
            end
          end

          -- Calculate next review date (Fibonacci-like spacing)
          review_count = review_count + 1
          local intervals = {1, 2, 4, 8, 16, 32, 64, 128}  -- days
          local interval = intervals[math.min(review_count, #intervals)]

          local today = os.date("%Y-%m-%d")
          local next_date = os.date("%Y-%m-%d", os.time() + interval * 24 * 60 * 60)

          -- Update frontmatter
          local new_lines = {}
          for i = 1, #lines do
            if i == review_count_line then
              table.insert(new_lines, string.format("review_count: %d", review_count))
            elseif i == last_reviewed_line then
              table.insert(new_lines, string.format("last_reviewed: %s", today))
            elseif i == next_review_line then
              table.insert(new_lines, string.format("next_review: %s", next_date))
            else
              table.insert(new_lines, lines[i])
            end
          end

          -- If fields don't exist, add them before closing ---
          if not review_count_line then
            table.insert(new_lines, fm_end, string.format("review_count: %d", review_count))
          end
          if not last_reviewed_line then
            table.insert(new_lines, fm_end, string.format("last_reviewed: %s", today))
          end
          if not next_review_line then
            table.insert(new_lines, fm_end, string.format("next_review: %s", next_date))
          end

          -- Update buffer
          vim.api.nvim_buf_set_lines(buf, 0, #lines, false, new_lines)

          print(string.format("✅ Reviewed! Next review in %d days (%s)", interval, next_date))
        end,
        desc = "Mark note as reviewed",
      },

      -- Initialize review tracking
      {
        "<leader>zI",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, 30, false)

          -- Check if frontmatter exists
          local has_frontmatter = false
          local fm_end_line = nil
          local in_fm = false

          for i, line in ipairs(lines) do
            if line == "---" then
              if not in_fm then
                has_frontmatter = true
                in_fm = true
              else
                fm_end_line = i - 1
                break
              end
            end
          end

          if not has_frontmatter then
            print("⚠️  No frontmatter found. Add frontmatter first.")
            return
          end

          -- Check if review fields already exist
          local has_review = false
          for i = 1, fm_end_line do
            if lines[i]:match("review_count:") then
              has_review = true
              break
            end
          end

          if has_review then
            print("⚠️  Review tracking already initialized")
            return
          end

          -- Add review fields
          local today = os.date("%Y-%m-%d")
          local next_review = os.date("%Y-%m-%d", os.time() + 24 * 60 * 60)  -- Tomorrow

          local insert_lines = {
            "review_count: 0",
            string.format("last_reviewed: %s", today),
            string.format("next_review: %s", next_review),
          }

          -- Insert before closing ---
          vim.api.nvim_buf_set_lines(buf, fm_end_line, fm_end_line, false, insert_lines)

          print("✅ Review tracking initialized. Next review: " .. next_review)
        end,
        desc = "Initialize review tracking",
      },
    },
  },
}
