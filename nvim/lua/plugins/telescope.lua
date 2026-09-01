return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		-- Configure Telescope defaults
		telescope.setup({
			defaults = {
				-- Force find_files to show hidden files and ignore git constraints if desired
				file_ignore_patterns = { "node_modules", ".git/" },
			},
			pickers = {
				find_files = {
					-- This ensures hidden files (like init.lua in dotfiles) show up
					hidden = true,
				},
			},
      extensions = {
        fzf = {}
      }
		})

    require('telescope').load_extension('fzf')

		-- Keymaps
		vim.keymap.set("n", "<C-p>", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
		vim.keymap.set("n", "<leader>fx", builtin.diagnostics, {})
	end,
}
