local setup_lsp__denols = function()
	vim.lsp.enable("denols")
end

local setup_lsp__jsonls = function()
	vim.lsp.enable("jsonls")
end

local setup_lsp__lua_ls = function()
	vim.lsp.config("lua_ls", {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (
						vim.loop.fs_stat(path .. "/.luarc.json")
						or vim.loop.fs_stat(path .. "/.luarc.jsonc")
					)
				then
					return
				end
			end

			client.config.settings.Lua =
				vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
					},
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
					},
					workspace = {
						checkThirdParty = false,
						library = vim.tbl_extend(
							"keep",
							{ vim.env.VIMRUNTIME },
							vim.api.nvim_get_runtime_file(
								"lua/lspconfig",
								false
							)
							-- vim.api.nvim_get_runtime_file(
							-- 	"pack/**/{start,opt}/**/{lua,plugin}",
							-- 	true
							-- )
						),
					},
				})
		end,
		settings = {
			Lua = {},
		},
	})
	vim.lsp.enable("lua_ls")
end

local setup_lsp__rust_analyzer = function()
	vim.lsp.enable("rust_analyzer")
end

local setup_lsp__ts_ls = function()
	vim.lsp.enable("ts_ls")
end

local mod = {}
mod.setup = function()
	vim.pack.add({
		{
			src = "https://github.com/neovim/nvim-lspconfig",
			version = vim.version.range("^2.7.0"),
		},
	})

	vim.schedule(function()
		setup_lsp__denols()
		setup_lsp__jsonls()
		setup_lsp__lua_ls()
		setup_lsp__rust_analyzer()
		setup_lsp__ts_ls()

		vim.keymap.set("n", "<Leader>lk", vim.lsp.buf.hover, { desc = "Hover" })
		vim.keymap.set(
			"n",
			"<Leader>lK",
			vim.diagnostic.open_float,
			{ desc = "Hover diagnostic" }
		)

		vim.keymap.set(
			"n",
			"<Leader>ln",
			vim.lsp.buf.rename,
			{ desc = "Rename" }
		)
	end)
end
return mod
