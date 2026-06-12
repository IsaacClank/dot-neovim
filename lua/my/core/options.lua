local function setup_basics()
	vim.pack.add({ "https://github.com/nvim-mini/mini.basics" })
	require("mini.basics").setup({
		mappings = { move_with_alt = true },
		autocommands = { relnum_in_visual_mode = true },
	})

	vim.o.breakindentopt = "list:-1" -- Add padding for lists (if 'wrap' is set)
	vim.o.expandtab = true -- In insert mode, expand tabs into spaces.
	vim.o.exrc = true -- Enable workspace configuration
	vim.o.formatoptions = "rqnl1j" -- More intuitive comment editing (remove 'c' and 'o')

	vim.o.list = true
	vim.opt.listchars = {
		tab = "│ ",
		leadmultispace = "│ ",
		trail = "-",
		nbsp = "+",
	}

	vim.o.scrolloff = 10 -- Minimum lines offset top & bottom. Used to add padding. When scrolling.
	vim.o.shiftwidth = 2 -- Number of spaces used for auto-indent.
	vim.o.sidescrolloff = 8 -- Minimum lines offset left & right. Used to add padding.
	vim.o.signcolumn = "number" -- Display signs in the number column.
	vim.o.switchbuf = "usetab" -- Use already opened buffers when switching
	vim.o.tabstop = 2 -- Number of spaces to render tabs in a file. This does **not** modify the file.
	vim.o.termguicolors = true -- Enable 24-bit RGB colors
	vim.o.winborder = "single" -- Default floating window border
	vim.o.foldmethod = "indent"
	vim.o.foldlevel = 99

	vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
	vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
	vim.o.complete = ".,w,b,u"

	vim.g.loaded_node_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_python3_provider = 0
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			vim.opt.formatoptions:remove("c")
			vim.opt.formatoptions:remove("o")
		end,
	})
end

local mod = {}
function mod.setup()
	setup_basics()
end
return mod
