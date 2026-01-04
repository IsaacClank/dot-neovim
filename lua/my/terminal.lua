local floatty = require("floatty")

local command = require("my.lib.command")
local keymap = require("my.lib.keymap")

local M = {}

M.setup = function()
	local terminal = floatty.setup({
		id = "Terminal",
		start_in_insert = false,
	})

	command.create_multiple({
		{
			"TermToggle",
			function(opts)
				terminal.toggle({ id = opts.args })
			end,
			{ desc = "Toggle terminal", nargs = "?" },
		},
	})

	keymap.set_multiple({
		{
			"n",
			"<Leader>tt",
			":TermToggle<CR>",
			{ desc = "Toggle terminal" },
		},
	})
end

return M
