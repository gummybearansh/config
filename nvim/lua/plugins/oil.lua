return {
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" }, -- Icons make it look nice
    config = function()
        require("oil").setup({
          -- Use Oil as your default file explorer (replacing Netrw)
          default_file_explorer = true,
          -- Delete files to trash instead of permanently (safer)
          delete_to_trash = true,
          -- Skip the confirmation popup for simple file operations
          skip_confirm_for_simple_edits = true,
          -- view options
          view_options = {
            show_hidden = true, -- Show .dotfiles
            natural_order = true,
          },
        })

        -- MAP: Open parent directory with "-"
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })
      end,
    },
}
