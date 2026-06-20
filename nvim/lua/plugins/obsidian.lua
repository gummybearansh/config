return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,

		-- ⬇️ FIX 1: Load immediately when opening Markdown files
		event = { "BufReadPre *.md", "BufNewFile *.md" },

		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		-- Keep your commands and keys (they are fine)
		cmd = { "ObsidianNew", "ObsidianToday", "ObsidianSearch", "ObsidianQuickSwitch" },

		keys = {
			{
				"<leader>ng",
				function()
					-- This uses Telescope to search INSIDE files
					-- We force the 'cwd' (current directory) to your Vault
					require("telescope.builtin").live_grep({
						cwd = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain"),
						prompt_title = "Grep Vault Content",
					})
				end,
				desc = "Note: Grep Content",
			},
			{
				"<leader>nm",
				function()
					require("utils.refile").refile_note()
				end,
				desc = "Auto-Refile Note based on Tags",
			},
			-- {
			-- 	"<leader>nv",
			-- 	function()
			-- 		vim.cmd("cd " .. vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/")
			-- 		vim.cmd("Neotree toggle")
			-- 	end,
			-- 	desc = "Note: Open Vault",
			-- },
			{
				"<leader>nn",
				function()
					vim.ui.input({ prompt = "New Note Title: " }, function(input)
						if input and input ~= "" then
							vim.cmd("ObsidianNew " .. input)
						end
					end)
				end,
				desc = "Note: New",
			},
			{ "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Note: Search" },
			{ "<leader>nd", "<cmd>ObsidianToday<cr>", desc = "Note: Daily" },
			{ "<leader>nt", "<cmd>ObsidianTemplate<cr>", desc = "Note: Insert Template" },
			{ "<leader>nl", "<cmd>ObsidianLink<cr>", desc = "Note: Link Selection" },
			{ "<leader>nb", "<cmd>ObsidianBacklinks<cr>", desc = "Note: Show Backlinks" },
		},

		config = function()
			require("obsidian").setup({

				-- 1. FIX COMPLETION
				completion = {
					nvim_cmp = true,
					min_chars = 2,
				},

				workspaces = {
					{
						name = "SecondBrain",
						path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain"),
					},
				},

				-- 2. FIX TEMPLATES & ADD CUSTOM VARIABLES
				templates = {
					folder = "templates",
					date_format = "%Y-%m-%d", -- This ensures the tag is #2026-02-03
					time_format = "%A", -- This keeps {{time}} as "Tuesday"
				},

				-- 3. FIX NOTE ID (Your Clean Name Logic)
				note_id_func = function(title)
					if title == nil or title == "" then
						return tostring(os.date("%d-%m-%Y-%H%M"))
					end
					return title:gsub(" ", "_"):gsub("[^A-Za-z0-9-_]", ""):lower()
				end,

				-- 4. FIX DAILY NOTES (Point to a real file!)
				daily_notes = {
					folder = "dailies",
					date_format = "%d-%m-%Y",
					-- ⚠️ This file MUST exist in your templates folder
					template = "Daily.md",
				},

				-- 5. PREVENT DUPLICATES (No Auto-Frontmatter)
				disable_frontmatter = false,

				mappings = {
					["gf"] = {
						action = function()
							return require("obsidian").util.gf_passthrough()
						end,
						opts = { noremap = false, expr = true, buffer = true },
					},
					["<leader>ch"] = {
						action = function()
							return require("obsidian").util.toggle_checkbox()
						end,
						opts = { buffer = true },
					},
				},

				ui = { enable = false },
			})
		end,
	},
}
