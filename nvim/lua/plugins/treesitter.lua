return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "master", -- Tailoring back to master to keep compatibility stable
		lazy = false,
		priority = 1000,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"cpp",
					"python",
					"lua",
					"vim",
					"vimdoc",
					"javascript",
					"typescript",
					"html",
					"css",
				},
				sync_install = true,
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
