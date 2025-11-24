local M = {}
local mini_session = require("mini.sessions")

M.setup = function()
	_G.my_recent_files = _G.my_recent_files or {}

	mini_session.setup({
		file = ".vim-session",
		hooks = {
			post = {
				write = function()
					if
						_G.my_recent_files == nil
						or vim.tbl_count(_G.my_recent_files) == 0
					then
						return
					end

					local cwd = vim.uv.cwd() or error()
					local session_path = vim.fs.relpath(
						cwd,
						mini_session.get_latest()
					) or error()

					local lines = {}
					table.insert(lines, "lua << EOF")
					table.insert(lines, "_G.my_recent_files = {")
					vim.iter(_G.my_recent_files):each(function(path)
						if vim.startswith(path, cwd) then
							table.insert(lines, "\t'" .. path .. "',")
						end
					end)
					table.insert(lines, "}")
					table.insert(lines, "EOF")
					vim.fn.writefile(lines, session_path, "a")
				end,
			},
		},
	})

	vim.api.nvim_create_user_command("SessionSave", function()
		mini_session.write(mini_session.config.file)
		mini_session.read(mini_session.config.file)
	end, { desc = "Save session" })

	vim.api.nvim_create_user_command("SessionRestore", function()
		mini_session.read()
	end, { desc = "Restore session" })

	vim.api.nvim_create_user_command("SessionSelect", function()
		mini_session.select()
	end, { desc = "Select session" })

	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			local detected_sessions = vim.tbl_values(mini_session.detected)
			local has_local_session = vim.iter(detected_sessions)
				:any(function(v)
					return v.type == "local"
				end)

			local started_with_file_argument = vim.iter(vim.v.argv)
				:any(function(arg)
					local stat = vim.uv.fs_stat(arg)
					return stat ~= nil and stat.type == "file"
				end)

			if has_local_session and not started_with_file_argument then
				mini_session.read()
			end
		end,
		nested = true,
	})

	vim.api.nvim_create_autocmd("BufWinEnter", {
		callback = function(args)
			if _G.my_recent_files == nil then
				return
			end

			local recent_files = _G.my_recent_files
			local file_path = vim.api.nvim_buf_get_name(args.buf)
			if file_path == nil or vim.fn.filereadable(file_path) == 0 then
				_G.my_recent_files = recent_files
				return
			end

			local entry_to_remove_index = nil
			for k, v in ipairs(recent_files) do
				if v == file_path then
					entry_to_remove_index = k
					break
				end
			end
			if entry_to_remove_index ~= nil then
				table.remove(recent_files, entry_to_remove_index)
			end

			table.insert(recent_files, 0, file_path)
			_G.my_recent_files = vim.tbl_values(recent_files)
		end,
	})
end

return M
