local mod = {}
mod.setup = function()
	vim.pack.add({
		"https://github.com/ibhagwan/fzf-lua",
	})

	vim.schedule(function()
		local fzf = require("fzf-lua")
		local fzf_config = require("fzf-lua.config")

		fzf.setup({
			file_icon_padding = " ",
			fzf_opts = {
				["--tabstop"] = 4,
			},
		})

		fzf.files_config = function(opts)
			opts = opts or {}
			fzf.files({
				cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack"),
				fd_opts = fzf_config.defaults.files.fd_opts
					.. [[ --full-path --glob **/{plugin,lua}/**/*.lua ]],
				rg_opts = fzf_config.defaults.files.rg_opts
					.. [[ --glob=**/{plugin,lua}/**/*.lua ]],
			})
		end
	end)
end

return mod
