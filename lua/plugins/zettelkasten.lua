-- Zettelkasten Second Brain System
-- Combines Vimwiki for wiki functionality with Zettelkasten principles

return {
  -- Vimwiki: The foundation for our knowledge base
  {
    "vimwiki/vimwiki",
    lazy = false,
    init = function()
      vim.g.vimwiki_list = {
        {
          path = "~/zettelkasten/",
          syntax = "markdown",
          ext = ".md",
          path_html = "~/zettelkasten/html/",
          custom_wiki2html = "vimwiki_markdown",
          template_path = "~/zettelkasten/templates/",
          template_default = "default",
          template_ext = ".html",
          auto_tags = 1,
          auto_diary_index = 1,
          auto_generate_links = 1,
          auto_generate_tags = 1,
        },
        {
          path = "~/zettelkasten/work/",
          syntax = "markdown",
          ext = ".md",
          name = "Work Notes",
        },
        {
          path = "~/zettelkasten/personal/",
          syntax = "markdown",
          ext = ".md",
          name = "Personal Growth",
        },
      }

      -- Vimwiki settings
      vim.g.vimwiki_global_ext = 0  -- Don't treat all .md files as wiki files
      vim.g.vimwiki_conceallevel = 0  -- Don't conceal links
      vim.g.vimwiki_markdown_link_ext = 1  -- Add .md extension to links
      vim.g.vimwiki_auto_chdir = 1  -- Auto change directory
      vim.g.vimwiki_folding = "expr"  -- Enable folding
      vim.g.vimwiki_auto_header = 1  -- Auto create header for new pages

      -- Custom mappings for Vimwiki (only in wiki files)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "vimwiki",
        callback = function()
          vim.keymap.set("n", "<leader>wt", "<cmd>VimwikiTable<cr>", { buffer = true, desc = "Create table" })
          vim.keymap.set("n", "<leader>wb", "<cmd>VimwikiBacklinks<cr>", { buffer = true, desc = "Show backlinks" })
          vim.keymap.set("n", "<leader>wg", "<cmd>VimwikiGenerateLinks<cr>", { buffer = true, desc = "Generate links" })
        end,
      })
    end,
    keys = {
      { "<leader>ww", "<cmd>VimwikiIndex<cr>", desc = "Open Zettelkasten Index" },
      { "<leader>wi", "<cmd>VimwikiDiaryIndex<cr>", desc = "Open Diary Index" },
      { "<leader>w<leader>w", "<cmd>VimwikiMakeDiaryNote<cr>", desc = "Today's Diary Entry" },
      { "<leader>w<leader>y", "<cmd>VimwikiMakeYesterdayDiaryNote<cr>", desc = "Yesterday's Diary Entry" },
      { "<leader>w<leader>t", "<cmd>VimwikiMakeTomorrowDiaryNote<cr>", desc = "Tomorrow's Diary Entry" },
      { "<leader>ws", "<cmd>VimwikiUISelect<cr>", desc = "Select Wiki" },
      { "<leader>wn", "<cmd>VimwikiGoto<cr>", desc = "Go to/Create Note" },
      { "<leader>wd", "<cmd>VimwikiDeleteFile<cr>", desc = "Delete Current Wiki File" },
      { "<leader>wr", "<cmd>VimwikiRenameFile<cr>", desc = "Rename Current Wiki File" },
    },
  },

  -- Telekasten: Advanced Zettelkasten features
  {
    "renerocksai/telekasten.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-media-files.nvim",
    },
    config = function()
      local home = vim.fn.expand("~/zettelkasten")
      require("telekasten").setup({
        home = home,
        take_over_my_home = false,
        auto_set_filetype = true,
        dailies = home .. "/daily",
        weeklies = home .. "/weekly",
        templates = home .. "/templates",
        image_subdir = "images",
        extension = ".md",
        new_note_filename = "uuid-title",
        uuid_type = "%Y%m%d%H%M",
        uuid_sep = "-",
        follow_creates_nonexisting = true,
        dailies_create_nonexisting = true,
        weeklies_create_nonexisting = true,
        journal_auto_open = false,

        -- Template for new notes
        template_new_note = home .. "/templates/new_note.md",
        template_new_daily = home .. "/templates/daily.md",
        template_new_weekly = home .. "/templates/weekly.md",

        -- Image link style
        image_link_style = "markdown",
        sort = "filename",

        -- Integrate with calendar-vim
        plug_into_calendar = false,
        calendar_opts = {
          weeknm = 4,
          calendar_monday = 1,
          calendar_mark = "left-fit",
        },

        -- Tags
        tag_notation = "#",
        command_palette_theme = "dropdown",
        show_tags_theme = "dropdown",
        subdirs_in_links = true,
        template_handling = "smart",
        new_note_location = "smart",
        rename_update_links = true,
        follow_url_fallback = nil,
      })

      -- Custom highlight groups
      vim.api.nvim_set_hl(0, "tkLink", { fg = "#7aa2f7", underline = true })
      vim.api.nvim_set_hl(0, "tkBrackets", { fg = "#565f89" })
      vim.api.nvim_set_hl(0, "tkHighlight", { bg = "#3b4261", fg = "#c0caf5" })
      vim.api.nvim_set_hl(0, "tkTag", { fg = "#9ece6a" })
    end,
    keys = {
      -- Note creation and navigation
      { "<leader>zn", "<cmd>Telekasten new_note<cr>", desc = "New Zettel" },
      { "<leader>zf", "<cmd>Telekasten find_notes<cr>", desc = "Find Notes" },
      { "<leader>zg", "<cmd>Telekasten search_notes<cr>", desc = "Grep Notes" },
      { "<leader>zd", "<cmd>Telekasten goto_today<cr>", desc = "Today's Daily Note" },
      { "<leader>zw", "<cmd>Telekasten goto_thisweek<cr>", desc = "This Week's Note" },
      { "<leader>zz", "<cmd>Telekasten follow_link<cr>", desc = "Follow Link" },

      -- Note organization
      { "<leader>zt", "<cmd>Telekasten show_tags<cr>", desc = "Show Tags" },
      { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>", desc = "Show Backlinks" },
      { "<leader>zl", "<cmd>Telekasten insert_link<cr>", desc = "Insert Link" },
      { "<leader>zT", "<cmd>Telekasten tag_picker<cr>", desc = "Tag Picker" },
      { "<leader>zr", "<cmd>Telekasten rename_note<cr>", desc = "Rename Note" },

      -- Advanced features
      { "<leader>zc", "<cmd>Telekasten show_calendar<cr>", desc = "Show Calendar" },
      { "<leader>zp", "<cmd>Telekasten panel<cr>", desc = "Command Panel" },
      { "<leader>zi", "<cmd>Telekasten insert_img_link<cr>", desc = "Insert Image" },
      { "<leader>zm", "<cmd>Telekasten browse_media<cr>", desc = "Browse Media" },
      { "<leader>za", "<cmd>Telekasten show_tags<cr>", desc = "All Tags" },

      -- Yanking and pasting
      { "<leader>zy", "<cmd>Telekasten yank_notelink<cr>", desc = "Yank Note Link" },
      { "<leader>zP", "<cmd>Telekasten paste_img_and_link<cr>", desc = "Paste Image" },
      { "<leader>zN", "<cmd>Telekasten new_templated_note<cr>", desc = "New Note from Template" },

      -- Git discovery note (for investigation and archaeology)
      {
        "<leader>zg",
        function()
          local date = os.date("%Y-%m-%d")
          local title = vim.fn.input("Git discovery title: ")
          if title == "" then
            vim.notify("❌ Title required for git discovery note", vim.log.levels.ERROR)
            return
          end

          local filename = string.format("git-discoveries/%s-%s.md",
            os.date("%Y%m%d%H%M"),
            title:gsub("%s+", "-"):lower())

          -- Create git-discoveries directory if it doesn't exist
          vim.fn.mkdir(vim.fn.expand("~/zettelkasten/git-discoveries"), "p")

          -- Open the file
          vim.cmd("e ~/zettelkasten/" .. filename)

          -- Check if file is new or only has auto-generated header
          local line_count = vim.fn.line('$')
          local first_line = vim.fn.getline(1)
          local is_new = (line_count == 1 and first_line == '') or
                         (line_count <= 4 and first_line:match("^# %d+%-"))

          -- If new file or only has auto-header, insert template
          if is_new then
            local template = {
              "---",
              string.format('title: "Git Discovery: %s"', title),
              string.format("date: %s", date),
              "type: git-discovery",
              "tags: [git, learning, debugging, investigation]",
              "publish: false",
              "---",
              "",
              string.format("# Git Discovery: %s", title),
              "",
              "## Investigation Question",
              "",
              "What question were you trying to answer?",
              "",
              "",
              "## Git Commands Used",
              "",
              "```bash",
              "git blame file.js:42",
              "git log -S 'searchTerm'",
              "git show abc123",
              "```",
              "",
              "## Discovery",
              "",
              "**Commit Details:**",
              "- SHA: `abc123`",
              "- Author: ",
              "- Date: " .. date,
              "- Message: ",
              "",
              "**What I Found:**",
              "",
              "",
              "## Root Cause / Insight",
              "",
              "**Why it happened:**",
              "",
              "",
              "**What I learned:**",
              "",
              "",
              "## Pattern or Principle",
              "",
              "This demonstrates: [[permanent/]]",
              "",
              "",
              "## Application",
              "",
              "**Can be applied to:**",
              "- ",
              "",
              "## Related Notes",
              "",
              string.format("- Daily work: [[daily/%s]]", date),
              "- [[]]",
              "",
              "## Questions Raised",
              "",
              "- [ ] ",
            }
            -- Replace entire buffer
            vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
            -- Move cursor to investigation question section
            vim.cmd("normal! 13G$")
          end
        end,
        desc = "New Git Discovery Note",
      },

      -- Public reflection (separate from private daily notes)
      {
        "<leader>zD",
        function()
          local date = os.date("%Y-%m-%d")
          local title = vim.fn.input("Reflection title (optional): ")
          local filename
          if title ~= "" then
            filename = string.format("reflections/%s-%s.md",
              os.date("%Y%m%d%H%M"),
              title:gsub("%s+", "-"):lower())
          else
            filename = string.format("reflections/%s-daily-reflection.md",
              os.date("%Y%m%d%H%M"))
          end

          -- Create reflections directory if it doesn't exist
          vim.fn.mkdir(vim.fn.expand("~/zettelkasten/reflections"), "p")

          -- Open the file
          vim.cmd("e ~/zettelkasten/" .. filename)

          -- Check if file is new or only has auto-generated header
          local line_count = vim.fn.line('$')
          local first_line = vim.fn.getline(1)
          local is_new = (line_count == 1 and first_line == '') or
                         (line_count <= 4 and first_line:match("^# %d+%-"))

          -- If new file or only has auto-header, insert template
          if is_new then
            local template = {
              "---",
              string.format('title: "Daily Reflection - %s"', date),
              string.format("date: %s", date),
              "type: reflection",
              "tags: [public, learning, reflection]",
              "publish: true",
              "---",
              "",
              string.format("# Daily Reflection - %s", date),
              "",
              "## What I Built/Learned Today",
              "",
              "",
              "## Key Insights",
              "- [[]]",
              "",
              "",
              "## Challenges",
              "",
              "",
              "## Tomorrow's Focus",
              "",
              "",
              "## Related",
              string.format("- [[daily/%s]] (private notes)", date),
              "- [[]]",
            }
            -- Replace entire buffer
            vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
            -- Move cursor to first content line
            vim.cmd("normal! 11G$")
          end
        end,
        desc = "New Daily Reflection (Public)",
      },

      -- Visual mode mappings
      { "<leader>zl", "<cmd>Telekasten link_followable<cr>", mode = "v", desc = "Make Selection Linkable" },
      { "<leader>zt", "<cmd>Telekasten toggle_todo<cr>", mode = "v", desc = "Toggle TODO" },
      { "[[", "<cmd>Telekasten insert_link<cr>", mode = "i", desc = "Insert Link" },

      -- Quick "word to zettel" mappings
      {
        "<leader>zL",
        function()
          -- Select word under cursor and make it a link
          vim.cmd("normal! viw")
          vim.cmd("Telekasten link_followable")
        end,
        desc = "Word → Zettel Link",
      },
      {
        "<leader>zZ",
        function()
          -- Select word, make link, and immediately create the note
          local word = vim.fn.expand('<cword>')
          vim.cmd("normal! viw")
          require('telekasten').link_followable()
          vim.defer_fn(function()
            require('telekasten').follow_link()
          end, 100)
        end,
        desc = "Word → Create Zettel Now",
      },
    },
  },

  -- Markdown enhancements for better note-taking
  {
    "preservim/vim-markdown",
    ft = "markdown",
    config = function()
      vim.g.vim_markdown_folding_disabled = 0
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_new_list_item_indent = 2
      vim.g.vim_markdown_auto_insert_bullets = 1
      vim.g.vim_markdown_toc_autofit = 1
    end,
  },

  -- Markdown preview for reviewing notes with LaTeX/Chemistry support
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "vimwiki" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "vimwiki" }
    end,
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_theme = 'dark'
      vim.g.mkdp_filetypes = { 'markdown', 'vimwiki' }
      vim.g.mkdp_page_title = '「${name}」'
      -- Configure KaTeX with mhchem for chemistry
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {
          macros = {
            -- Common math symbols
            ['\\RR'] = '\\mathbb{R}',
            ['\\NN'] = '\\mathbb{N}',
            ['\\ZZ'] = '\\mathbb{Z}',
            ['\\QQ'] = '\\mathbb{Q}',
            ['\\CC'] = '\\mathbb{C}',
          },
        },
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview (Browser)" },
      { "<leader>mP", "<cmd>MarkdownPreview<cr>", desc = "Start Markdown Preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Markdown Preview" },
    },
  },

  -- Calendar integration for daily notes
  {
    "mattn/calendar-vim",
    cmd = "Calendar",
    config = function()
      vim.g.calendar_monday = 1
      vim.g.calendar_weeknm = 4
    end,
  },

  -- Bullets.vim for better list management
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    config = function()
      vim.g.bullets_enabled_file_types = {
        "markdown",
        "text",
        "gitcommit",
        "vimwiki",
      }
      vim.g.bullets_enable_in_empty_buffers = 1
      vim.g.bullets_checkbox_markers = " .oOx"
      vim.g.bullets_mapping_leader = "<M-b>"
    end,
  },

  -- Vim-table-mode for creating ASCII tables
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "vimwiki" },
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_align_char = ":"
      vim.keymap.set("n", "<leader>tm", "<cmd>TableModeToggle<cr>", { desc = "Toggle Table Mode" })
      vim.keymap.set("n", "<leader>tr", "<cmd>TableModeRealign<cr>", { desc = "Realign Table" })
    end,
  },
}