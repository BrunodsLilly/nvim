-- LaTeX Equation Rendering in Neovim
-- Renders LaTeX equations as images directly in buffer

return {
  -- image.nvim for rendering LaTeX equations as images
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown" },
          })
        end,
      },
    },
    opts = {
      backend = "kitty",
      processor = "magick_cli", -- Uses ImageMagick CLI (simpler, no LuaRocks needed)
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
  },

  -- Alternative/Complementary: hologram.nvim for Kitty terminal
  -- Uncomment if you use Kitty terminal and want better rendering
  -- {
  --   "edluffy/hologram.nvim",
  --   config = function()
  --     require('hologram').setup{
  --       auto_display = true -- WIP automatic markdown image display
  --     }
  --   end,
  -- },

  -- LaTeX snippet support with LuaSnip
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- LaTeX equation snippets for markdown
      ls.add_snippets("markdown", {
        -- Inline math
        s("$", {
          t("$"),
          i(1, "equation"),
          t("$"),
        }),

        -- Display math
        s("$$", {
          t({ "$$", "" }),
          i(1, "equation"),
          t({ "", "$$" }),
        }),

        -- Integral
        s("int", {
          t("\\int_{"),
          i(1, "a"),
          t("}^{"),
          i(2, "b"),
          t("} "),
          i(3, "f(x)"),
          t(" \\, dx"),
        }),

        -- Fraction
        s("frac", {
          t("\\frac{"),
          i(1, "numerator"),
          t("}{"),
          i(2, "denominator"),
          t("}"),
        }),

        -- Sum
        s("sum", {
          t("\\sum_{"),
          i(1, "i=1"),
          t("}^{"),
          i(2, "n"),
          t("} "),
          i(3, "a_i"),
        }),

        -- Limit
        s("lim", {
          t("\\lim_{"),
          i(1, "x \\to \\infty"),
          t("} "),
          i(2, "f(x)"),
        }),

        -- Matrix
        s("matrix", {
          t({ "\\begin{pmatrix}", "" }),
          t("  "),
          i(1, "a"),
          t(" & "),
          i(2, "b"),
          t({ " \\\\", "" }),
          t("  "),
          i(3, "c"),
          t(" & "),
          i(4, "d"),
          t({ "", "\\end{pmatrix}" }),
        }),

        -- Chemical equation with mhchem
        s("chem", {
          t("\\ce{"),
          i(1, "H2O"),
          t("}"),
        }),

        -- Chemical reaction
        s("rxn", {
          t("\\ce{"),
          i(1, "A"),
          t(" + "),
          i(2, "B"),
          t(" -> "),
          i(3, "C"),
          t("}"),
        }),

        -- Aligned equations
        s("align", {
          t({ "$$", "\\begin{aligned}", "" }),
          i(1, "equation1"),
          t({ " \\\\", "" }),
          i(2, "equation2"),
          t({ "", "\\end{aligned}", "$$" }),
        }),

        -- Cases (piecewise functions)
        s("cases", {
          t({ "$$", "f(x) = \\begin{cases}", "" }),
          i(1, "expr1"),
          t(" & \\text{if } "),
          i(2, "condition1"),
          t({ " \\\\", "" }),
          i(3, "expr2"),
          t(" & \\text{if } "),
          i(4, "condition2"),
          t({ "", "\\end{cases}", "$$" }),
        }),
      })

      -- Enable tab to expand snippets
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          return "<Tab>"
        end
      end, { expr = true, silent = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        else
          return "<S-Tab>"
        end
      end, { expr = true, silent = true })
    end,
  },
}
