-- In lua/utils/open.lua (or where you keep keymaps)

-- 1. Mac-specific URL opener
vim.keymap.set("n", "gx", function()
	-- Get the word under the cursor (including punctuation typically used in URLs)
	local url = vim.fn.expand("<cfile>")

	-- macOS command to open links
	local cmd = "open"

	-- Check if it looks like a URL (basic check)
	if url:match("http") or url:match("www") then
		-- Execute the command nicely
		local Job = require("plenary.job")
		Job:new({
			command = cmd,
			args = { url },
			on_exit = function(j, return_val)
				if return_val ~= 0 then
					print("Failed to open URL: " .. url)
				end
			end,
		}):start()
		print("Opening: " .. url)
	else
		print("Not a valid URL: " .. url)
	end
end, { desc = "Open URL under cursor" })
