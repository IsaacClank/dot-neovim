local M = {}

local function bootstrap_mini()
	local package_path = vim.fs.joinpath(vim.fn.stdpath("data"), "site")

	local mini_path = vim.fs.joinpath(package_path, "pack", "deps", "start", "mini.nvim")
	local mini_path_exists = vim.loop.fs_stat(mini_path)
	if not mini_path_exists then
		vim.notify("Installing mini.nvim", vim.log.levels.INFO)
		local clone_mini_cmd = {
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/nvim-mini/mini.nvim",
			mini_path,
		}
		vim.system(clone_mini_cmd)
		vim.cmd("packadd mini.nvim | helptags ALL")
		vim.notify("Installed mini.nvim", vim.log.levels.INFO)
	end
	require("mini.deps").setup({ path = { package = package_path } })
end

M.setup = function()
	if vim.g.vscode == 1 then
		vim.g.clipboard = vim.g.vscode_clipboard
		return
	end

	bootstrap_mini()

	require("my.basic").setup()

	require("my.theme").setup()
	-- require("my.dashboard").setup()
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
