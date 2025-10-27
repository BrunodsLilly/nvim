return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,  -- Load immediately
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "oil",
          text = "File Explorer",
          text_align = "center",
        },
      },
    },
  },
  keys = {
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick Buffer to Close" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Buffers to Left" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close Buffers to Right" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Other Buffers" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
}
