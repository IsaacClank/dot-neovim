local mini_diff = require("mini.diff")
local keymap = require("my.lib.keymap")
local command = require("my.lib.command")

local M = {}

M.setup = function()
	vim.pack.add({
		{ src = "https://github.com/kdheepak/lazygit.nvim" },
	})

	vim.schedule(function()
		require("mini.git").setup()

		mini_diff.setup({
			mappings = {
				apply = "",
				reset = "",
				textobject = "",
				goto_first = "",
				goto_last = "",
				goto_next = "",
				goto_prev = "",
			},
		})

		local lazygit = require("toggleterm.terminal").Terminal:new({
			display_name = "LazyGit",
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			close_on_exit = true,
			float_opts = {
				title = "center",
				row = 5,
				width = vim.o.columns,
				height = 50,
			},
		})

		command.create_multiple({
			{
				"GitView",
				function()
					lazygit:toggle()
				end,
				{ desc = "Open LazyGit" },
			},
			{
				"GitStage",
				function(opts)
					mini_diff.do_hunks(0, "apply", {
						line_start = opts.line1,
						line_end = opts.line2,
					})
				end,
				{ range = "%" },
			},
			{ "GitStageFile", "Git add -- %" },
			{ "GitUnstageFile", "Git restore --staged -- %" },
		})

		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit*",
			callback = function()
				vim.cmd("bdelete!")
			end,
		})

		keymap.set_multiple({
			{
				"n",
				"<Leader>gg",
				":GitView<CR>",
				{ desc = "Toggle Git view (LazyGit)" },
			},

			{
				"n",
				"<Leader>gd",
				":lua MiniDiff.toggle_overlay()<CR>",
				{ desc = "Toggle diff overlay" },
			},

			{
				"n",
				"<Leader>gs",
				":GitStageFile<CR>",
				{ desc = "Stage file" },
			},
			{
				"x",
				"<Leader>gs",
				":'<,'>GitStage<CR>",
				{ desc = "Stage selected hunk" },
			},

			{
				"n",
				"]g",
				":lua MiniDiff.goto_hunk 'next'<CR>",
				{ desc = "Next hunk" },
			},
			{
				"n",
				"[g",
				":lua MiniDiff.goto_hunk 'prev'<CR>",
				{ desc = "Previous hunk" },
			},
			{
				"n",
				"]G",
				":lua MiniDiff.goto_hunk 'last'<CR>",
				{ desc = "Last hunk" },
			},
			{
				"n",
				"[G",
				":lua MiniDiff.goto_hunk 'first'<CR>",
				{ desc = "First hunk" },
			},
		})
	end)
end

return M
