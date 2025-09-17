local M = {}

M.setup = function()
  require('mini.deps').now(function()
    require('mini.statusline').setup({
      use_icons = true
    })
  end)
end

return M
