local box = require("neoframe.lib.box")
local M = {}

M.__blocks = {}

function M.get()
  return M.__blocks
end

function M.add(arg)
  local mod = box(arg):is_a("table"):open()
  table.insert(M.__blocks, mod)
end

function M.configure_all()
  for _, block in ipairs(M.__blocks) do
    if block.config ~= nil then
      block.config()
    end
  end
end

return M
