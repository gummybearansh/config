return {
	"mbbill/undotree",
	config = function()
		-- Map Option-u to toggle UndoTree
		vim.keymap.set("n", "<D-u>", vim.cmd.UndotreeToggle)

		-- Optional: Focus the undo tree when toggled
		vim.g.undotree_SetFocusWhenToggle = 1
	end,
}
