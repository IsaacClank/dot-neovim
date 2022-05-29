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
    treesitter_modules = { "lua", "typescript", "tsx", "c_sharp", "php", "json", "html", "scss", "yaml" },
    lsp_servers = { "sumneko_lua", "tsserver", "omnisharp", "intelephense", "phpactor", "jsonls", "angularls", "eslint", "cssls", "cssmodules_ls", "yamlls" },

    angularls = {},
    cssls = {},
    cssls = {},
    cssmodules_ls = {},
    eslint = {},
    intelephense = {},
    jsonls = {},
    omnisharp = {},
    phpactor = {},
    sumneko_lua = configure_lua(),
    tsserver = {},
    yamlls = {}
  }

  nf.blocks.add({
    spec = { "beauwilliams/focus.nvim" },

    config = function()
      require("focus").setup({
        enable = true,
        excluded_filetypes = { "toggleterm" }
      })
    end
  });

end)
