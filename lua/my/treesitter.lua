local deps = require("mini.deps")

local M = {}

M.setup = function()
	deps.add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		monitor = "main",
		hooks = {
			post_checkout = function()
				vim.cmd([[TSUpdate]])
			end,
		},
	})
	deps.add({
		source = "nvim-treesitter/nvim-treesitter-context",
		checkout = "v1.0.0",
	})

	deps.later(function()
		require("nvim-treesitter").setup({
			ensure_installed = {
				"c",
				"c_sharp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"typescript",
			},
			auto_install = true,
		})
		require("treesitter-context").setup({})
	end)
end

return M
