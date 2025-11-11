return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
  },
}
