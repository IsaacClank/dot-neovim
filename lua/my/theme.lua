local mini_deps = require("mini.deps")

local M = {}
M.setup = function()
	mini_deps.add("bluz71/vim-moonfly-colors")
	mini_deps.add("catppuccin/nvim")
	mini_deps.add("folke/tokyonight.nvim")
	mini_deps.add("mofiqul/vscode.nvim")
	mini_deps.add("olimorris/onedarkpro.nvim")
	mini_deps.add("rebelot/kanagawa.nvim")
	mini_deps.add("rose-pine/neovim")
	mini_deps.add("sainnhe/everforest")
	mini_deps.add("vague2k/vague.nvim")
	mini_deps.add("tanvirtin/monokai.nvim")
	mini_deps.add("mofiqul/dracula.nvim")

	require("mini.indentscope").setup({
		draw = {
			animation = require("mini.indentscope").gen_animation.linear({
				duration = 5,
			}),
		},
	})

	mini_deps.now(function()
		local themes = {
			{ name = "catppuccin" },
			{ name = "catppuccin-frappe" },
			{ name = "catppuccin-macchiato" },
			{ name = "catppuccin-mocha" },
			{ name = "dracula" },
			{ name = "everforest" },
			{ name = "kanagawa" },
			{ name = "kanagawa-dragon" },
			{ name = "kanagawa-wave" },
			{ name = "monokai" },
			{ name = "monokai_pro" },
			{ name = "monokai_ristretto" },
			{ name = "monokai_soda" },
			{ name = "moonfly" },
			{ name = "onedark" },
			{ name = "onedark_vivid" },
			{ name = "rose-pine-main" },
			{ name = "rose-pine-moon" },
			{ name = "tokyonight" },
			{ name = "tokyonight-moon" },
			{ name = "tokyonight-night" },
			{ name = "tokyonight-storm" },
			{ name = "vague" },
			{ name = "vscode" },
		}
		_G.themes = themes

		math.randomseed(os.time())
		local theme_index = math.random(1, vim.tbl_count(themes))
		local theme = vim.tbl_get(_G.themes, theme_index)
		local theme_name = vim.tbl_get(theme, "name")
		local theme_setup = vim.tbl_get(theme, "setup")
		if theme_setup ~= nil then
			theme_setup()
		end
		vim.cmd("colorscheme " .. theme_name)
	end)
end
return M
