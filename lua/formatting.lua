local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'stevearc/conform.nvim',
    checkout = 'v9.1.0'
  })

  deps.later(function()
    local conform = require('conform')

    conform.setup({
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
      -- format_on_save = {
      --   lsp_format = "fallback",
      --   timeout_ms = 500,
      -- },
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

    vim.keymap.set('n', '<Leader>lf', function() conform.format() end, { desc = 'Format' })
  end)
end

return M
