return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- The magic plugin that handles messy ASCII tables natively
		{
			"nhattVim/alpha-ascii.nvim",
			opts = {
				header = "random", -- Randomizes every startup
				use_default = false,
				-- Pointing to ~/.config/nvim/lua/ascii
				user_path = vim.fn.stdpath("config") .. "/lua/ascii",
			},
		},
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Maintain your Catppuccin Mauve integration
		vim.api.nvim_set_hl(0, "AlphaPurple", { fg = "#cba6f7" })
		dashboard.section.header.opts.hl = "AlphaPurple"

		-- Your crisp menu, plus a button to cycle the art
		dashboard.section.buttons.val = {
			dashboard.button("f", "󰈢  Find file", ":Telescope find_files <CR>"),
			dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("g", "󰊢  Find text", ":Telescope live_grep <CR>"),
			dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
			dashboard.button("h", "  Next Art", ":AlphaAsciiNext<CR>"), -- Mapped to 'h'
			dashboard.button("q", "󰅙  Quit Neovim", ":qa<CR>"),
		}

		dashboard.section.footer.val = { "" }

		dashboard.config.layout = {
			{ type = "padding", val = 4 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		alpha.setup(dashboard.config)

		-- Press 'h' inside the dashboard to instantly swap to the next ASCII art
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function(ev)
				vim.keymap.set("n", "h", function()
					vim.cmd("AlphaAsciiNext")
				end, { buffer = ev.buf, desc = "Next Alpha ASCII" })
			end,
		})


	end,
}
