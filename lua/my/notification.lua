local M = {}

M.setup = function()
	local mini_notify = require("mini.notify")
	mini_notify.setup({
		window = {
			config = function()
				local has_statusline = vim.o.laststatus > 0
				local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
				return {
					anchor = "SE",
					col = vim.o.columns,
					row = vim.o.lines - 5,
				}
			end,
		},
	})

	vim.api.nvim_create_user_command("NotificationHistory", function()
		vim.cmd([[tabnew]])
		vim.api.nvim_create_buf(false, true)
		mini_notify.show_history()
	end, { desc = "Display notification history" })
end

return M
