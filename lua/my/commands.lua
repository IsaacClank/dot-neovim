local buf = require('my.lib.buf')
local win = require('my.lib.win')
local mini_starter = require('mini.starter')

local M = {}

local setup_EditorClose = function()
  vim.api.nvim_create_user_command(
    'EditorClose',
    function(input)
      local is_last_focusable_win = win.win_is_last_focusable(0)
      local should_delete_buffer = buf.buf_win_count(0) == 1

      if is_last_focusable_win and not should_delete_buffer then
        error("Something unexpected happened")
      end

      if is_last_focusable_win then
        if buf.buf_is_modified() and not input.bang then
          vim.notify(
            'Cannot close the last window of a modified buffer',
            vim.log.levels.WARN
          )
          return
        end

        local buf_to_delete = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_delete(buf_to_delete, { force = input.bang })
        mini_starter.open()
        return
      end

      if should_delete_buffer then
        if buf.buf_is_modified() and not input.bang then
          vim.notify(
            'Cannot close the last window of a modified buffer',
            vim.log.levels.WARN
          )
          return
        end

        local buf_to_delete = vim.api.nvim_get_current_buf()
        if is_last_focusable_win then mini_starter.open() end
        vim.api.nvim_buf_delete(buf_to_delete, { force = input.bang })
        return
      end

      vim.api.nvim_win_close(0, input.bang)
    end,
    { desc = 'Close editor', bang = true }
  )
end

M.setup = function()
  setup_EditorClose()
end

return M
