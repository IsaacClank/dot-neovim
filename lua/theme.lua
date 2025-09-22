local deps = require('mini.deps')
local M = {}

M.setup = function()
  deps.add('bluz71/vim-moonfly-colors')
  deps.add('catppuccin/nvim')
  deps.add('folke/tokyonight.nvim')
  deps.add('mofiqul/vscode.nvim')
  deps.add('olimorris/onedarkpro.nvim')
  deps.add('rebelot/kanagawa.nvim')
  deps.add('rose-pine/neovim')
  deps.add('sainnhe/everforest')
  deps.add('vague2k/vague.nvim')
  deps.add('tanvirtin/monokai.nvim')

  deps.now(function()
    require('mini.indentscope').setup({
      draw = {
        animation = require('mini.indentscope').gen_animation.linear({ duration = 5 })
      }
    })

    vim.cmd [[colorscheme catppuccin]]
  end)
end
return M
