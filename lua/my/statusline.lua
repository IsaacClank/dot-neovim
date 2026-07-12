local conditionals = {}

conditionals.buf_readonly = function()
	local buf = vim.api.nvim_get_current_buf()
	return vim.api.nvim_get_option_value("readonly", { buf = buf })
end

conditionals.buf_not_readonly = function()
	return not conditionals.buf_readonly()
end

conditionals.buf_in_cwd = function()
	local cwd = vim.fn.getcwd()
	local buf = vim.api.nvim_get_current_buf()
	local buf_absolute_path = vim.api.nvim_buf_get_name(buf)
	return buf_absolute_path:sub(1, #cwd) == cwd
end

conditionals.buf_not_in_cwd = function()
	return not conditionals.buf_in_cwd()
end

local mod = {}
mod.setup = function()
	vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
	require("lualine").setup({
		sections = {
			lualine_a = {
				{ "mode", cond = conditionals.buf_not_readonly },
			},
			lualine_b = {
				{ "filename", path = 1 },
				"location",
				{ "diagnostics", cond = conditionals.buf_in_cwd },
			},
			lualine_c = { "searchcount" },

			lualine_x = {
				{ "diff", cond = conditionals.buf_in_cwd },
				{ "branch", cond = conditionals.buf_in_cwd },
			},
			lualine_y = { "lsp_status" },
			lualine_z = {},
		},
		extensions = { "toggleterm" },
	})
end
return mod
