local M = {}

local function setup_lazygit()
	vim.pack.add({
		{ src = "https://github.com/kdheepak/lazygit.nvim" },
	})

	vim.schedule(function()
		local lazygit = require("toggleterm.terminal").Terminal:new({
			display_name = "LazyGit",
			cmd = "lazygit",
			hidden = true,
			direction = "float",
			close_on_exit = true,
			float_opts = {
				title_pos = "center",
				row = 5,
				width = vim.o.columns,
				height = 50,
			},
		})

		vim.api.nvim_create_user_command("GitView", function()
			lazygit:toggle()
		end, { desc = "Open LazyGit" })

		vim.keymap.set(
			"n",
			"<Leader>gg",
			"<Cmd>GitView<CR>",
			{ desc = "Toggle Git view (LazyGit)" }
		)
	end)
end

local function setup_minidiff()
	vim.pack.add({
		{ src = "https://github.com/nvim-mini/mini.diff" },
	})

	vim.schedule(function()
		local mini_diff = require("mini.diff")
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

		vim.api.nvim_create_user_command("GitStage", function(opts)
			mini_diff.do_hunks(0, "apply", {
				line_start = opts.line1,
				line_end = opts.line2,
			})
		end, { desc = "Stage range", range = "%" })
		vim.api.nvim_create_user_command(
			"GitUnstageFile",
			"silent !git restore --staged -- %",
			{ desc = "Unstage file" }
		)

		vim.keymap.set(
			"n",
			"<Leader>gd",
			":lua MiniDiff.toggle_overlay()<CR>",
			{ desc = "Toggle diff overlay" }
		)

		vim.keymap.set(
			"n",
			"]g",
			":lua MiniDiff.goto_hunk 'next'<CR>",
			{ desc = "Next hunk" }
		)
		vim.keymap.set(
			"n",
			"[g",
			":lua MiniDiff.goto_hunk 'prev'<CR>",
			{ desc = "Previous hunk" }
		)
		vim.keymap.set(
			"n",
			"]G",
			":lua MiniDiff.goto_hunk 'last'<CR>",
			{ desc = "Last hunk" }
		)
		vim.keymap.set(
			"n",
			"[G",
			":lua MiniDiff.goto_hunk 'first'<CR>",
			{ desc = "First hunk" }
		)

		vim.keymap.set(
			{ "n", "x" },
			"<Leader>gs",
			":GitStage<CR>",
			{ desc = "Stage" }
		)
		vim.keymap.set(
			"n",
			"<Leader>gS",
			":GitUnstageFile<CR>",
			{ desc = "Unstage" }
		)
	end)
end

M.setup = function()
	setup_lazygit()
	setup_minidiff()
end

return M
