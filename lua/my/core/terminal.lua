local mod = {}

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
