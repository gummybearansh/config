local M = {}

-- ⚠️ CONFIG: Check this path matches your Vault root exactly
local vault_root = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain")

M.refile_note = function()
	local current_file = vim.fn.expand("%:p")
	local file_name = vim.fn.expand("%:t")

	-- Get buffer content to scan for tags
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(lines, "\n")

	local target_dir = ""

	-- 1. Check for Leetcode
	if content:match("#leetcode") then
		target_dir = vault_root .. "/leetcode"

	-- 2. Check for Dev
	elseif content:match("#dev") then
		target_dir = vault_root .. "/dev"

	-- 3. Check for TUF (NEW ADDITION)
	elseif content:match("#TUF") then
		target_dir = vault_root .. "/TUF"

	-- 4. Check for Codeforces (CF) + Rating
	elseif content:match("#CF") then
		-- Find the rating (looks for #1000, #1200, etc)
		local rating = content:match("#(%d%d%d%d+)")
		if rating then
			target_dir = vault_root .. "/cf/" .. rating
		else
			target_dir = vault_root .. "/cf/unrated"
		end
	end

	-- If no tag matched, stop
	if target_dir == "" then
		print("⚠️ No matching tags (#leetcode, #dev, #TUF, #CF) found.")
		return
	end

	-- Create directory if it doesn't exist
	if vim.fn.isdirectory(target_dir) == 0 then
		vim.fn.mkdir(target_dir, "p")
	end

	-- Move the file
	local new_path = target_dir .. "/" .. file_name

	-- Rename file on disk
	local success, err = os.rename(current_file, new_path)
	if not success then
		print("Error moving file: " .. err)
		return
	end

	-- Re-open the file in the new location
	vim.cmd("edit " .. new_path)
	print("✅ Refiled to: " .. target_dir)
end

return M
