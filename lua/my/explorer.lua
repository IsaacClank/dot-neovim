local deps = require("mini.deps")

local M = {}
M.setup = function()
	deps.add({
		source = "nvim-tree/nvim-tree.lua",
		checkout = "v1.14.0",
		depends = { "nvim-tree/nvim-web-devicons" },
	})

	require("nvim-tree").setup({
		auto_reload_on_write = true,
		reload_on_bufenter = true,
		view = {
			float = {
				enable = true,
				open_win_config = {
					width = 60,
					row = 2,
					col = 2,
				},
			},
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			local function opts(desc)
				return {
					desc = "nvim-tree: " .. desc,
					buffer = bufnr,
					noremap = true,
					silent = true,
					nowait = true,
				}
			end

			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.set(
				"n",
				"<C-s>",
				api.node.open.horizontal,
				opts("Open: Horizontal Split")
			)
			vim.keymap.del("n", "<C-x>", { buffer = bufnr })
		end,
	})

	vim.keymap.set(
		"n",
		"<Leader>ee",
		"<Cmd>NvimTreeToggle<CR>",
		{ desc = "Open explorer" }
	)
	vim.keymap.set(
		"n",
		"<Leader>ef",
		"<Cmd>NvimTreeFindFileToggle<CR>",
		{ desc = "Open explorer at current file" }
	)
end
return M
