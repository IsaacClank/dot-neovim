local mod = {}

function mod.setup()
	local is_vscode = vim.g.vscode == 1
	if is_vscode then
		vim.g.clipboard = vim.g.vscode_clipboard
		return
	end

	local is_wsl = vim.fn.system("uname -a"):lower():find("microsoft") ~= nil
	if is_wsl then
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

	require("my.core.ui").setup()
	require("my.core.options").setup()
	require("my.core.editing").setup()
	require("my.core.pack").setup()
	require("my.core.terminal").setup()

	require("my.statusline").setup()
	require("my.explorer").setup()
	require("my.session").setup()

	require("my.navigation").setup()
	require("my.lsp").setup()
	require("my.formatting").setup()
	require("my.completion").setup()
	require("my.git").setup()

	require("my.bindings").setup()
end

return mod
