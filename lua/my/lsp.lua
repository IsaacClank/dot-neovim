local deps = require('mini.deps')
local keymap = require('my.lib.keymap')

local M = {}

local setup_mason = function()
  deps.add({
    source = 'neovim/nvim-lspconfig',
    checkout = 'v2.4.0',
    depends = { 'williamboman/mason.nvim' }
  })
  deps.later(function()
    require('mason').setup({})
  end)
end

local setup_lsp__denols = function()
  deps.later(function()
    vim.lsp.config('denols', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/deno', 'lsp' },
      root_markers = { "deno.json", "deno.jsonc" },
      root_dir = function(bufnr, on_dir)
        local project_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
        if project_root ~= nil then
          on_dir(project_root)
        end
      end,
    });
    vim.lsp.enable('denols')
  end)
end

local setup_lsp__lua_ls = function()
  deps.later(function()
    vim.lsp.config('lua_ls', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server' },
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath('config')
              and (vim.loop.fs_stat(path .. '/.luarc.json')
                or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend(
          'force',
          client.config.settings.Lua,
          {
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              }
            }
          })
      end,
      settings = {
        Lua = {}
      }
    })
    vim.lsp.enable('lua_ls');
  end)
end

local setup_lsp__omnisharp = function()
  deps.later(function()
    vim.lsp.config('omnisharp', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/OmniSharp', "-z", "--hostPID", "12345", "--encoding", "utf-8", "--languageserver" },
      settings = {
        FormattingOptions = {
          EnableEditorConfigSupport = true,
          OrganizeImports = true,
        },
        MsBuild = {
        },
        RenameOptions = {},
        RoslynExtensionsOptions = {
          EnableAnalyzersSupport = true,
          EnableImportCompletion = true,
          EnablePackageAutoRestore = false,
        },
        Sdk = {
          IncludePrereleases = true
        }
      }
    });
    vim.lsp.enable('omnisharp')
  end)
end

local setup_lsp__ts_ls = function()
  deps.later(function()
    vim.lsp.config('ts_ls', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/typescript-language-server', '--stdio' },
      root_dir = function(bufnr, on_dir)
        local project_root = vim.fs.root(bufnr, { 'tsconfig.json' })
        if project_root ~= nil then
          on_dir(project_root)
        end
      end,
    });
    vim.lsp.enable('ts_ls')
  end)
end

local setup_lsp = function()
  deps.later(function()
    setup_lsp__denols()
    setup_lsp__lua_ls()
    setup_lsp__omnisharp()
    setup_lsp__ts_ls()

    keymap.set_multiple({
      { 'n', "<Leader>la", vim.lsp.buf.code_action,   { desc = "Code Action", } },
      { 'n', "<Leader>lk", vim.lsp.buf.hover,         { desc = "Hover", } },
      { 'n', "<Leader>lK", vim.diagnostic.open_float, { desc = "Hover diagnostic", } },
      { 'n', "<Leader>ln", vim.lsp.buf.rename,        { desc = "Rename", } },
    })
  end)
end

M.setup = function()
  setup_mason()
  setup_lsp()
end

return M
