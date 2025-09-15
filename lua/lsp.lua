local minideps = require('mini.deps')

local M = {}

M.setup = function()
  minideps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = { post_checkout = function() vim.cmd [[TSUpdate]] end }
  })

  minideps.add({
    source = 'saghen/blink.cmp',
    checkout = 'v1.6.0',
    depends = {
      "mikavilpas/blink-ripgrep.nvim",
      "rafamadriz/friendly-snippets",
    },
  })

  minideps.add({
    source = 'neovim/nvim-lspconfig',
    checkout = 'v2.4.0',
    depends = {
      'williamboman/mason.nvim',
      "stevearc/conform.nvim",
    }
  })

  require('nvim-treesitter').setup({
    auto_install = true,
    ensure_installed = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline" },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })

  vim.cmd [[highlight link BlinkCmpLabelMatch PmenuMatch]]
  vim.cmd [[highlight link BlinkCmpLabelDescription None]]
  require('blink.cmp').setup({
    keymap = { preset = 'super-tab' },
    cmdline = { enabled = false },
    completion = {
      keyword = { range = 'prefix' },
      documentation = { auto_show = true },
      accept = { auto_brackets = { enabled = false } },
      menu = {
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
          cursorline_priority = 0,
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            kind = {
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            }
          }
        }
      }
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', "ripgrep" },
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
            end, items)
          end,
        },
        ripgrep = {
          module = "blink-ripgrep"
        }
      }
    },
    fuzzy = { implementation = "lua" }
  })

  require('mason').setup({})
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
    -- 'jsonls',
    'lua_ls',
    -- 'ts_ls',
  });

  require('conform').setup({
    formatters_by_ft = {
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      prisma = { "prisma" },
      rust = { "rustfmt " },
      typescript = { "deno_fmt", "prettier", stop_after_first = true },
      typescriptreact = { "deno_fmt", "prettier", stop_after_first = true },
      markdown = { "prettier" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
    formatters = {
      prisma = {
        command = "npx",
        args = { "prisma", "format", "--schema", "$FILENAME" },
        cwd = function()
          return vim.fs.root(0, { "package.json" })
        end,
        stdin = false,
        tmpfile_format = "$FILENAME.conform.tmp",
      },
    },
  })

  vim.keymap.set('n', '<Leader>lf', function() require('conform').format() end, { desc = 'Format' })
  vim.keymap.set('n', "<Leader>la", function() vim.lsp.buf.code_action() end, { desc = "Code Action", })
  vim.keymap.set('n', "<Leader>ld", function() vim.lsp.buf.definition() end, { desc = "Definition" })
  vim.keymap.set('n', "<Leader>li", function() vim.lsp.buf.implementation() end, { desc = "Implementation", })
  vim.keymap.set('n', "<Leader>lk", function() vim.lsp.buf.hover() end, { desc = "Hover", })
  vim.keymap.set('n', "<Leader>lK", function() vim.diagnostic.open_float() end, { desc = "Hover diagnostic", })
  vim.keymap.set('n', "<Leader>ln", function() vim.lsp.buf.rename() end, { desc = "Rename", })
end

return M
