local mod = {}
mod.setup = function()
	vim.pack.add({
		"https://github.com/nvim-mini/mini.pick",
		"https://github.com/nvim-mini/mini.extra",
	})

	vim.schedule(function()
		local mini_pick = require("mini.pick")
		local mini_extra = require("mini.extra")

		mini_pick.setup()
		vim.api.nvim_del_user_command("Pick")
		mini_extra.setup()

		mini_pick.registry.pickers = function()
			mini_pick.start({
				source = {
					items = function()
						local pickers = vim.tbl_keys(mini_pick.registry)
						table.sort(pickers)
						return pickers
					end,
					choose = function(picker)
						vim.schedule(function()
							vim.tbl_get(mini_pick.registry, picker)()
						end)
					end,
				},
			})
		end

		mini_pick.registry.config = function()
			local command = {
				"rg",
				"--color=never",
				"--files",
				"--glob=**/{plugin,lua}/**/*.lua",
				vim.fs.dirname(vim.env.MYVIMRC),
				vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack"),
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

		mini_pick.registry.files_all = function()
			return mini_pick.registry.files({ hidden = true, no_ignore = true })
		end

		---@class Item
		---@field type string
		---@field path string
		---@field path_old string|nil
		---@field git_status_tag string
		---@field text string
		mini_pick.registry.git_status = function()
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
							string.sub(line, 1, 3):gsub("%s+$", "") -- Trim end

						if git_status_tag == "R" then
							_, path_old, path =
								line:match("^(%a)%s+(%S+)%s+%->%s+(%S+)$")
							text = string.format(
								"%-2s %s -> %s",
								git_status_tag,
								path_old,
								path
							)
						else
							path = vim.trim(string.sub(line, 4))
							text =
								string.format("%-2s %s", git_status_tag, path)
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
					show_icons = false,
				})

				local ns_id = vim.api.nvim_create_namespace("")
				local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

				for i, item in ipairs(items) do
					local prefix_len = lines[i]:len() - item.text:len()
					local status_len = 2

					local row = i - 1 -- 0-based
					local col = prefix_len
					local col_end = prefix_len + status_len -- 0-based and exclusive

					local highlight_group = nil
					if
						item.git_status_tag == "A"
						or item.git_status_tag == "M"
						or item.git_status_tag == "D"
						or item.git_status_tag == "R"
					then
						highlight_group = "DiagnosticOk"
					elseif
						item.git_status_tag == "??"
						or item.git_status_tag == " D"
						or item.git_status_tag == " M"
					then
						highlight_group = "DiagnosticError"
					elseif
						item.git_status_tag == "AM"
						or item.git_status_tag == "MM"
					then
						highlight_group = "DiagnosticMixed"
					end

					if highlight_group == "DiagnosticMixed" then
						vim.api.nvim_buf_set_extmark(buf_id, ns_id, row, col, {
							hl_mode = "replace",
							priority = 200,
							hl_group = "DiagnosticOk",
							end_row = row,
							end_col = col_end - 1,
						})
						vim.api.nvim_buf_set_extmark(
							buf_id,
							ns_id,
							row,
							col + 1,
							{
								hl_mode = "replace",
								priority = 200,
								hl_group = "DiagnosticError",
								end_row = row,
								end_col = col_end,
							}
						)
					else
						vim.api.nvim_buf_set_extmark(buf_id, ns_id, row, col, {
							hl_mode = "replace",
							priority = 200,
							hl_group = highlight_group,
							end_row = row,
							end_col = col_end,
						})
					end
				end
			end

			return mini_pick.builtin.cli({
				command = { "git", "status", "--short" },
				postprocess = parse_command_output,
			}, {
				source = {
					name = "files_git_changes",
					show = custom_show,
					preview = function(buf, item, opts)
						local lines = vim.split(
							vim.system({ "git", "diff", item.path })
								:wait().stdout,
							"\n"
						)
						vim.api.nvim_set_option_value(
							"filetype",
							"diff",
							{ buf = buf }
						)
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					end,
				},
				mappings = {
					stage = {
						char = "<C-i>",
						func = function()
							local matches = mini_pick.get_picker_matches()
							local current_index =
								vim.tbl_get(matches, "current_ind")

							vim.notify("Current index: " .. current_index)

							local path = vim.tbl_get(matches, "current", "path")
							vim.system({ "git", "add", path }):wait()

							mini_pick.set_picker_items_from_cli(
								{ "git", "status", "--short" },
								{ postprocess = parse_command_output }
							)
							mini_pick.set_picker_match_inds(
								{ current_index },
								"current"
							)

							vim.notify(
								vim.inspect(
									vim.tbl_get(
										mini_pick.get_picker_matches(),
										"current_ind"
									)
								)
							)
						end,
					},
					unstage = {
						char = "<C-o>",
						func = function()
							local matches = mini_pick.get_picker_matches()
							local current_index =
								vim.tbl_get(matches, "current_ind")
							local item = vim.tbl_get(matches, "current")

							local path = vim.tbl_get(item, "path")
							local path_old = vim.tbl_get(item, "path_old")

							vim.system({
								"git",
								"restore",
								"--staged",
								path,
							}):wait()
							if path_old ~= nil and #path_old > 0 then
								vim.system({
									"git",
									"restore",
									"--staged",
									path_old,
								}):wait()
							end

							mini_pick.set_picker_items_from_cli(
								{ "git", "status", "--short" },
								{ postprocess = parse_command_output }
							)
							mini_pick.set_picker_match_inds(
								{ current_index },
								"current"
							)
						end,
					},
				},
			})
		end

		vim.api.nvim_create_user_command("MiniPick", function(args)
			if #args.args == 0 then
				mini_pick.registry.pickers()
			else
				mini_pick.registry[args.args]()
			end
		end, {
			desc = "MiniPick",
			nargs = "?",
			complete = function()
				return vim.tbl_keys(mini_pick.registry)
			end,
		})
	end)
end
return mod
