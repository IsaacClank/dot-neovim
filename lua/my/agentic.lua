local mod = {}
mod.setup = function()
	local agentic = require("toggleterm.terminal").Terminal:new({
		display_name = "AGENT",
		cmd = "opencode",
		hidden = true,
		direction = "float",
		close_on_exit = true,
		float_opts = {
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
