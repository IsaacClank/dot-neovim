local deps = require('mini.deps')
local M = {}

M.setup = function()
  require('mini.indentscope').setup({
    draw = {
      animation = require("mini.indentscope").gen_animation.linear({ duration = 5 })
    }
  })
  require('mini.icons').setup({})
  require('mini.icons').mock_nvim_web_devicons()

  vim.cmd [[colo chalk]]
  -- vim.api.nvim_set_hl(0, 'Normal', { bg = 'None' })
  -- vim.api.nvim_set_hl(0, 'PmenuSel', { bg = 'NvimDarkGrey4', fg = 'None', reverse = false })
  -- vim.api.nvim_set_hl(0, 'PmenuMatch', { underline = true })
end
return M
