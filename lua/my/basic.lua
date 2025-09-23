local keymap = require('my.lib.keymap')
local deps = require('mini.deps')

local M = {}

local setup_leap = function()
  deps.add({
    source = 'ggandor/leap.nvim',
    checkout = 'main',
  })

  deps.later(function()
    require('leap').setup({})
    keymap.set_multiple({
      { 'n', 'gl', '<Plug>(leap-forward)',  { desc = 'Leap forward' } },
      { 'n', 'gL', '<Plug>(leap-backward)', { desc = 'Leap backward' } }
    })
  end)
end

local setup_pairs = function()
  deps.later(function()
    require('mini.pairs').setup({})
  end)
end

local setup_surround = function()
  deps.later(function()
    require('mini.surround').setup({})
  end)
end

M.setup = function()
  vim.o.scrolloff = 10       -- Minimum lines offset on top and bottom. Used to add padding.
  vim.o.expandtab = true     -- In insert mode, expand tabs into spaces.
  vim.o.shiftwidth = 2       -- Number of spaces used for auto-indent.
  vim.o.tabstop = 2          -- Number of spaces to render tabs in a file. This does **not** modify the file.
  vim.o.termguicolors = true -- Enable 24-bit RGB colors
  vim.o.winborder = 'single' -- Default floating window border

  vim.g.loaded_node_provider = 0;
  vim.g.loaded_perl_provider = 0;
  vim.g.loaded_python3_provider = 0;
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  require('mini.basics').setup({
    options = { extra_ui = true },
    mappings = { move_with_alt = true }
  })

  setup_pairs()
  setup_surround()
  setup_leap()
end

return M
