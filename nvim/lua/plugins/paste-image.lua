if vim.g.neovide then
      return {} -- Exit the file early, preventing the rest of the configuration from running
end
return {}
-- return {
--   {
--     "HakonHarnes/img-clip.nvim",
--     event = "VeryLazy",
--     opts = {
--       default = {
--         embed_image_as_base64 = false,
--         prompt_for_file_name = false,
--         drag_and_drop = {
--           insert_mode = true,
--         },
--         -- Optional: Use relative paths for Obsidian compatibility
--         use_absolute_path = false,
--         relative_to_current_file = true, 
--       },
--     },
--     keys = {
--       -- Bind <leader>p to paste image
--       { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste Image from Clipboard" },
--     },
--   },
-- }
