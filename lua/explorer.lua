local minideps = require('mini.deps')

local M = {}
M.setup = function()
  minideps.add({
    source = 'nvim-tree/nvim-tree.lua',
    checkout = 'v1.14.0',
  })

  require('nvim-tree').setup({
    view = {
      float = { enable = true },
    }
  })

  vim.keymap.set('n', '<Leader>ee', "<Cmd>NvimTreeToggle<CR>", { desc = 'Open explorer' })
  vim.keymap.set('n', '<Leader>ef', "<Cmd>NvimTreeFindFileToggle<CR>", { desc = 'Open explorer at current file' })
end
return M
