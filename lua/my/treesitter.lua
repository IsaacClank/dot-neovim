local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = { post_checkout = function() vim.cmd [[TSUpdate]] end }
  })

  deps.later(function()
    require('nvim-treesitter').setup({
      auto_install = true,
    })
  end)
end

return M
