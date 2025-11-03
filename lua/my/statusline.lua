local M = {}
M.setup = function()
	require("mini.statusline").setup({
		use_icons = true,
	})
end
return M
