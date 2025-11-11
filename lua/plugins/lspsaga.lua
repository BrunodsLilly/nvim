return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  opts = {
    lightbulb = {
      enable = false,  -- Disable lightbulb if annoying
    },
  },
  keys = {
    { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
    { "gr", "<cmd>Lspsaga finder<cr>", desc = "Find References" },
    { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action" },
    { "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
    { "<leader>pd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
    { "<leader>gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definition" },
  },
}
