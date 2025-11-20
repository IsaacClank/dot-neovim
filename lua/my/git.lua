local deps = require("mini.deps")
local keymap = require("my.lib.keymap")

local M = {}

M.setup = function()
	deps.add({
		source = "kdheepak/lazygit.nvim",
		checkout = "main",
	})
	deps.add({
		source = "lewis6991/gitsigns.nvim",
		checkout = "v1.0.2",
	})

	deps.later(function()
		vim.keymap.set("n", "<Leader>gg", "<Cmd>LazyGit<CR>", { desc = "Dashboard" })

		require("gitsigns").setup({
			numhl = true,
			current_line_blame = true,
			current_line_blame_opts = { delay = 300, virt_text_pos = "right_align" },
			diff_opts = {
				algorithm = "histogram",
				vertical = true,
				ignore_whitespace = true,
			},
		})

		keymap.set_multiple({
			{ "n", "<Leader>gn", ":Gitsigns nav_hunk 'next' preview=true<CR>", { desc = "Next hunk" } },
			{ "n", "<Leader>gp", ":Gitsigns nav_hunk 'prev' preview=true<CR>", { desc = "Previous hunk" } },
			{ "x", "<Leader>gs", ":'<,'>Gitsigns stage_hunk<CR>", { desc = "Stage/Unstage hunk" } },
			{ "x", "<Leader>gr", ":'<,'>Gitsigns reset_hunk<CR>", { desc = "Reset hunk" } },
			{
				"n",
				"<Leader>gd",
				function()
					vim.cmd([[tabnew %]])
					require("gitsigns").diffthis(nil, { split = "leftabove" })
				end,
				{ desc = "File diff" },
			},
		})

		vim.api.nvim_create_user_command("GitStageFile", "Gitsigns stage_buffer", {})
		vim.api.nvim_create_user_command("GitUnstageFile", "Gitsigns reset_buffer_index", {})
	end)
end

return M
