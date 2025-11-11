return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
    { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
  },
}
