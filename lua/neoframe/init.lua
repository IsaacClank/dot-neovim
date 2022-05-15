local event = require("neoframe.lib.event")
local plugger = require("neoframe.plugger")
local box = require("neoframe.lib.box")

require("neoframe.commands")
plugger.init()

--- Configuration framework for Neovim
local M = {}

M.blocks = require("neoframe.blocks")

function M.setup(arg)
  M.blocks.add(require("neoframe.blocks.core"))
  M.blocks.add(require("neoframe.blocks.basic"))
  M.blocks.add(require("neoframe.blocks.git"))
  M.blocks.add(require("neoframe.blocks.telescope"))
  M.blocks.add(require("neoframe.blocks.intellisense"))

  require("neoframe.globals")
  box(arg):is_a("function"):open()()

  for _, block in ipairs(M.blocks.get()) do
    plugger.add(block.spec)
  end

  event.on(event.EVENT_VIM_ENTER, function()
    if plugger.is_first_time_setup then
      plugger.sync()
    else
      M.blocks.configure_all()
    end
  end, { once = true })

  plugger.on_sync_post(function()
    M.blocks.configure_all()
  end)
end

return M
