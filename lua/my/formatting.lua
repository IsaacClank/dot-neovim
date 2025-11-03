local deps = require("mini.deps")

local M = {}

local typescript_formatters = function(bufnr)
	local formatters = {}
	local deno_root_dir = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
	if deno_root_dir ~= nil then
		formatters = { "deno_fmt" }
	else
		formatters = { "prettier" }
	end
	return vim.tbl_deep_extend("force", formatters, { stop_after_first = true })
end

M.setup = function()
	deps.add({
		source = "stevearc/conform.nvim",
		checkout = "v9.1.0",
	})

	deps.later(function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				css = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				prisma = { "prisma" },
				rust = { "rustfmt " },
				typescript = typescript_formatters,
				typescriptreact = typescript_formatters,
				markdown = { "prettier" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			formatters = {
				prisma = {
					command = "npx",
					args = { "prisma", "format", "--schema", "$FILENAME" },
					cwd = function()
						return vim.fs.root(0, { "package.json" })
					end,
					stdin = false,
					tmpfile_format = "$FILENAME.conform.tmp",
				},
			},
		})

		vim.keymap.set("n", "<Leader>lf", conform.format, { desc = "Format" })
	end)
end

return M
