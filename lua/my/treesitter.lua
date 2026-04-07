local deps = require("mini.deps")

local M = {}

M.setup = function()
	deps.add({
		source = "nvim-treesitter/nvim-treesitter-context",
		checkout = "v1.0.0",
	})

	deps.later(function()
		require("treesitter-context").setup({})
	end)
end

return M
