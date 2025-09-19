local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'neovim/nvim-lspconfig',
    checkout = 'v2.4.0',
    depends = { 'williamboman/mason.nvim' }
  })

  deps.later(function()
    require('mason').setup({})
  end)

  deps.later(function()
    vim.lsp.config('denols', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/deno', 'lsp' },
      root_markers = { 'deno.json' },
    });

    vim.lsp.config('lua_ls', {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server' },
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
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

    vim.lsp.enable({
      'denols',
      'lua_ls',
    });

    vim.keymap.set('n', "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "Code Action", })
    vim.keymap.set('n', "<Leader>lk", function() vim.lsp.buf.hover() end, { desc = "Hover", })
    vim.keymap.set('n', "<Leader>lK", function() vim.diagnostic.open_float() end, { desc = "Hover diagnostic", })
    vim.keymap.set('n', "<Leader>ln", function() vim.lsp.buf.rename() end, { desc = "Rename", })
  end)
end

return M
