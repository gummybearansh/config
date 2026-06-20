return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
  cmd = Neotree,
	-- ⬇️ UPDATED KEYBINDINGS ⬇️
	keys = {
		-- Ctrl + b toggles it (VS Code style)
		{ "<C-b>", ":Neotree toggle<CR>", desc = "Toggle File Explorer" },
		-- Leader + e just focuses it (so you can navigate files)
		{ "<leader>e", ":Neotree focus<CR>", desc = "Focus File Explorer" },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				width = 35,
				mappings = {
					-- This makes sure Space doesn't act weird inside the tree
					["<Space>"] = "none",
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				use_libuv_file_watcher = true,
			},
		})
	end,
}
