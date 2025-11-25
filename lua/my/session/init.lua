local mini_session = require("mini.sessions")
local mini_session_recent_files = require("my.session.plugin.recent_files")
local mini_session_auto_restore = require("my.session.plugin.auto_restore")

local M = {}
M.setup = function()
	mini_session.setup({
		file = ".vim-session",
		hooks = {
			post = {
				write = function()
					mini_session_recent_files.post_write()
				end,
			},
		},
	})
	mini_session_auto_restore.setup()
	mini_session_recent_files.setup()

	vim.api.nvim_create_user_command("SessionSave", function()
		mini_session.write(mini_session.config.file)
		mini_session.read(mini_session.config.file)
	end, { desc = "Save session", nargs = "?" })

	vim.api.nvim_create_user_command("SessionRestore", function()
		mini_session.read()
	end, { desc = "Restore session" })

	vim.api.nvim_create_user_command("SessionSelect", function()
		mini_session.select()
	end, { desc = "Select session" })
end
return M
