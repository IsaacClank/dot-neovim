local deps = require("mini.deps")

local M = {}

M.setup = function()
	deps.add({
		source = "saxon1964/neovim-tips",
		depends = {
			"muniftanjim/nui.nvim",
		},
	})

	deps.now(function()
		require("neovim_tips").setup({
			user_file = vim.fn.stdpath("data") .. "neovim_tips/user_tips.md",
			daily_tip = 1,
		})
	end)
end

return M
