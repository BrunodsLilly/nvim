-- Enhanced Markdown Rendering and Preview
-- Beautiful in-buffer markdown rendering

return {
  -- render-markdown.nvim: Beautiful in-buffer markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "vimwiki" },
    config = function()
      require("render-markdown").setup({
        -- General configuration
        enabled = true,
        preset = "obsidian", -- Use Obsidian-like rendering
        max_file_size = 10.0, -- MB

        -- Headings configuration
        heading = {
          enabled = true,
          sign = true,
          icons = { "◉ ", "○ ", "✸ ", "✿ ", "▶ ", "▷ " },
          signs = { "󰫎 " },
          width = "full",
          backgrounds = {
            "RenderMarkdownH1Bg",
            "RenderMarkdownH2Bg",
            "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg",
            "RenderMarkdownH5Bg",
            "RenderMarkdownH6Bg",
          },
        },

        -- Code blocks configuration
        code = {
          enabled = true,
          sign = true,
          style = "full",
          width = "full",
          left_pad = 2,
          right_pad = 2,
          min_width = 0,
          border = "thin",
          language_pad = 2,
        },

        -- Dash and bullet configuration
        dash = {
          enabled = true,
          icon = "─",
          width = "full",
        },

        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },

        -- Checkbox configuration
        checkbox = {
          enabled = true,
          unchecked = { icon = "󰄱 " },
          checked = { icon = "󰱒 " },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
            important = { raw = "[!]", rendered = "󰀨 ", highlight = "RenderMarkdownImportant" },
            question = { raw = "[?]", rendered = "󰘥 ", highlight = "RenderMarkdownQuestion" },
          },
        },

        -- Quote configuration
        quote = {
          enabled = true,
          icon = "▌",
        },

        -- Table configuration
        table = {
          enabled = true,
          style = "full",
        },

        -- Callout configuration (for note blocks)
        callout = {
          note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
          tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
          important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
          warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
          caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
        },

        -- Link configuration
        link = {
          enabled = true,
          image = "󰥶 ",
          email = "󰀓 ",
          external = "󰌹 ",
          wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
        },

        -- Sign configuration
        sign = {
          enabled = true,
        },

        -- LaTeX configuration
        latex = {
          enabled = true,
          converter = "latex2text",
          highlight = "RenderMarkdownMath",
        },

        -- Window options override
        win_options = {
          conceallevel = {
            default = vim.o.conceallevel,
            rendered = 3,
          },
          concealcursor = {
            default = vim.o.concealcursor,
            rendered = "",
          },
        },
      })

      -- Custom highlights for better visibility
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#2d3142", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#2a2d3a", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#272a36", bold = true })
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#1e2030" })
      vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { bg = "#2a2d3a", fg = "#7aa2f7" })
      vim.api.nvim_set_hl(0, "RenderMarkdownWikiLink", { fg = "#9ece6a", underline = true })
    end,
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Rendering" },
    },
  },

  -- Optional: Markdown preview in browser (as backup)
  -- Already configured in zettelkasten.lua
}