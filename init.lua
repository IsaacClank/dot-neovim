local nf = require('neoframe')
local nf_event = require('neoframe.lib.event')

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

local function configure_omnisharp()
  local pid = vim.fn.getpid()
  local omnisharp_bin = "/home/tpht/.local/share/nvim/lsp_servers/omnisharp/omnisharp/OmniSharp"

  return {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) }
  }
end

nf.setup(function()
  NF_INTELLISENSE = {
    treesitter_modules = { "lua", "typescript", "tsx", "c_sharp", "php", "json", "html", "scss", "yaml" },
    lsp_servers = { "sumneko_lua", "tsserver", "omnisharp", "intelephense", "phpactor", "jsonls", "angularls", "eslint", "cssls", "cssmodules_ls", "yamlls" },

    angularls = {},
    cssls = {},
    cssmodules_ls = {},
    eslint = {},
    intelephense = {},
    jsonls = {},
    omnisharp = configure_omnisharp(),
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

  nf.blocks.add({
    spec = { "ggandor/lightspeed.nvim", requires = "tpope/vim-repeat" },
  })

  nf.blocks.add({
    config = function()
      nf_event.on(nf_event.EVENT_BUF_ENTER, function()
        vim.opt.expandtab = false
      end, { pattern = "*.php" })
    end
  })

end)
