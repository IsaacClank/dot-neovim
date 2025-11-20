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
			{ "n", "gl", "<Plug>(leap)", { desc = "Leap" } },
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

local setup_split_join = function()
	deps.later(function()
		require("mini.splitjoin").setup({})
	end)
end

local setup_floatty = function()
	deps.add({
		source = "ingur/floatty.nvim",
		checkout = "main",
	})
end

M.setup = function()
	vim.o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
	vim.o.expandtab = true -- In insert mode, expand tabs into spaces.
	vim.o.scrolloff = 10 -- Minimum lines offset top & bottom. Used to add padding. When scrolling.
	vim.o.sidescrolloff = 8 -- Minimum lines offset left & right. Used to add padding.
	vim.o.shiftwidth = 2 -- Number of spaces used for auto-indent.
	vim.o.switchbuf = "usetab" -- Use already opened buffers when switching
	vim.o.tabstop = 2 -- Number of spaces to render tabs in a file. This does **not** modify the file.
	vim.o.termguicolors = true -- Enable 24-bit RGB colors
	vim.o.winborder = "single" -- Default floating window border
	vim.o.formatoptions = "rqnl1j" -- More intuitive comment editing (remove 'c' and 'o')
	vim.o.exrc = true -- Enable workspace configuration

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

	local severity = vim.diagnostic.severity
	deps.later(function()
		vim.diagnostic.config({
			signs = {
				severity = { min = severity.WARN, max = severity.ERROR },
				priority = 9999,
			},
			underline = {
				severity = { min = severity.HINT, max = severity.ERROR },
			},
			virtual_text = {
				severity = { min = severity.ERROR, max = severity.ERROR },
				current_line = true,
			},
			virtual_lines = false,
			update_in_insert = false,
		})
	end)

	require("mini.basics").setup({
		mappings = { move_with_alt = true },
	})

	setup_pairs()
	setup_surround()
	setup_leap()
	setup_split_join()
	setup_floatty()
end

return M
