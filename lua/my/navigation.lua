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
					mini_pick.default_match(stritems, indices, query)
				end,
			},
		})
	end

	---@class Item
	---@field type string
	---@field path string
	---@field path_old string|nil
	---@field git_status_tag string
	---@field text string
	mini_pick.registry.files_git_changes = function()
		---@param output table<any, string>
		---@return table<Item>
		local parse_command_output = function(output)
			return vim
				.iter(output)
				---@param line string
				:filter(function(line)
					return line ~= ""
				end)
				---@param line string
				:map(function(line)
					local type = "file"
					local path = nil
					local path_old = nil
					local text = nil
					local git_status_tag =
						string.format("[%s]", vim.trim(string.sub(line, 1, 3)))

					if git_status_tag == "[R]" then
						_, path_old, path =
							line:match("^(%a)%s+(%S+)%s+%->%s+(%S+)$")
						text = string.format(
							"%s -> %s %s",
							path_old,
							path,
							git_status_tag
						)
					else
						path = vim.trim(string.sub(line, 4))
						text = string.format("%s %s", path, git_status_tag)
					end

					return {
						type = type,
						path = path,
						path_old = path_old,
						git_status_tag = git_status_tag,
						text = text,
					}
				end)
				:totable()
		end

		---@param buf_id integer
		---@param items table<any, Item>
		---@param query string
		local custom_show = function(buf_id, items, query)
			mini_pick.default_show(buf_id, items, query, {
				show_icons = true,
			})

			local ns_id = vim.api.nvim_create_namespace("")
			local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

			for i, item in ipairs(items) do
				local row = i - 1 -- 0-based

				local prefix_len = lines[i]:len() - item.text:len()
				local col = prefix_len + item.path:len() + 1
				if item.path_old ~= nil then
					col = col + item.path_old:len() + 4
				end
				local col_end = prefix_len + item.text:len() -- 0-based and exclusive

				local highlight_group = nil
				if
					item.git_status_tag == "[M]"
					or item.git_status_tag == "[MM]"
					or item.git_status_tag == "[R]"
				then
					highlight_group = "DiagnosticWarn"
				end
				if
					item.git_status_tag == "[??]"
					or item.git_status_tag == "[A]"
				then
					highlight_group = "DiagnosticOk"
				end
				if item.git_status_tag == "[D]" then
					highlight_group = "DiagnosticError"
				end

				vim.api.nvim_buf_set_extmark(buf_id, ns_id, row, col, {
					hl_mode = "replace",
					priority = 200,
					hl_group = highlight_group,
					end_row = row,
					end_col = col_end,
				})
			end
		end

		return mini_pick.builtin.cli({
			command = { "git", "status", "--short" },
			postprocess = parse_command_output,
		}, {
			source = {
				name = "files_git_changes",
				show = custom_show,
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
