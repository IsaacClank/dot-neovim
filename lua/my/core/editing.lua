local mod = {}

function mod.setup()
	vim.pack.add({
		"https://codeberg.org/andyg/leap.nvim",

		"https://github.com/nvim-mini/mini.pairs",
		"https://github.com/nvim-mini/mini.surround",
		"https://github.com/nvim-mini/mini.splitjoin",

		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	})

	require("leap").setup({})
	vim.keymap.set("n", "gl", "<Plug>(leap)", { desc = "Leap" })

	require("mini.pairs").setup({})
	require("mini.surround").setup({})
	require("mini.splitjoin").setup({})
	require("nvim-treesitter-textobjects").setup({})

	local select_textobject =
		require("nvim-treesitter-textobjects.select").select_textobject

	vim.keymap.set({ "x", "o" }, "af", function()
		select_textobject("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "if", function()
		select_textobject("@function.inner", "textobjects")
	end)
end

return mod
