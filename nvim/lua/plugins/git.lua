return {
  -- 1. GitSigns: The "Gutter" (Green/Red bars on the left)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- 2. LazyGit: The best UI for committing/pushing
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      -- Press 'Space + gg' to open the floating git window
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
  },
}
