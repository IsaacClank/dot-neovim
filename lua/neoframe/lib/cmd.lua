local box = require("neoframe.lib.box")

---Wrapper over Neovim's user-command api
local mod = {}

---Create a new command
function mod.create(arg1, arg2)
  local cmd_name = box(arg1):is_a("string"):open()
  local func = box(arg2):is_a("function"):open()

  vim.api.nvim_create_user_command(cmd_name, func, {})
end

return mod
