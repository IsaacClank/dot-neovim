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
	end, { desc = "Restore session" })

	vim.api.nvim_create_user_command("SessionSelect", function()
		session.select()
	end, { desc = "Select session" })

	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			local started_with_file_argument = vim.iter(vim.v.argv):any(function(arg)
				local stat = vim.uv.fs_stat(arg)
				return stat ~= nil and stat.type == "file"
			end)

			if not started_with_file_argument then
				session.read()
			end
		end,
		nested = true,
	})
end

return M
