return {
  "crnvl96/lazydocker.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("lazydocker").setup({})
  end,
  keys = {
    { "<leader>gD", function()
      -- Set environment to use Podman before launching LazyDocker
      -- LazyDocker will use these environment variables
      vim.env.DOCKER_BUILDKIT = "0"

      -- Create a temporary wrapper script for docker -> podman
      local wrapper_path = vim.fn.tempname()
      local wrapper_content = [[#!/bin/sh
exec /opt/homebrew/bin/podman "$@"
]]
      vim.fn.writefile(vim.fn.split(wrapper_content, '\n'), wrapper_path)
      vim.fn.system("chmod +x " .. wrapper_path)

      -- Create temp bin directory and symlink
      local temp_bin = vim.fn.tempname() .. "_bin"
      vim.fn.mkdir(temp_bin, "p")
      vim.fn.system("ln -sf " .. wrapper_path .. " " .. temp_bin .. "/docker")

      -- Prepend to PATH
      local original_path = vim.env.PATH
      vim.env.PATH = temp_bin .. ":" .. original_path

      -- Launch lazydocker
      require("lazydocker").toggle()

      -- Clean up after lazydocker closes
      vim.api.nvim_create_autocmd("BufWipeout", {
        pattern = "*lazydocker*",
        once = true,
        callback = function()
          vim.defer_fn(function()
            vim.env.PATH = original_path
            vim.fn.delete(temp_bin, "rf")
            vim.fn.delete(wrapper_path)
          end, 100)
        end,
      })
    end, desc = "LazyDocker (Podman)" },
  },
}
