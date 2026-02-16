local mini_deps = require("mini.deps")

local M = {}
M.setup = function()
	mini_deps.add("catppuccin/nvim")
	mini_deps.add("folke/tokyonight.nvim")
	mini_deps.add("loctvl842/monokai-pro.nvim")
	mini_deps.add("mofiqul/dracula.nvim")
	mini_deps.add("olimorris/onedarkpro.nvim")
	mini_deps.add("vague2k/vague.nvim")

	require("mini.indentscope").setup({
		draw = {
			animation = require("mini.indentscope").gen_animation.linear({
				duration = 5,
			}),
		},
	})

	mini_deps.now(function()
		local themes = {
			-- { name = "catppuccin" },
			-- { name = "catppuccin-frappe" },
			-- { name = "catppuccin-macchiato" },
			{ name = "catppuccin-mocha" },
			{ name = "dracula" },
			{
				name = "monokai-pro",
				setup = function()
					require("monokai-pro").setup()
				end,
			},
			{ name = "onedark" },
			-- { name = "onedark_vivid" },
			{ name = "tokyonight" },
			-- { name = "tokyonight-moon" },
			-- { name = "tokyonight-night" },
			-- { name = "tokyonight-storm" },
			{ name = "vague" },
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

	mini_deps.later(function()
		vim.notify(
			"[my.theme] '" .. vim.g.colors_name .. "' was loaded",
			vim.log.levels.INFO
		)
	end)
end
return M
