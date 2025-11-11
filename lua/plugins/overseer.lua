return {
  "stevearc/overseer.nvim",
  opts = {
    templates = { "builtin", "make" },
    task_list = {
      direction = "bottom",
      min_height = 10,
      max_height = 20,
    },
  },
  keys = {
    { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
    { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
    { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
  },
}
