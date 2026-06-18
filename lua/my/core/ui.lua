local function setup_notification()
	vim.pack.add({
		"https://github.com/nvim-mini/mini.notify",
	})

	local mini_notify = require("mini.notify")

	mini_notify.setup({
		window = {
			config = {
				anchor = "NE",
				row = 3,
			},
		},
		lsp_progress = {},
	})

	vim.api.nvim_create_user_command("NotificationHistory", function()
		vim.cmd([[tabnew]])
		vim.api.nvim_create_buf(false, true)
		mini_notify.show_history()
	end, { desc = "Display notification history" })
end

local function setup_diagnostic()
	local severity = vim.diagnostic.severity
	vim.diagnostic.config({
		signs = {
			severity = { min = severity.WARN, max = severity.ERROR },
			priority = 9999,
		},
		underline = {
			severity = { min = severity.HINT, max = severity.ERROR },
		},
		virtual_text = {
			severity = { min = severity.ERROR, max = severity.ERROR },
			current_line = true,
		},
		virtual_lines = false,
		update_in_insert = false,
	})
end

local function setup_themes()
	vim.pack.add({
		"https://github.com/ellisonleao/gruvbox.nvim",
		"https://github.com/sainnhe/gruvbox-material",
		"https://github.com/mofiqul/dracula.nvim",
		"https://github.com/olimorris/onedarkpro.nvim",
		"https://github.com/shaunsingh/nord.nvim",
	})

	vim.cmd([[colorscheme gruvbox-material]])
end

local mod = {}
function mod.setup()
	setup_notification()
	setup_themes()
	setup_diagnostic()
end
return mod
