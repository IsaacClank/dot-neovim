local mod = {}
mod.setup = function()
	vim.schedule(function()
		local fzf = require("fzf-lua")
		vim.keymap.set("n", "<Leader>sp", fzf.builtin, { desc = "Pickers" })
		vim.keymap.set("n", "<Leader>s:", fzf.commands, { desc = "Commands" })
		vim.keymap.set("n", "<Leader>s?", fzf.helptags, { desc = "Help" })
		vim.keymap.set("n", "<Leader>sf", fzf.files, { desc = "Files" })
		vim.keymap.set("n", "<Leader>sg", fzf.live_grep, { desc = "Grep" })

		-- local mpick = require("mini.pick").registry
		-- vim.keymap.set("n", "<Leader>sp", mpick.pickers, { desc = "Pickers" })
		-- vim.keymap.set("n", "<Leader>s:", mpick.commands, { desc = "Commands" })
		-- vim.keymap.set("n", "<leader>s?", mpick.help, { desc = "Help" })
		-- vim.keymap.set("n", "<leader>sf", mpick.files, { desc = "Files" })
		-- vim.keymap.set("n", "<leader>sg", mpick.grep_live, { desc = "Grep" })

		vim.keymap.set("n", "<Leader>ld", function()
			fzf.lsp_definitions()
			-- mpick.lsp({ scope = "definition" })
		end, { desc = "Definitions" })

		vim.keymap.set("n", "<Leader>li", function()
			fzf.lsp_implementations()
			-- mpick.lsp({ scope = "implementation" })
		end, { desc = "Implementations" })

		vim.keymap.set("n", "<Leader>lr", function()
			fzf.lsp_references()
			-- mpick.lsp({ scope = "references" })
		end, { desc = "References" })

		vim.keymap.set("n", "<Leader>ss", function()
			fzf.lsp_document_symbols()
			-- mpick.lsp({ scope = "document_symbol" })
		end, { desc = "Symbols" })

		vim.keymap.set("n", "<Leader>sS", function()
			fzf.lsp_workspace_symbols()
			-- mpick.lsp({ scope = "workspace_symbol_live" })
		end, { desc = "Symbols (workspace)" })
	end)
end
return mod
