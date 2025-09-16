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

require('mini.basics').setup({ options = { extra_ui = false }, mappings = { move_with_alt = true } })
require('mini.pairs').setup({})
require('mini.surround').setup({})

require('explorer').setup()
require('statusline').setup()
require('notification').setup()

require('navigation').setup()
require('treesitter').setup()
require('lsp').setup()
require('formatting').setup()
require('completion').setup()
require('git').setup()

require('commands').setup()
require('bindings').setup()
