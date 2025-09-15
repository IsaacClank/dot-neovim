local minideps = require('mini.deps')

local M = {}

M.setup = function()
  require('mini.indentscope').setup({
    draw = {
      animation = require("mini.indentscope").gen_animation.linear({ duration = 5 })
    }
  })
  require('mini.icons').setup({})
  require('mini.icons').mock_nvim_web_devicons()

  vim.cmd [[highlight Normal guibg=None]]
  vim.cmd [[highlight PmenuSel gui=None guibg=NvimDarkGrey4]]
  vim.cmd [[highlight PmenuMatch gui=None guifg=NvimLightGrey4]]
end
return M
