local cmd = require("neoframe.lib.cmd")
local const = require("neoframe.lib.const")
local plugger = require("neoframe.plugger")

cmd.create(const.CMD_SYNC_PLUGINS, function()
  plugger.sync()
end)

cmd.create(const.CMD_RELOAD_PLUGINS, function()
  plugger.reload()
end)
