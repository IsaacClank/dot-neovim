local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'saghen/blink.cmp',
    checkout = 'v1.6.0',
    depends = {
      "mikavilpas/blink-ripgrep.nvim",
      "rafamadriz/friendly-snippets",
    },
  })

  deps.later(function()
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { link = 'PmenuMatch' })

    require('blink.cmp').setup({
      keymap = { preset = 'super-tab' },
      cmdline = { enabled = false },
      completion = {
        keyword = { range = 'prefix' },
        documentation = { auto_show = true },
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
  end)
end

return M
