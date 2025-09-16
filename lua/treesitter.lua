local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = { post_checkout = function() vim.cmd [[TSUpdate]] end }
  })

  require('nvim-treesitter').setup({
    auto_install = true,
    ensure_installed = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline" },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })
end

return M
