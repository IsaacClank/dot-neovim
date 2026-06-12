local mod = {}

function mod.setup()
	vim.pack.add({
		"https://codeberg.org/andyg/leap.nvim",

		"https://github.com/nvim-mini/mini.pairs",
		"https://github.com/nvim-mini/mini.surround",
		"https://github.com/nvim-mini/mini.splitjoin",

		"https://github.com/nvim-mini/mini.ai",
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	})

	vim.schedule(function()
		require("leap").setup({})
		vim.keymap.set("n", "gl", "<Plug>(leap)", { desc = "Leap" })

		require("mini.pairs").setup({})
		require("mini.surround").setup({})
		require("mini.splitjoin").setup({})

		local mini_ai = require("mini.ai")
		mini_ai.setup({
			custom_textobjects = {
				F = mini_ai.gen_spec.treesitter({
					a = "@function.outer",
					i = "@function.inner",
				}),
				o = mini_ai.gen_spec.treesitter({
					a = { "@conditional.outer", "@loop.outer" },
					i = { "@conditional.inner", "@loop.inner" },
				}),
			},
		})
	end)
end

return mod
