local mod = {}

mod.setup = function()
	vim.pack.add({ "https://github.com/nvim-mini/mini.clue" })

	local clue = require("mini.clue")

	vim.keymap.set("n", "<Leader>pn", "<Cmd>new<CR>", { desc = "New pane" })
	vim.keymap.set("n", "<Leader>pr>", "<C-w>>", { desc = "Increase width" })
	vim.keymap.set("n", "<Leader>pr<", "<C-w><", { desc = "Decrease width" })
	vim.keymap.set("n", "<Leader>pr+", "<C-w>+", { desc = "Increase heigth" })
	vim.keymap.set("n", "<Leader>pr-", "<C-w>-", { desc = "Decrease height" })
	vim.keymap.set("n", "<Leader>pr=", "<C-w>=", { desc = "Equalize" })

	clue.setup({
		triggers = {
			{ mode = "n", keys = "<Leader>" },
			{ mode = "n", keys = "g" },
			{ mode = "n", keys = "z" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },
			{ mode = "n", keys = [[\]] },

			{ mode = "i", keys = "<C-x>" },
		},
		clues = {
			{ mode = "n", keys = "<Leader>e", desc = "+Explorer" },
			{ mode = "n", keys = "<Leader>g", desc = "+Git" },
			{ mode = "n", keys = "<Leader>l", desc = "+Intellisense" },
			{ mode = "n", keys = "<Leader>s", desc = "+Search/Navigation" },
			{ mode = "n", keys = "<Leader>t", desc = "+Terminal" },

			{ mode = "n", keys = "<Leader>p", desc = "+Pane" },
			{ mode = "n", keys = "<Leader>pr", desc = "+Resize" },
			{ mode = "n", keys = "<Leader>pr>", postkeys = "<Leader>pr" },
			{ mode = "n", keys = "<Leader>pr<", postkeys = "<Leader>pr" },
			{ mode = "n", keys = "<Leader>pr+", postkeys = "<Leader>pr" },
			{ mode = "n", keys = "<Leader>pr-", postkeys = "<Leader>pr" },

			{ mode = "n", keys = "<Leader>o", desc = "+Session" },

			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.square_brackets(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
		},
		window = {
			delay = 250,
			config = {
				width = "auto",
			},
		},
	})
end

return mod
