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

  require('mini.indentscope').setup({
    draw = {
      animation = require('mini.indentscope').gen_animation.linear({ duration = 5 })
    }
  })

  deps.now(function()
    local themes = {
      { name = "catppuccin", },
      { name = "catppuccin-frappe", },
      { name = "catppuccin-macchiato", },
      { name = "catppuccin-mocha", },
      { name = "everforest" },
      { name = "kanagawa" },
      { name = "kanagawa-dragon" },
      { name = "kanagawa-wave" },
      { name = "monokai" },
      { name = "monokai_pro" },
      { name = "monokai_ristretto" },
      { name = "monokai_soda" },
      { name = "moonfly" },
      { name = "onedark" },
      { name = "onedark_dark" },
      { name = "onedark_vivid" },
      { name = "rose-pine-main" },
      { name = "rose-pine-moon" },
      { name = "tokyonight" },
      { name = "tokyonight-moon" },
      { name = "tokyonight-night" },
      { name = "tokyonight-storm" },
      { name = "vague" },
      { name = "vscode" },
    }

    math.randomseed(os.time())
    local random_theme = vim.tbl_get(themes, math.random(1, vim.tbl_count(themes)))
    local random_theme_name = vim.tbl_get(random_theme, "name")
    local random_theme_setup = vim.tbl_get(random_theme, "setup")
    if random_theme_setup ~= nil then
      random_theme_setup()
    end
    vim.cmd('colorscheme ' .. random_theme_name)
  end)
end
return M
