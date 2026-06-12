local mod = {}

function mod.setup()
	vim.api.nvim_create_user_command("PackUpdate", function(args)
		vim.pack.update(vim.tbl_count(args.fargs) > 0 and args.fargs or nil)
	end, {
		desc = "Update plugins",
		nargs = "*",
		complete = function()
			return vim.tbl_map(function(pack)
				return vim.tbl_get(pack, "spec", "name")
			end, vim.pack.get())
		end,
	})

	vim.api.nvim_create_user_command("PackClean", function()
		local inactive_plugin_names = {}

		for _, plugin in ipairs(vim.pack.get()) do
			if not plugin.active then
				table.insert(inactive_plugin_names, plugin.spec.name)
			end
		end

		vim.pack.del(inactive_plugin_names)
	end, { desc = "Remove inactive plugins" })
end

return mod
