return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    snippet_engine = "nvim",  -- Use Neovim's native snippet support
    enabled = true,
  },
  keys = {
    { "<leader>nf", function() require("neogen").generate() end, desc = "Generate Documentation" },
    { "<leader>nc", function() require("neogen").generate({ type = "class" }) end, desc = "Generate Class Doc" },
    { "<leader>nt", function() require("neogen").generate({ type = "type" }) end, desc = "Generate Type Doc" },
    { "<leader>nm", function() require("neogen").generate({ type = "file" }) end, desc = "Generate Module/File Doc" },
  },
}
