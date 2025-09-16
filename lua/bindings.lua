local miniclue = require('mini.clue')

local M = {}

M.setup = function()
  vim.keymap.set('n', '<M-Up>', function() vim.cmd [[resize +5]] end, { desc = "Increase height" })
  vim.keymap.set('n', '<M-Down>', function() vim.cmd [[resize -5]] end, { desc = "Decrease height" })
  vim.keymap.set('n', '<M-Right>', function() vim.cmd [[vertical resize +5]] end, { desc = "Increase height" })
  vim.keymap.set('n', '<M-Left>', function() vim.cmd [[vertical resize -5]] end, { desc = "Decrease height" })

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
  })
end

return M
