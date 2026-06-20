local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")

-- CHANGED: We now pass a settings table to disable 'rocks'
require("lazy").setup("plugins", {
	rocks = {
		enabled = false,
		hererocks = false,
	},
})

-- 1. Create the :Cp command
vim.api.nvim_create_user_command("Cp", function()
	vim.cmd("cd /Users/gummybearansh/Desktop/coding-work/CP")
	print("🏆 Entered CP Mode")
end, {})

-- 2. Create the :Tuf command
vim.api.nvim_create_user_command("Tuf", function()
	vim.cmd("cd /Users/gummybearansh/Desktop/coding-work/TUF\\ A2Z")
	print("💪 Entered TUF Mode")
end, {})

-- 3. Create the :Dev command
vim.api.nvim_create_user_command("Dev", function()
	vim.cmd("cd /Users/gummybearansh/Desktop/coding-work/Cohort\\ 3")
	print("💻 Entered Dev Mode")
end, {})

-- 4. Create the :Notes command
vim.api.nvim_create_user_command("Notes", function()
	-- We use vim.fn.expand because of the tricky spaces in iCloud paths
	local path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain")
	vim.cmd("cd " .. path)
	print("🧠 Entered Second Brain")
end, {})

vim.api.nvim_create_user_command("Conf", function()
	-- We use vim.fn.expand because of the tricky spaces in iCloud paths
	local path = vim.fn.expand("/Users/gummybearansh/.config/nvim")
	vim.cmd("cd " .. path)
	print("🧠 Entered nvim Config")
end, {})

-- Initialize the Molten kernel (do this first!)
vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten" })

-- Run the current "cell" (the code between # %% markers)
vim.keymap.set("n", "<leader>r", ":MoltenEvaluateOperator<CR>", { desc = "Run operator" })
vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { desc = "Re-eval cell" })

-- View output (if image is hidden or text is too long)
vim.keymap.set("n", "<leader>mo", ":noautocmd MoltenEnterOutput<CR>", { desc = "Open Output" })

-- Hide output
vim.keymap.set("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "Hide Output" })

-- Function to schedule a MacOS notification from a time string
local function schedule_alert()
	-- 1. Get the word under cursor
	local word = vim.fn.expand("<cWORD>")

	-- 2. Check if it matches @HH:MM format
	local time = word:match("@(%d%d:%d%d)")

	if not time then
		print("❌ Format must be @HH:MM")
		return
	end

	-- 3. Calculate seconds until that time
	local hour, min = time:match("(%d%d):(%d%d)")
	local target = os.time({
		year = os.date("%Y"),
		month = os.date("%m"),
		day = os.date("%d"),
		hour = hour,
		min = min,
		sec = 0,
	})
	local now = os.time()
	local delay = os.difftime(target, now)

	if delay < 0 then
		print("⚠️ Time has passed!")
		return
	end

	-- 4. THE UPGRADE:
	-- Use 'display alert' (modal popup) + 'say' (text-to-speech)
	-- This combination is much harder to ignore than a banner.
	local cmd = string.format(
		'sleep %d && osascript -e \'display alert "Neovim Reminder" message "%s" as critical\' & say "Reminder %s" &',
		delay,
		time,
		time
	)

	os.execute(cmd)
	print("✅ Priority Alarm set for " .. time)
end

-- Neovide failing
if vim.g.neovide then
	-- Let AeroSpace handle window placement and sizing
	vim.g.neovide_remember_window_size = false
	vim.g.neovide_remember_window_position = false
end

vim.opt.scrolloff = 10
