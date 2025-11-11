-- Simple Makefile runner with Telescope integration
return {
  {
    "ptethng/telescope-makefile",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("make")
    end,
    keys = {
      { "<leader>fm", "<cmd>Telescope make<cr>", desc = "Run Makefile Target" },
    },
  },
}
