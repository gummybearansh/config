return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" }, -- Dependent on your completion plugin
	config = function()
		require("nvim-autopairs").setup({})

		-- Optional: Connect to snippets so pressing <CR> works smoothly
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
