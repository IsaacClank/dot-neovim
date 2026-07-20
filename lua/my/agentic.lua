local mod = {}
mod.setup = function()
	local agentic = require("my.core.terminal").resizable_terminal({
		display_name = "AGENT",
		cmd = "opencode",
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
