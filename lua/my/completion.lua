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
      signature = { enabled = true },
      completion = {
        keyword = { range = 'prefix' },
        documentation = { auto_show = true },
        menu = {
          draw = {
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
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
