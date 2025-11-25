local mini_deps = require("mini.deps")
local mini_pick = require("mini.pick")
local keymap = require("my.lib.keymap")

local M = {}

local setup_telescope = function()
	mini_deps.add({
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
end

local setup_pickers = function()
	mini_pick.setup({
		mappings = {
			execute = {
				char = "<C-e>",
				func = function()
					vim.cmd(vim.fn.input("Execute: "))
				end,
			},
		},
	})

	mini_pick.registry.commands = function()
		local source = {
			name = "commands",
			items = function()
				return vim.tbl_values(vim.api.nvim_get_commands({}))
			end,
			show = function(buf, commands, _)
				local lines = vim.tbl_map(function(item)
					return string.format(
						"%-32s | %s",
						item.name,
						item.definition
					)
				end, commands)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			end,
			choose = function(command)
				vim.schedule(function()
					vim.api.nvim_input(":" .. command.name)
				end)
			end,
		}
		mini_pick.start({ source = source })
	end

	mini_pick.registry.config = function()
		local command = {
			"rg",
			"--color=never",
			"--files",
			"--glob=*.lua",
			vim.fs.dirname(vim.env.MYVIMRC),
			vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "deps"),
		}
		return mini_pick.builtin.cli({ command = command }, {
			source = {
				name = "config",
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
		local_opts = vim.tbl_deep_extend(
			"force",
			{ current_dir = false, preserve_order = false },
			local_opts or {}
		)
		return mini_pick.start({
			source = {
				name = "files_recent",
				items = function()
					local recent_files = {}
					local cwd = vim.uv.cwd() or error()

					vim.iter(_G.my_recent_files or {}):each(function(path)
						if
							vim.fn.filereadable(path)
							and vim.startswith(path, cwd)
						then
							table.insert(
								recent_files,
								vim.fs.relpath(cwd, path)
							)
						end
					end)

					local rg_cmd = { "rg", "--color=never", "--files" }
					if local_opts.hidden then
						table.insert(rg_cmd, "-.")
					end
					if local_opts.no_ignore then
						table.insert(rg_cmd, "--no-ignore")
					end
					if vim.o.ignorecase then
						table.insert(rg_cmd, "--ignore-case")
					end
					if vim.o.smartcase then
						table.insert(rg_cmd, "--smart-case")
					end
					local rg_cmd_result = vim.system(rg_cmd, { text = true })
						:wait()

					for path in rg_cmd_result.stdout:gmatch("[^\n]+") do
						local relative_path = vim.fs.relpath(cwd, path)
						if
							not vim.tbl_contains(recent_files, relative_path)
						then
							table.insert(recent_files, relative_path)
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

	mini_pick.registry.files_git_changes = function()
		local command = {
			"git",
			"ls-files",
			"-t",
			"--exclude-standard",
			"--modified",
			-- "--deleted", --- Unsupported for now
			"--others",
		}
		return mini_pick.builtin.cli({
			command = command,
			postprocess = function(output)
				return vim.tbl_map(
					function(line)
						return {
							git_status = string.sub(line, 1, 1),
							file_path = string.sub(line, 3),
						}
					end,
					vim.tbl_filter(function(line)
						return line ~= ""
					end, output)
				)
			end,
		}, {
			source = {
				name = "files_git_changes",
				show = function(buf, items, query)
					local paths = vim.tbl_map(function(item)
						return item.file_path
					end, items)

					mini_pick.default_show(buf, paths, query, {
						show_icons = true,
						icon_affix = function(l)
							local item = vim.iter(items):find(function(item)
								return item.file_path == l
							end)

							local affix = {
								text = "[" .. item.git_status .. "]",
							}

							if item.git_status == "C" then
								affix.hl_group = "DiagnosticWarn"
							end
							if item.git_status == "?" then
								affix.hl_group = "DiagnosticOk"
							end
							if item.git_status == "R" then
								affix.hl_group = "DiagnosticError"
							end

							return affix
						end,
					})
				end,
				preview = function(buf_id, item)
					mini_pick.default_preview(buf_id, item.file_path)
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
				choose = function(theme)
					vim.cmd.colorscheme(theme)
				end,
			},
		})

		if result == nil then
			vim.cmd.colorscheme(original_theme)
		end
	end

	keymap.set_multiple({
		{
			"n",
			"<Leader>s:",
			mini_pick.registry.commands,
			{ desc = "Commands" },
		},
		{ "n", "<leader>s?", mini_pick.registry.help, { desc = "Help" } },
		{ "n", "<Leader>sp", mini_pick.registry.pickers, { desc = "Pickers" } },

		{ "n", "<leader>sb", mini_pick.registry.buffers, { desc = "Buffers" } },

		{
			"n",
			"<leader>sf",
			mini_pick.registry.files_recent,
			{ desc = "Files" },
		},
		{
			"n",
			"<leader>sF",
			mini_pick.registry.files_including_hidden,
			{ desc = "Files (hidden)" },
		},

		{
			"n",
			"<leader>sg",
			mini_pick.registry.grep_live,
			{ desc = "Grep (live)" },
		},

		{
			"n",
			"<Leader>ss",
			"<Cmd>Telescope lsp_document_symbols<CR>",
			{ desc = "Symbols" },
		},
		{
			"n",
			"<Leader>sS",
			"<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
			{ desc = "Symbols (workspace)" },
		},
	})
end

M.setup = function()
	setup_telescope() --- Migrating away from Telescope
	setup_pickers()
end

return M
