return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- REQUIRED: Add the current file to Harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Add" })

    -- REQUIRED: Toggle the Harpoon UI
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

    -- THE SHORTCUTS: Instantly jump to files 1 through 4
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

    -- Optional: Cycle through your harpoon list
    vim.keymap.set("n", "<leader>[", function() harpoon:list():prev() end, { desc = "Harpoon Prev" })
    vim.keymap.set("n", "<leader>]", function() harpoon:list():next() end, { desc = "Harpoon Next" })
  end
}
