local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.now(function()
    require('mini.basics').setup({
      options = { extra_ui = true },
      mappings = { move_with_alt = true }
    })
  end)

  deps.later(function()
    require('mini.pairs').setup({})
    require('mini.surround').setup({})
  end)
end

return M
