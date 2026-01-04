local clue = require("mini.clue")
local keymap = require("my.lib.keymap")

local M = {}

M.setup = function()
	keymap.set_multiple({
		{
			"n",
			"<M-Up>",
			function()
				vim.cmd([[resize +5]])
			end,
			{ desc = "Increase height" },
		},
		{
			"n",
			"<M-Down>",
			function()
				vim.cmd([[resize -5]])
			end,
			{ desc = "Decrease height" },
		},
		{
			"n",
			"<M-Right>",
			function()
				vim.cmd([[vertical resize +5]])
			end,
			{ desc = "Increase height" },
		},
		{
			"n",
			"<M-Left>",
			function()
				vim.cmd([[vertical resize -5]])
			end,
			{ desc = "Decrease height" },
		},

		-- Tab
		{
			"n",
			"]<Tab>",
			function()
				vim.cmd([[tabnext]])
			end,
			{ desc = "Next tab" },
		},
		{
			"n",
			"[<Tab>",
			function()
				vim.cmd([[tabprevious]])
			end,
			{ desc = "Previous tab" },
		},

		-- Terminal bindings
		{
			"t",
			"<Esc>",
			"<C-\\><C-n>",
			{ desc = "Escape to normal mode" },
		},
		{
			"t",
			"<C-\\>q",
			"<C-\\><C-n><C-w>q<CR>",
			{ desc = "Quit terminal" },
		},
	})

	clue.setup({
		triggers = {
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },
			{ mode = "n", keys = "g" },
			{ mode = "n", keys = "z" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = "n", keys = [[\]] },
			{ mode = "i", keys = "<C-x>" },
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },
		},
		clues = {
			{ mode = "n", keys = "<Leader>e", desc = "+Explorer" },
			{ mode = "n", keys = "<Leader>g", desc = "+Git" },
			{ mode = "n", keys = "<Leader>l", desc = "+Intellisense" },
			{ mode = "n", keys = "<Leader>s", desc = "+Search/Navigation" },
			{ mode = "n", keys = "<Leader>t", desc = "+Terminal" },

			clue.gen_clues.g(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.square_brackets(),
		},
		window = {
			delay = 350,
			config = {
				width = "auto",
			},
		},
	})
end

return M
