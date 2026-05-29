local M = {}

M.setup = function()
	if vim.g.vscode == 1 then -- Running using VSCode's neovim extension
		vim.g.clipboard = vim.g.vscode_clipboard
		return
	elseif vim.fn.system("uname -a"):lower():find("microsoft") ~= nil then -- Running inside WSL
		vim.g.clipboard = {
			name = "wsl-clipboard",
			copy = {
				["+"] = "clip.exe",
				["*"] = "clip.exe",
			},
			paste = {
				["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
				["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			},
			cache_enabled = 0,
		}
	end

	vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

	require("my.basic").setup()

	require("my.theme").setup()
	require("my.statusline").setup()
	require("my.explorer").setup()
	require("my.session").setup()

	require("my.navigation").setup()
	require("my.lsp").setup()
	require("my.formatting").setup()
	require("my.completion").setup()
	require("my.git").setup()

	require("my.extras").setup()
	require("my.commands").setup()
	require("my.bindings").setup()

	vim.api.nvim_create_user_command("DepsClean", function()
		local inactive_plugin_names = {}

		for _, plugin in ipairs(vim.pack.get()) do
			if not plugin.active then
				table.insert(inactive_plugin_names, plugin.spec.name)
			end
		end

		vim.pack.del(inactive_plugin_names)
	end, { desc = "Remove inactive plugins" })
end

return M
