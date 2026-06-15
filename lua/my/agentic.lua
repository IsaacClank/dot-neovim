local mod = {}
mod.setup = function()
	local agentic = require("toggleterm.terminal").Terminal:new({
		display_name = "Agent",
		cmd = "opencode",
		hidden = true,
		direction = "float",
		close_on_exit = true,
		float_opts = {
			title_pos = "center",
			row = 1,
			col = 0,
			width = math.floor(vim.o.columns * 0.33),
			height = math.floor(vim.o.lines * 0.93),
			winblend = 10,
		},
	})

	vim.api.nvim_create_user_command("Agentic", function()
		agentic:toggle()
	end, { desc = "Toggle Agent" })

	vim.keymap.set(
		"n",
		"<Leader>a",
		"<Cmd>Agentic<CR>",
		{ desc = "Toggle Agent" }
	)

	vim.keymap.set(
		{ "n", "t" },
		"<C-a>",
		"<Cmd>Agentic<CR>",
		{ desc = "Toggle Agent" }
	)
end
return mod
