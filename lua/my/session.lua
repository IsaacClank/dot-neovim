local M = {}
local session = require("mini.sessions")

M.setup = function()
	require("mini.sessions").setup({
		file = ".vim-session",
	})

	vim.api.nvim_create_user_command("SessionSave", function()
		session.write(session.config.file)
	end, { desc = "Save session" })

	vim.api.nvim_create_user_command("SessionRestore", function()
		session.read()
	end, { desc = "Save session" })

	vim.api.nvim_create_user_command("SessionSelect", function()
		session.select()
	end, { desc = "Save session" })
end

return M
