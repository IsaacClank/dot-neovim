local box = require("neoframe.lib.box")

---Module for working with autocomands
local mod = {}

mod.EVENT_USER = "User"
mod.EVENT_VIM_ENTER = "VimEnter"
mod.EVENT_BUF_ENTER = "BufEnter"

---Register an event listener
--@see `:h autocmd`
--@see `:h nvim_create_autocmd`
function mod.on(arg1, arg2, arg3)
  local eventName = box(arg1):is_a("string"):open()
  local callback = box(arg2):is_a("function"):open()
  local opts = box(arg3):is_a("table"):open_or_default({})

  opts.callback = callback

  vim.api.nvim_create_autocmd(eventName, opts)
end

---Trigger execution of event handlers
--@see `:h doautocmd`
--@see `:h nvim_exec_autocmds`
function mod.trigger(arg1, arg2)
  local eventName = box(arg1):is_a("string"):open()
  local opts = box(arg2):is_a("table"):open()

  vim.api.nvim_exec_autocmds(eventName, opts)
end

---Register a listener for User events
--@see `:h User`
function mod.on_user(arg1, arg2, arg3)
  local pattern = box(arg1):is_a("string"):open()
  local callback = box(arg2):is_a("function"):open()
  local opts = box(arg3):is_a("table"):open_or_default({})
  opts.pattern = pattern

  mod.on(mod.EVENT_USER, callback, opts)
end

---Trigger User events
--@see `:h User`
function mod.trigger_user(arg)
  local pattern = box(arg):is_a("string"):open()

  mod.trigger(mod.EVENT_USER, { pattern = pattern })
end

return mod
