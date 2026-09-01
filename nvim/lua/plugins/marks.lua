return {
	"chentoast/marks.nvim",
	event = "VeryLazy",
	opts = {
		-- Whether to map keybinds or not. Default true
		default_mappings = true,
		-- Which marks can conflict with another mark.
		-- One mark will overwrite the other.
		cyclic = true,
		-- Force the sign column to always show so it doesn't shift your text
		sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
		excluded_filetypes = { "NvimTree", "neo-tree", "telescope" },
	},
}
