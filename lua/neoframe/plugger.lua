local box = require("neoframe.lib.box")
local event = require("neoframe.lib.event")

local function boostrap_packer()
  local packer_repo = "https://github.com/wbthomason/packer.nvim"
  local packer_installation_path = vim.fn.stdpath("data")
    .. "/site/pack/packer/start/packer.nvim"

  local is_first_time_setup = vim.fn.empty(
    vim.fn.glob(packer_installation_path)
  ) == 1

  if is_first_time_setup then
    print("Setting up plugins manager ...\n")

    vim.fn.system({
      "git",
      "clone",
      "--depth=1",
      packer_repo,
      packer_installation_path,
    })
    vim.cmd([[packloadall]])
  end

  return require("packer"), is_first_time_setup
end

---Wrapper over wbthomason/packer.nvim
local mod = {}

mod.EVENT_SYNC_POST = "PluggerSyncPost"

function mod.init()
  mod._packer, mod.is_first_time_setup = boostrap_packer()

  mod._packer.init({ disable_commands = true })
  mod._packer.reset()

  event.on_user("PackerCompileDone", function()
    event.trigger_user(mod.EVENT_SYNC_POST)
  end)
end

---Add a plugin specification
function mod.add(arg)
  local spec = box(arg):is_a("table"):open_or_default(nil)

  if spec ~= nil then
    mod._packer.use(spec)
  end
end

---Sync all managed plugins
function mod.sync()
  mod._packer.sync()
end

function mod.reload()
  mod._packer.compile()
end

function mod.on_sync_post(arg)
  local callback = box(arg):is_a("function"):open()

  event.on_user(mod.EVENT_SYNC_POST, callback)
end

return mod
