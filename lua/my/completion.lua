local M = {}

local setup_blink = function()
	local function build_blink(params)
		vim.notify("Building blink.cmp", vim.log.levels.INFO)
		local obj = vim.system(
			{ "cargo", "build", "--release" },
			{ cwd = params.path }
		)
			:wait()
		if obj.code == 0 then
			vim.notify("Building blink.cmp done", vim.log.levels.INFO)
		else
			vim.notify("Building blink.cmp failed", vim.log.levels.ERROR)
		end
	end

	vim.pack.add({
		{
			src = "https://github.com/saghen/blink.cmp",
			version = vim.version.range("^1.10.2"),
			hooks = {
				post_install = build_blink,
				post_checkout = build_blink,
			},
		},
		"https://github.com/mikavilpas/blink-ripgrep.nvim",
		"https://github.com/rafamadriz/friendly-snippets",
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(event)
			local name, kind = event.data.spec.name, event.data.kind
			if
				name == "blink.cmp"
				and (kind == "install" or kind == "update")
			then
				build_blink()
			end
		end,
	})

	vim.schedule(function()
		vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { link = "PmenuMatch" })

		require("blink.cmp").setup({
			keymap = { preset = "super-tab" },
			completion = {
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "ripgrep" },
				providers = {
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						transform_items = function(_, items)
							return vim.tbl_filter(function(item)
								return item.kind
									~= require("blink.cmp.types").CompletionItemKind.Keyword
							end, items)
						end,
					},
					ripgrep = {
						module = "blink-ripgrep",
						async = true,
						max_items = 3,
						min_keyword_length = 5,
						score_offset = -8,
					},
				},
			},
		})
	end)
end

M.setup = function()
	vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
	vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
	vim.o.complete = ".,w,b,u"
	setup_blink()
	-- setup_mini_completion()
end

return M
