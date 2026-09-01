vim.o.guifont = "JetBrainsMonoNL Nerd Font:h17"

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number relativenumber")

-- vim.cmd("set nohlsearch") -- for stopping highlighting
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {})

-- Force all terminal buffers to close immediately when quitting
vim.api.nvim_create_autocmd("ExitPre", {
	group = vim.api.nvim_create_augroup("Exit", { clear = true }),
	callback = function()
		vim.cmd("set nobuflisted")
		-- This essentially tells Neovim: "Forget these buffers exist."
		-- When Neovim forgets them, it kills the jobs attached to them automatically.
	end,
})
-- The "VS Code Style" Runner + Instant Terminal Focus
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("w") -- Save the file

	-- 1. Get the details
	local dir = vim.fn.expand("%:p:h") -- /Users/ansh/Coding Work
	local fileName = vim.fn.expand("%:t") -- 1.cpp
	local fileBase = vim.fn.expand("%:t:r") -- 1

	-- 2. Build the Clean Command (Double quotes inside for safety)
	-- Result: cd "/Users/ansh/Coding Work" && g++ -std=c++17 "1.cpp" -o "1" && "./1"
	local cmd = string.format('cd "%s" && g++ -std=c++17 "%s" -o "%s" && "./%s"', dir, fileName, fileBase, fileBase)

	-- 3. Execute with TermExec (Wrapped in SINGLE quotes to handle the doubles inside)
	vim.cmd("TermExec cmd='" .. cmd .. "' go_back=0")

	-- 4. Enter Insert Mode instantly
	vim.cmd("startinsert!")
end)

-- SYSTEM CLIPBOARD
-- <leader>y copies to system clipboard (so you can paste in browser)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]]) -- yank whole line to clipboard

-- WINDOW NAVIGATION
-- Use Ctrl + h/j/k/l to jump between splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.opt.scrolloff = 10

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Disable modelines to prevent errors when opening files with "vim:" text
vim.opt.modeline = false

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
	callback = function()
		if vim.bo.modified then
			vim.schedule(function()
				-- "noautocmd" = Do not trigger the formatter
				-- "silent!"   = Do not show "written" messages
				vim.cmd("noautocmd silent! write")
			end)
		end
	end,
})

-- 1. Enable wrapping
vim.opt.wrap = true

-- 2. "Solid" wrapping: Don't break in the middle of words
vim.opt.linebreak = true

-- 3. The "Pro" move: Maintain indentation on wrapped lines
--    (So wrapped code lines up with the code above it, not the left edge)
vim.opt.breakindent = true

vim.opt.ignorecase = true -- Ignore case by default
vim.opt.smartcase = true -- ...unless you type a capital letter

-- Use Treesitter for folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Start with all folds OPEN (so you don't open a file and see nothing)
vim.opt.foldlevel = 99


-- neovide settings
if vim.g.neovide then
	vim.g.neovide_input_use_logo = 1
	vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
	-- vim.o.guifont = "0xProto Nerd Font Mono:h16"
	vim.keymap.set("c", "<D-v>", "<C-r>+", { noremap = true, silent = true })
	vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
end


-- 3. Neovide Cursor Animation Settings
--
-- -- A. The "Smear" Length (Trail duration)
-- -- Default is roughly 0.13. Higher = Longer trail.
vim.g.neovide_cursor_trail_size = 0.4
--
-- -- B. Animation Length (Glide speed)
-- -- How long it takes for the block to slide from A to B.
-- -- Lower = Snappier (0.03). Higher = Gooeier (0.1).
vim.g.neovide_cursor_animation_length = 0.08
--
-- -- C. Particle Effects (The "Sparkles")
-- -- If you want a clean trail (like smear-cursor), turn this OFF.
-- -- If you want the particles (dust), keep it ON.
-- vim.g.neovide_cursor_vfx_mode = "" -- Set to "railgun", "torpedo", or "pixie" for effects. Set to "" for just the smooth block.

-- 1. Initialize the scale factor
vim.g.neovide_scale_factor = 1.0
--
-- -- 2. Define the resizing function
local change_scale_factor = function(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
--
--   -- 3. Map the keys explicitly
-- <D-=> is Cmd + Equal (often used for Zoom In)
-- <D--> is Cmd + Minus (Zoom Out)
vim.keymap.set("n", "<D-=>", function()
	change_scale_factor(1.1)
end)
vim.keymap.set("n", "<D-->", function()
	change_scale_factor(1 / 1.1)
end)

--
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FormatOptions", { clear = true }),
	pattern = "*",
	desc = "Prevent comment continuation",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- ==========================================
-- UTILITY NAMESPACE (<leader>u...)
-- ==========================================

-- 1. Toggle Spell Check (<leader>us)
-- 's' stands for Spell. This is safe because it's behind 'u'.
vim.keymap.set("n", "<leader>us", function()
	vim.opt.spell = not vim.opt.spell:get()
	if vim.opt.spell:get() then
		print("📝 Spell Check: ON")
	else
		print("📝 Spell Check: OFF")
	end
end, { desc = "Toggle Spell Check" })

-- 2. Toggle Autocomplete (<leader>ua)
-- 'a' stands for Autocomplete.
vim.keymap.set("n", "<leader>ua", function()
	local cmp = require("cmp")
	local current = cmp.get_config().completion.autocomplete

	if current and #current > 0 then
		-- Turn it OFF
		cmp.setup({ completion = { autocomplete = false } })
		print("🤖 Autocomplete: OFF")
	else
		-- Turn it ON (Default behavior)
		cmp.setup({ completion = { autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged } } })
		print("🤖 Autocomplete: ON")
	end
end, { desc = "Toggle Autocomplete" })

-- Force gx to use the system 'open' command (macOS specific)
vim.keymap.set("n", "gx", [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], { silent = true })


-- Ensure persistent undo is on (So you still have history if you crash)
vim.opt.undofile = true

-- // mapping to cycle files
vim.keymap.set("n", "<leader>ww", "<C-w>w", { desc = "Cycle windows" })

-- Cycle through "Today's Notes" (Quickfix List)
-- do <ns>{{todays_date}}
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Note (Quickfix)" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Prev Note (Quickfix)" })

-- -- Show filename at the top of every split
-- -- %= (Align right)
-- -- %m (Show [+] if modified)
-- -- %f (Show filename relative to project root)
-- vim.opt.winbar = "%=%m %f"

-- In Terminal mode, 'Esc Esc' runs the command to exit to Normal Mode
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- move selected lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep visual selection after indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.opt.incsearch = true

-- Automatically reload files when they change on disk
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("AutoChecktime", { clear = true }),
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- completely disable swap files
vim.opt.swapfile = false


-- optional: save all undo files in one customized location
-- (keeps your project directories clean)
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"

vim.opt.guicursor = "n-v-c-i:block"

vim.opt.smoothscroll = true

-- removed the extra spacing between neovim and the tmux line
-- vim.opt.cmdheight = 0

