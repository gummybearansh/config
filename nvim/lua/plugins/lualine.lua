return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = "dracula",
				-- globalstatus = true, -- OPTIONAL: Makes one long bar across the bottom instead of one per split
			},
			sections = {
				lualine_c = {
					{
						"filename",
						-- 0: Just the filename
						-- 1: Relative path (src/components/Button.tsx) - BEST FOR YOU
						-- 2: Absolute path (/Users/name/...)
						path = 0,

						-- Shows a symbol if the file is modified/readonly
						symbols = { modified = " ●", readonly = " 🔒", unnamed = "[No Name]" },
					},
				},
			},
		})
	end,
}
