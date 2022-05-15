local box = require("neoframe.lib.box")

---Wrapper over Neovim's mapping api
local mod = {}

mod.MODES = {
  "n",
  "v",
  "i",
}

mod.DEFAULT_OPTIONS = { silent = true, noremap = true }

function mod.map(arg1, arg2, arg3, arg4)
  local mode = box(arg1):is_a("string"):found_in(mod.MODES):open()
  local combination = box(arg2):is_a("string"):open()
  local invocation = box(arg3):is_a("string"):open()
  local opts = box(arg4):is_a("table"):open_or_default(mod.DEFAULT_OPTIONS)

  vim.api.nvim_set_keymap(mode, combination, invocation, opts)
end

function mod.nmap(arg1, arg2, arg3)
  return mod.map("n", arg1, arg2, arg3)
end

return mod
