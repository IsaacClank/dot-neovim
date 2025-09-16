local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'kdheepak/lazygit.nvim',
    checkout = 'main'
  })
  vim.keymap.set('n', '<Leader>gg', '<Cmd>LazyGit<CR>', { desc = 'Dashboard' })

  deps.add({
    source = 'lewis6991/gitsigns.nvim',
    checkout = 'v1.0.2'
  })
  require('gitsigns').setup({
    numhl = true,
    current_line_blame = true,
    current_line_blame_opts = { delay = 300 },
    diff_opts = {
      algorithm = 'histogram',
      vertical = true,
      ignore_whitespace = true,
    }
  })

  vim.keymap.set('n', "<Leader>gn", ":Gitsigns nav_hunk 'next' preview=true<CR>", { desc = "Next hunk", })
  vim.keymap.set('n', "<Leader>gp", ":Gitsigns nav_hunk 'prev' preview=true<CR>", { desc = "Previous hunk", })
  vim.keymap.set('x', "<Leader>gs", ":'<,'>Gitsigns stage_hunk<CR>", { desc = "Stage/Unstage hunk", })
  vim.keymap.set('x', "<Leader>gr", ":'<,'>Gitsigns reset_hunk<CR>", { desc = "Reset hunk", })
  vim.keymap.set(
    'n',
    '<Leader>gd',
    function()
      vim.cmd([[tabnew %]])
      require('gitsigns').diffthis(nil, { split = 'leftabove' })
    end,
    { desc = 'File diff' }
  )
end

return M
