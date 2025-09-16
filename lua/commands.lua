local M = {}

M.setup = function()
  vim.api.nvim_create_user_command('ReloadConfig', [[:source $MYVIMRC<CR>]], { desc = 'Reload configuration' })
end

return M
