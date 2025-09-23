local deps = require('mini.deps')

local M = {}
M.setup = function()
  deps.add({
    source = 'nvim-tree/nvim-tree.lua',
    checkout = 'v1.14.0',
    depends = { 'nvim-tree/nvim-web-devicons' }
  })

  require('nvim-tree').setup({
    view = {
      float = {
        enable = true,
        open_win_config = {
          width = 60,
        }
      },
    },
  })

  vim.keymap.set(
    'n', '<Leader>ee', '<Cmd>NvimTreeToggle<CR>',
    { desc = 'Open explorer' }
  )
  vim.keymap.set(
    'n', '<Leader>ef', '<Cmd>NvimTreeFindFileToggle<CR>',
    { desc = 'Open explorer at current file' }
  )
end
return M
