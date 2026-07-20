local mod = {}

function mod.resizable_terminal(opts)
	opts = opts or {}

	local toggleterm = require("toggleterm.terminal")
	local default_float_opts = {
		title_pos = "center",
		row = 2,
		col = function()
			return vim.o.columns
		end,
		width = function()
			return math.floor(vim.o.columns * 0.35)
		end,
		height = function()
			return math.floor(vim.o.lines * 0.9)
		end,
	}

	return toggleterm.Terminal:new({
		display_name = opts.display_name or "",
		cmd = opts.cmd or nil,
		hidden = true,
		direction = "float",
		close_on_exit = true,
		float_opts = default_float_opts,
		on_close = function(term)
			local win_config = vim.api.nvim_win_get_config(term.window)
			local row, col, width, height =
				win_config.row,
				win_config.col,
				win_config.width,
				win_config.height

			term.float_opts = vim.tbl_extend("force", default_float_opts, {
				row = row,
				col = col,
				width = width,
				height = height,
			})
		end,
	})
end

function mod.setup()
	vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })
	local toggleterm = require("toggleterm")
	toggleterm.setup({
		display_name = "Terminal",
		direction = "float",
		float_opts = {
			border = "curved",
			height = math.floor(vim.o.lines * 0.40),
			width = math.floor(vim.o.columns * 0.70),
			row = vim.o.lines - math.floor(vim.o.lines * 0.4) - 4,
		},
		open_mapping = [[<c-t>]],
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

return mod
