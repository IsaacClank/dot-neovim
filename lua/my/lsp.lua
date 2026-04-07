local deps = require("mini.deps")
local keymap = require("my.lib.keymap")

local M = {}

local setup_lsp__denols = function()
	-- vim.lsp.config("denols", {})
	vim.lsp.enable("denols")
end

local setup_lsp__jsonls = function()
	-- vim.lsp.config("jsonls", {})
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
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						},
					},
				})
		end,
		settings = {
			Lua = {},
		},
	})
	vim.lsp.enable("lua_ls")
end

local setup_lsp__ts_ls = function()
	vim.lsp.enable("ts_ls")
end

local setup_lsp = function()
	deps.later(function()
		setup_lsp__denols()
		setup_lsp__jsonls()
		setup_lsp__lua_ls()
		setup_lsp__ts_ls()

		keymap.set_multiple({
			{
				"n",
				"<Leader>la",
				vim.lsp.buf.code_action,
				{ desc = "Code Action" },
			},
			{
				"n",
				"<Leader>ld",
				vim.lsp.buf.definition,
				{ desc = "Definitions" },
			},
			{
				"n",
				"<Leader>li",
				vim.lsp.buf.implementation,
				{ desc = "Implementations" },
			},

			{ "n", "<Leader>lk", vim.lsp.buf.hover, { desc = "Hover" } },
			{
				"n",
				"<Leader>lK",
				vim.diagnostic.open_float,
				{ desc = "Hover diagnostic" },
			},

			{ "n", "<Leader>ln", vim.lsp.buf.rename, { desc = "Rename" } },
			{
				"n",
				"<Leader>lr",
				vim.lsp.buf.references,
				{ desc = "References" },
			},
		})
	end)
end

M.setup = function()
	deps.add({
		source = "neovim/nvim-lspconfig",
		checkout = "v2.7.0",
	})

	setup_lsp()
end

return M
