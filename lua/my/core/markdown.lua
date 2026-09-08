local M = {}

function M.setup()
	vim.pack.add({
		-- 'https://github.com/nvim-treesitter/nvim-treesitter',
		-- 'https://github.com/nvim-mini/mini.nvim',            -- if you use the mini.nvim suite
		-- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
		-- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
		-- "https://github.com/MeanderingProgrammer/render-markdown.nvim",
		{
			name = "markdown-preview.nvim",
			src = "https://github.com/iamcco/markdown-preview.nvim",
		},
	})

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(event)
			if event.data.spec.name == "markdown-preview.nvim" then
				vim.fn["mkdp#util#install"]()
			end
		end,
	})
end

return M
