local nf = require('neoframe')

local function configure_lua()
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

nf.setup(function()

  NF_INTELLISENSE = {
    treesitter_modules = { "lua" },
    lsp_servers = { "sumneko_lua" },
    sumneko_lua = configure_lua(),
  }
end)
