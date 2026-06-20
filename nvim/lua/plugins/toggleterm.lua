return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<C-\>]],
			direction = "float",
			shade_terminals = true,
			float_opts = {
				border = "curved",
			},
		})

		-- CUSTOM: Kill current terminal buffer
		vim.keymap.set("n", "<leader>tk", ":bd!<CR>", { noremap = true, silent = true, desc = "Kill terminal buffer" })

		-- Table to store terminals so we don't spawn infinite duplicates
		local dir_terminals = {}

		-- ==========================================
		-- Open ToggleTerm in Current Directory
		-- ==========================================
		vim.keymap.set("n", "<leader>ut", function()
			local target_dir = vim.fn.getcwd()

			if vim.bo.filetype == "oil" then
				local ok, oil = pcall(require, "oil")
				if ok then
					local oil_dir = oil.get_current_dir()
					if oil_dir then
						target_dir = oil_dir
					end
				end
			else
				local file_dir = vim.fn.expand("%:p:h")
				if vim.fn.isdirectory(file_dir) == 1 then
					target_dir = file_dir
				end
			end

			if not dir_terminals[target_dir] then
				local Terminal = require("toggleterm.terminal").Terminal
				dir_terminals[target_dir] = Terminal:new({ 
					dir = target_dir, 
					direction = "float" 
				})
			end

			dir_terminals[target_dir]:toggle()
		end, { desc = "Toggle Terminal in Current Dir" })

		-- ==========================================
		-- NEW: View/Select Open Terminals
		-- ==========================================
		vim.keymap.set("n", "<leader>tv", function()
			local dirs = {}
			for dir, _ in pairs(dir_terminals) do
				table.insert(dirs, dir)
			end

			if #dirs == 0 then
				vim.notify("No active directory terminals.", vim.log.levels.INFO)
				return
			end

			-- Use Neovim's built-in selection menu
			vim.ui.select(dirs, { prompt = "Select Terminal to Open:" }, function(choice)
				if choice and dir_terminals[choice] then
					dir_terminals[choice]:toggle()
				end
			end)
		end, { desc = "View Open Dir Terminals" })

		-- ==========================================
		-- NEW: Kill ALL Directory Terminals
		-- ==========================================
		vim.keymap.set("n", "<leader>tK", function()
			local count = 0
			for dir, term in pairs(dir_terminals) do
				term:shutdown()
				count = count + 1
			end
			-- Reset the tracking table
			dir_terminals = {}
			vim.notify("Killed " .. count .. " directory terminals.", vim.log.levels.INFO)
		end, { desc = "Kill ALL Dir Terminals" })

	end,
}
