local M = {}

M.setup = function()
  require('mini.basics').setup({
    options = { extra_ui = true },
    mappings = { move_with_alt = true }
  })
  require('mini.pairs').setup({})
  require('mini.surround').setup({})
end

return M
