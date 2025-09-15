local M = {}

M.setup = function()
  local mini_notify = require('mini.notify')
  mini_notify.setup({})
  vim.api.nvim_create_user_command(
    'NotificationHistory',
    function(_)
      vim.cmd [[tabnew]]
      vim.api.nvim_create_buf(false, true)
      mini_notify.show_history()
    end,
    {}
  )
end

return M
