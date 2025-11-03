local deps = require("mini.deps")
local keymap = require("my.lib.keymap")

local M = {}

local setup_telescope = function()
	deps.add({
		source = "nvim-telescope/telescope.nvim",
		checkout = "0.1.8",
		depends = {
			"nvim-lua/plenary.nvim",
		},
	})
	require("telescope").setup({
		defaults = {
			sorting_strategy = "ascending",
			layout_strategy = "center",
			layout_config = {
				prompt_position = "top",
			},
		},
		pickers = {
			colorscheme = {
				enable_preview = true,
			},
		},
	})

	local mini_pick = require("mini.pick")
	mini_pick.setup()

	mini_pick.registry.commands = function()
		local source = {
			name = "commands",
			items = function()
				return vim.tbl_values(vim.api.nvim_get_commands({}))
			end,
			show = function(buf, commands, _)
				local lines = vim.tbl_map(function(item)
					return string.format("%32s | %s", item.name, item.definition)
				end, commands)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			end,
			choose = function(command)
				vim.schedule(function()
					vim.cmd(command.name)
				end)
			end,
		}
		mini_pick.start({ source = source })
	end

	mini_pick.registry.config = function()
		local command = { "rg", "--color=never", "--files", vim.fs.dirname(vim.env.MYVIMRC) }

		return mini_pick.builtin.cli({ command = command }, {
			source = {
				name = "files",
				show = function(buf, items, query)
					mini_pick.default_show(buf, items, query, {
						show_icons = true,
					})
				end,
			},
		})
	end

	mini_pick.registry.files = function(local_opts)
		local_opts = local_opts or {}

		local command = { "rg", "--color=never", "--files" }
		if local_opts.hidden then
			table.insert(command, "-.")
		end
		if local_opts.no_ignore then
			table.insert(command, "--no-ignore")
		end

		return mini_pick.builtin.cli({ command = command }, {
			source = {
				name = "files",
				show = function(buf, items, query)
					mini_pick.default_show(buf, items, query, {
						show_icons = true,
					})
				end,
			},
		})
	end

	mini_pick.registry.files_including_hidden = function()
		return mini_pick.registry.files({ hidden = true })
	end

	mini_pick.registry.files_recent = function(local_opts)
		local_opts = vim.tbl_deep_extend("force", { current_dir = false, preserve_order = false }, local_opts or {})
		return mini_pick.start({
			source = {
				name = "files_recent",
				items = function()
					local recent_files = {}
					local cwd = vim.uv.cwd() or error()
					for _, path in ipairs(vim.v.oldfiles) do
						if vim.fn.filereadable(path) and vim.startswith(path, cwd) then
							table.insert(recent_files, vim.fs.relpath(cwd, path))
						end
					end
					return recent_files
				end,
				show = function(buf, items_to_show, query)
					mini_pick.default_show(buf, items_to_show, query, {
						show_icons = true,
					})
				end,
				match = function(stritems, indices, query)
					mini_pick.default_match(stritems, indices, query, {
						preserve_order = true,
					})
				end,
			},
		})
	end

	mini_pick.registry.pickers = function()
		mini_pick.start({
			source = {
				items = function()
					return vim.tbl_keys(mini_pick.registry)
				end,
				choose = function(picker)
					vim.schedule(function()
						mini_pick.registry[picker]()
					end)
				end,
			},
		})
	end

	mini_pick.registry.themes = function()
		local original_theme = vim.g.colors_name

		local result = mini_pick.start({
			source = {
				name = "themes",
				items = vim.tbl_map(function(theme)
					return theme.name
				end, _G.themes),
				preview = function(buf, theme)
					vim.cmd.colorscheme(theme)

					local lines = vim.tbl_keys(vim.api.nvim_get_hl(0, {}))
					table.sort(lines)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				end,
			},
		})

		if result == nil then
			vim.cmd.colorscheme(original_theme)
		end
	end

	keymap.set_multiple({
		{ "n", "<Leader>sp", mini_pick.registry.commands, { desc = "Commands" } },
		{
			"n",
			"<Leader>s<A-p>",
			mini_pick.registry.pickers,
			{ desc = "Commands (pickers only)" },
		},

		{ "n", "<leader>sb", mini_pick.registry.buffers, { desc = "Buffers" } },

		{ "n", "<leader>sf", mini_pick.registry.files, { desc = "Files" } },
		{ "n", "<leader>s<A-f>", mini_pick.registry.files_recent, { desc = "Files (recent)" } },
		{ "n", "<leader>sF", mini_pick.registry.files_including_hidden, { desc = "Files (hidden)" } },

		{ "n", "<leader>sg", mini_pick.registry.grep_live, { desc = "Grep (live)" } },

		{ "n", "<Leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Symbols" } },
		{ "n", "<Leader>sS", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Symbols (workspace)" } },
	})
end

M.setup = function()
	setup_telescope()
end

return M
