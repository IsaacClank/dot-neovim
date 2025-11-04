local keymap = require("my.lib.keymap")
local deps = require("mini.deps")

local M = {}

local setup_leap = function()
	deps.add({
		source = "ggandor/leap.nvim",
		checkout = "main",
	})

	deps.later(function()
		require("leap").setup({})
		keymap.set_multiple({
			{ "n", "gl", "<Plug>(leap-forward)", { desc = "Leap forward" } },
			{ "n", "gL", "<Plug>(leap-backward)", { desc = "Leap backward" } },
		})
	end)
end

local setup_pairs = function()
	deps.later(function()
		require("mini.pairs").setup({})
	end)
end

local setup_surround = function()
	deps.later(function()
		require("mini.surround").setup({})
	end)
end

M.setup = function()
	vim.o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
	vim.o.expandtab = true -- In insert mode, expand tabs into spaces.
	vim.o.scrolloff = 999 -- Minimum lines offset top & bottom. Used to add padding. When scrolling, cursor always at center
	vim.o.sidescrolloff = 8 -- Minimum lines offset left & right. Used to add padding.
	vim.o.shiftwidth = 2 -- Number of spaces used for auto-indent.
	vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
	vim.o.switchbuf = "usetab" -- Use already opened buffers when switching
	vim.o.tabstop = 2 -- Number of spaces to render tabs in a file. This does **not** modify the file.
	vim.o.termguicolors = true -- Enable 24-bit RGB colors
	vim.o.winborder = "single" -- Default floating window border
	vim.o.formatoptions = "rqnl1j" -- More intuitive comment editing (remove 'c' and 'o')
	vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior

	vim.g.loaded_node_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_python3_provider = 0
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"

	-- Ensure excluded options of 'formatoptions' are not included by filetype detection
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			vim.opt.formatoptions:remove("c")
			vim.opt.formatoptions:remove("o")
		end,
	})

	deps.later(function()
		vim.diagnostic.config({
			signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },
			underline = { severity = { min = "HINT", max = "ERROR" } },
			virtual_lines = false,
			virtual_text = {
				current_line = true,
				severity = { min = "ERROR", max = "ERROR" },
			},
			update_in_insert = false,
		})
	end)

	require("mini.basics").setup({
		mappings = { move_with_alt = true },
	})

	setup_pairs()
	setup_surround()
	setup_leap()
end

return M
