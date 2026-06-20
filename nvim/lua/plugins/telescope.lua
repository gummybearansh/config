return {
    "nvim-telescope/telescope.nvim",
    branch = "master", -- Use a specific tag for stability
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        
        -- Keymaps
        vim.keymap.set("n", "<C-p>", builtin.find_files, {}) -- Find files
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {}) -- Find text (grep)
        vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {}) -- Find recent files

        vim.keymap.set("n", "<leader>fx", builtin.diagnostics, {}) -- 'fx' for 'Fix'
    end,
}
