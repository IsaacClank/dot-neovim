local clue = require("mini.clue")

local M = {}

M.setup = function()
	vim.api.nvim_set_keymap(
		"n",
		"<M-Up>",
		":resize +5<CR>",
		{ desc = "Increase height" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<M-Down>",
		":resize -5<CR>",
		{ desc = "Decrease height" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<M-Left>",
		":vertical resize +5<CR>",
		{ desc = "Increase width" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<M-Right>",
		":vertical resize -5<CR>",
		{ desc = "Decrease width" }
	)

	vim.api.nvim_set_keymap(
		"n",
		"]<Tab>",
		":tabnext<CR>",
		{ desc = "Next tab" }
	)
	vim.api.nvim_set_keymap(
		"n",
		"[<Tab>",
		":tabprevious<CR>",
		{ desc = "Previous tab" }
	)

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
