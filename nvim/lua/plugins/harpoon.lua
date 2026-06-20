return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      -- 1. ADD: Mark the current file (The "Harpoon" it)
      vim.keymap.set("n", "<leader>m", function() harpoon:list():add() end, { desc = "Harpoon: Add File" })

      -- 2. MENU: Show the list of marked files
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Menu" })

      -- 3. NAVIGATE: Jump to marked files (1, 2, 3, 4)
      vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
    end,
}
