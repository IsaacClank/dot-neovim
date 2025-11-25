--- # recent_files
---
--- This plugin add a custom `_G.my_recent_files` variables,
--- which is a list of the most recent files. The list is
--- updated upon the `BufWinEnter` event and saved to the
--- session file.
---
--- ## Setup
---
--- ```lua
--- local session = require('mini.session')
--- local session_recent_files = require('recent_files')
---
--- session.setup({
---   hooks = {
---     post = {
---       write = function()
---         session_recent_files.post_write()
---       end
---     }
---   }
--- })
--- session_recent_files.setup()
--- ```
---

local mini_session = require("mini.sessions")
local items = require("my.lib.items")

local M = {}

local setup_recency_update = function()
	vim.api.nvim_create_autocmd("BufWinEnter", {
		callback = function(args)
			local recent_files = _G.my_recent_files
			if recent_files == nil then
				return
			end

			recent_files = vim.tbl_filter(function(f)
				return vim.fn.filereadable(f) == 1
			end, recent_files)

			local buf_file = vim.api.nvim_buf_get_name(args.buf)
			if buf_file == nil or vim.fn.filereadable(buf_file) == 0 then
				_G.my_recent_files = recent_files
				return
			end

			recent_files = items.remove(recent_files, function(f)
				return f == buf_file
			end)
			recent_files = items.concat({ buf_file }, recent_files)
			_G.my_recent_files = vim.tbl_values(recent_files)
		end,
	})
end

M.setup = function()
	_G.my_recent_files = _G.my_recent_files or {}
	setup_recency_update()
end

---
--- ## Hooks for mini.sessions
---

M.post_write = function()
	if _G.my_recent_files == nil or vim.tbl_count(_G.my_recent_files) == 0 then
		return
	end

	local cwd = vim.uv.cwd() or error()
	local session_path = vim.fs.relpath(cwd, mini_session.get_latest())
		or error()

	local lines = {}
	table.insert(lines, "lua << EOF")
	table.insert(lines, "_G.my_recent_files = {")
	vim.iter(_G.my_recent_files):each(function(path)
		if vim.startswith(path, cwd) and vim.fn.filereadable(path) == 1 then
			table.insert(lines, "\t'" .. path .. "',")
		end
	end)
	table.insert(lines, "}")
	table.insert(lines, "EOF")
	vim.fn.writefile(lines, session_path, "a")
end

return M
