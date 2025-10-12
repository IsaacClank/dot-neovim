local deps = require('mini.deps')

local M = {}

local setup_mini_completion = function()
  deps.add({
    source = 'rafamadriz/friendly-snippets',
  })

  local mini_snippets = require('mini.snippets')
  local mini_completion = require('mini.completion')

  mini_snippets.setup({
    snippets = {
      mini_snippets.gen_loader.from_lang()
    }
  })

  mini_completion.setup({})
end

local setup_blink = function()
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
            module = "blink-ripgrep",
            score_offset = -5
          }
        }
      },
    })
  end)
end

M.setup = function()
  setup_blink()
  -- setup_mini_completion()
end

return M
