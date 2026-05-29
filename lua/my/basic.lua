local M = {}

local setup_leap = function()
	vim.pack.add({
		"https://codeberg.org/andyg/leap.nvim",
	})

	require("leap").setup({})
	vim.api.nvim_set_keymap("n", "gl", "<Plug>(leap)", { desc = "Leap" })
end

local setup_pairs = function()
	require("mini.pairs").setup({})
end

local setup_surround = function()
	require("mini.surround").setup({})
end

local setup_split_join = function()
	require("mini.splitjoin").setup({})
end

local setup_terminal = function()
	vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })
	local toggleterm = require("toggleterm")
	toggleterm.setup({
		display_name = "Terminal",
		direction = "float",
		float_opts = {
			border = "curved",
			height = 30,
			width = vim.o.columns * 0.45,
			winblend = 10,
		},
		on_open = function(term)
			if term.hidden then
				return
			end

			vim.keymap.set("n", [[<Leader>tn]], function()
				vim.ui.input({
					prompt = "Set terminal name: ",
					default = term.display_name,
				}, function(input)
					term.display_name = input
					term:close()
					term:open()
				end)
			end, { desc = "Rename the terminnal" })

			vim.keymap.set("n", [[<Leader>tx]], function()
				term:shutdown()
			end, { desc = "Kill terminal" })
		end,
	})

	vim.keymap.set("t", [[<C-\><C-\>]], [[<C-\><C-n>]])
	vim.keymap.set(
		"n",
		[[<Leader>tt]],
		[[:ToggleTerm<CR>]],
		{ desc = "Toggle terminal" }
	)
	vim.keymap.set("n", [[<Leader>tc]], function()
		vim.ui.input(
			{ prompt = "Terminal name (empty for default): " },
			function(name)
				if name == nil then
					return
				end

				if vim.trim(name):len() == 0 then
					vim.cmd([[TermNew]])
				else
					vim.cmd("TermNew name=" .. name)
				end
			end
		)
	end, { desc = "Create a new terminal" })
	vim.keymap.set(
		"n",
		[[<Leader>ts]],
		[[<Cmd>TermSelect<CR>]],
		{ desc = "Select terminal" }
	)
end

local setup_diagnostic = function()
	local severity = vim.diagnostic.severity
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
end

local setup_notification = function()
	local mini_notify = require("mini.notify")
	mini_notify.setup({
		window = {
			config = function()
				return {
					anchor = "SE",
					col = vim.o.columns,
					row = vim.o.lines - 5,
				}
			end,
		},
	})

	vim.api.nvim_create_user_command("NotificationHistory", function()
		vim.cmd([[tabnew]])
		vim.api.nvim_create_buf(false, true)
		mini_notify.show_history()
	end, { desc = "Display notification history" })
end

M.setup = function()
	require("mini.basics").setup({
		mappings = { move_with_alt = true },
		autocommands = { relnum_in_visual_mode = true },
	})

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

	-- Ensure excluded options of 'formatoptions' are not included by filetype detection
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			vim.opt.formatoptions:remove("c")
			vim.opt.formatoptions:remove("o")
		end,
	})

	setup_pairs()
	setup_surround()
	setup_leap()
	setup_split_join()
	setup_terminal()
	setup_diagnostic()
	setup_notification()
end

return M
