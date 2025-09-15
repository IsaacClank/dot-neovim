-- mini.deps bootstrap & initialization
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
-- Set up 'mini.deps' (customize to your liking)
local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })

require('options').setup()
require('theme').setup()

require('mini.basics').setup({})
require('mini.pairs').setup({})
require('mini.surround').setup({})

require('explorer').setup()
require('statusline').setup()
require('notification').setup()

require('navigation').setup()
require('lsp').setup()
require('git').setup()

vim.keymap.set('n', '<M-Up>', function() vim.cmd [[resize +5]] end, { desc = "Increase height" })
vim.keymap.set('n', '<M-Down>', function() vim.cmd [[resize -5]] end, { desc = "Decrease height" })
vim.keymap.set('n', '<M-Right>', function() vim.cmd [[vertical resize +5]] end, { desc = "Increase height" })
vim.keymap.set('n', '<M-Left>', function() vim.cmd [[vertical resize -5]] end, { desc = "Decrease height" })

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- `g` key
    { mode = 'n', keys = 'g' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
  },
  clues = {
    { mode = 'n', keys = '<Leader>e', desc = '+Explorer' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>l', desc = '+Intellisense' },
    { mode = 'n', keys = '<Leader>s', desc = '+Navigation' },

    miniclue.gen_clues.g(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 200,
    config = {
      width = 'auto'
    }
  }
}
)
