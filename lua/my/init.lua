local M = {}

local function bootstrap_mini()
	local path_package = vim.fn.stdpath("data") .. "/site/"
	local mini_path = path_package .. "pack/deps/start/mini.nvim"
	if not vim.loop.fs_stat(mini_path) then
		vim.cmd('echo "Installing `mini.nvim`" | redraw')
		local clone_cmd = {
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/nvim-mini/mini.nvim",
			mini_path,
		}
		vim.fn.system(clone_cmd)
		vim.cmd("packadd mini.nvim | helptags ALL")
		vim.cmd('echo "Installed `mini.nvim`" | redraw')
	end
	require("mini.deps").setup({ path = { package = path_package } })
end

M.setup = function()
	if vim.g.vscode == 1 then
		vim.g.clipboard = vim.g.vscode_clipboarg
		return
	end

	bootstrap_mini()

	require("my.basic").setup()

	require("my.theme").setup()
	require("my.dashboard").setup()
	require("my.statusline").setup()
	require("my.explorer").setup()
	require("my.notification").setup()
	require("my.session").setup()

	require("my.navigation").setup()
	require("my.treesitter").setup()
	require("my.lsp").setup()
	require("my.formatting").setup()
	require("my.completion").setup()
	require("my.git").setup()

	require("my.extras").setup()
	require("my.commands").setup()
	require("my.bindings").setup()
end

return M
