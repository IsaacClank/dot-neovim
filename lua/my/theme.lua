local M = {}
M.setup = function()
	require("mini.indentscope").setup({
		draw = {
			animation = require("mini.indentscope").gen_animation.linear({
				duration = 5,
			}),
		},
	})

	vim.pack.add({
		"https://github.com/ellisonleao/gruvbox.nvim",
		"https://github.com/mofiqul/dracula.nvim",
		"https://github.com/olimorris/onedarkpro.nvim",
		"https://github.com/shaunsingh/nord.nvim",
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function(ev)
			vim.notify("[my.theme] Applied theme: '" .. ev.match .. "'")
		end,
	})

	_G.themes = {
		"dracula",
		"gruvbox",
		"nord",
		"onedark",
	}

	math.randomseed(os.time())
	local theme_index = math.random(1, vim.tbl_count(themes))
	local theme = vim.tbl_get(_G.themes, theme_index)
	vim.cmd("colorscheme " .. theme)
end
return M
