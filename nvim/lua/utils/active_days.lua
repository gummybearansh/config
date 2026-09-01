local M = {}

local function vault()
	return vim.fn.fnamemodify(
		vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain"),
		":p"
	):gsub("/$", "")
end

local function index_path()
	return vault() .. "/active_days.md"
end

local SECTION_RE = "^## (%d%d%d%d%-%d%d%-%d%d) %(([^)]+)%)"

local function parse_bullet(line)
	if not line:match("^%- ") then
		return nil, nil
	end
	local inner = line:match("%[%[(.-)%]%]")
	if not inner then
		return nil, nil
	end
	local link, label = inner:match("^([^|]+)|(.+)$")
	if link then
		return link, label
	end
	return inner, inner
end

local function resolve_link(link)
	local base = vault()
	local path = base .. "/" .. link .. ".md"
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	path = base .. "/" .. link
	if vim.fn.filereadable(path) == 1 then
		return path
	end
	return nil
end

--- Fast parse — links only, no filesystem calls.
function M.parse_index()
	local index = index_path()
	if vim.fn.filereadable(index) == 0 then
		return {}
	end

	local lines = vim.fn.readfile(index)
	local days = {}
	local current = nil

	for _, line in ipairs(lines) do
		local date, wd = line:match(SECTION_RE)
		if date then
			current = { date = date, weekday = wd, notes = {} }
			table.insert(days, current)
		elseif current then
			local link, label = parse_bullet(line)
			if link then
				table.insert(current.notes, { link = link, label = label or link })
			end
		end
	end

	return days
end

local function weekday(iso)
	local y, m, d = iso:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
	if not y then
		return ""
	end
	return os.date("%A", os.time({ year = tonumber(y), month = tonumber(m), day = tonumber(d) }))
end

local function note_date_from_buf(buf)
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local content = table.concat(lines, "\n")
	local date = content:match("%*%*Created:%*%*%s+(%d%d%d%d%-%d%d%-%d%d)")
	if date then
		return date
	end
	date = content:match("#(%d%d%d%d%-%d%d%-%d%d)[^%d]")
	if date then
		return date
	end
	local path = vim.api.nvim_buf_get_name(buf)
	local d, m, y = path:match("/(%d%d)%-(%d%d)%-(%d%d%d%d)%.md$")
	if d then
		return string.format("%s-%s-%s", y, m, d)
	end
	return os.date("%Y-%m-%d")
end

local function note_title_from_buf(buf)
	for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		local title = line:match("^#%s+(.+)$")
		if title then
			return title
		end
	end
	return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t:r")
end

local function vault_rel_path(abs_path)
	local rel = abs_path:gsub("^" .. vim.pesc(vault()) .. "/?", "")
	return rel:gsub("%.md$", "")
end

local function make_bullet(rel, title)
	if rel:match("^dailies/") then
		return string.format("- 📓 [[%s|Daily — %s]]", rel, vim.fn.fnamemodify(rel, ":t"))
	end
	return string.format("- [[%s|%s]]", rel, title)
end

M._writing_index = false

function M.register_note(buf)
	buf = buf or 0
	if M._writing_index then
		return
	end

	local path = vim.api.nvim_buf_get_name(buf)
	local index = index_path()
	if path == "" or path == index then
		return
	end
	if not path:find(vault(), 1, true) or path:find("/templates/", 1, true) then
		return
	end

	local rel = vault_rel_path(path)
	local date = note_date_from_buf(buf)
	local bullet = make_bullet(rel, note_title_from_buf(buf))
	local lines = vim.fn.readfile(index)

	-- already listed?
	local in_section = false
	for _, line in ipairs(lines) do
		if line:match("^## " .. date .. " ") then
			in_section = true
		elseif line:match("^## %d%d%d%d%-") then
			in_section = false
		elseif in_section and line:find("%[%[" .. vim.pesc(rel), 1, true) then
			return
		end
	end

	-- append to existing section or create new one
	local found = false
	local new_lines = {}
	local in_target = false
	for _, line in ipairs(lines) do
		if line:match("^## " .. date .. " ") then
			in_target = true
			found = true
			table.insert(new_lines, line)
		elseif in_target and line:match("^## %d%d%d%d%-") then
			table.insert(new_lines, bullet)
			in_target = false
			table.insert(new_lines, line)
		else
			table.insert(new_lines, line)
		end
	end
	if in_target then
		table.insert(new_lines, bullet)
	elseif not found then
		local insert_at = #new_lines + 1
		for i, line in ipairs(new_lines) do
			local existing = line:match("^## (%d%d%d%d%-%d%d%-%d%d)")
			if existing and existing < date then
				insert_at = i
				break
			end
		end
		local section = {
			string.format("## %s (%s)", date, weekday(date)),
			bullet,
			"",
		}
		local merged = {}
		for i = 1, insert_at - 1 do
			table.insert(merged, new_lines[i])
		end
		for _, l in ipairs(section) do
			table.insert(merged, l)
		end
		for i = insert_at, #new_lines do
			table.insert(merged, new_lines[i])
		end
		new_lines = merged
	end

	-- update total day count
	local count = 0
	for _, line in ipairs(new_lines) do
		if line:match("^## %d%d%d%d%-%d%d%-%d%d %(") then
			count = count + 1
		end
	end
	for i, line in ipairs(new_lines) do
		if line:match("^%*%*Total active days:%*%*") then
			new_lines[i] = string.format("**Total active days:** %d", count)
			break
		end
	end

	M._writing_index = true
	vim.fn.writefile(new_lines, index)
	M._writing_index = false
end

--- Pick a day, then load its notes into quickfix.
function M.pick_day_and_revise()
	local days = M.parse_index()
	if #days == 0 then
		vim.notify("No days in active_days.md", vim.log.levels.WARN)
		return
	end

	local items = {}
	for _, day in ipairs(days) do
		table.insert(items, {
			date = day.date,
			weekday = day.weekday,
			notes = day.notes,
			display = string.format("%s (%s)  ·  %d notes", day.date, day.weekday, #day.notes),
		})
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Pick a day to revise",
			finder = finders.new_table({
				results = items,
				entry_maker = function(item)
					return {
						value = item,
						display = item.display,
						ordinal = item.date,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			default_selection = 1,
			attach_mappings = function(_, _)
				actions.select_default:replace(function(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.schedule(function()
						if selection and selection.value then
							M.load_day_quickfix(selection.value)
						end
					end)
				end)
				return true
			end,
		})
		:find()
end

function M.load_day_quickfix(day)
	if not day or not day.notes then
		vim.notify("Revision: invalid day selection", vim.log.levels.ERROR)
		return
	end

	local qf = {}
	for _, note in ipairs(day.notes) do
		local path = resolve_link(note.link)
		if path then
			table.insert(qf, {
				filename = path,
				lnum = 1,
				col = 1,
				text = note.label,
			})
		end
	end

	if #qf == 0 then
		vim.notify("No files found for " .. day.date, vim.log.levels.WARN)
		return
	end

	vim.fn.setqflist(qf, "r")
	vim.cmd("copen")
	vim.cmd("cfirst")
	vim.notify(string.format("Revising %s — %d notes · ]q next · [q prev", day.date, #qf))
end

function M.open_index()
	local index = index_path()
	if vim.fn.filereadable(index) == 0 then
		vim.notify("active_days.md not found", vim.log.levels.ERROR)
		return
	end
	vim.cmd("edit " .. vim.fn.fnameescape(index))
end

function M.setup_autocmd()
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("ActiveDays", { clear = true }),
		pattern = "*.md",
		callback = function(args)
			local path = vim.api.nvim_buf_get_name(args.buf)
			if path:find(vault(), 1, true) and path ~= index_path() and not path:find("/templates/", 1, true) then
				vim.schedule(function()
					M.register_note(args.buf)
				end)
			end
		end,
	})
end

return M
