--- # auto_restore
---
--- This plugin add an autocmd to restore the detected
--- local session if neovim was `neovim` was not invoked
--- with a file argument.
---
--- ## Setup
---
--- ```lua
--- local session = require('mini.session')
--- local session_auto_restore = require('auto_restore')
---
--- session.setup()
--- session_auto_restore.setup()
--- ```
---

local mini_session = require("mini.sessions")

local M = {}

local setup_auto_restore = function()
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			local detected_sessions = vim.tbl_values(mini_session.detected)
			local has_local_session = vim.iter(detected_sessions)
				:any(function(v)
					return v.type == "local"
				end)
			local started_with_file_arg = vim.iter(vim.v.argv):any(function(arg)
				local stat = vim.uv.fs_stat(arg)
				return stat ~= nil and stat.type == "file"
			end)

			if has_local_session and not started_with_file_arg then
				mini_session.read()
				return
			end

			if vim.tbl_count(detected_sessions) > 0 then
				mini_session.select()
			end
		end,
		nested = true,
	})
end

M.setup = function()
	setup_auto_restore()
end

return M
