return {
  {
    "nvim-mini/mini.indentscope",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    config = function()
      local indentscope = require("mini.indentscope")
      indentscope.setup({
        draw = {
          animation = require("mini.indentscope").gen_animation.linear({ duration = 5 })
        }
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    branch = "master",
    enabled = vim.g.vscode ~= 1,
    opts = {
      theme = 'onedark',
      sections = {
        lualine_c = {
          { 'filename',       path = 1 },
          { 'macro_recording' }
        },
        lualine_x = {
          { 'encoding' },
          { 'fileformat' },
          { 'filetype' },
          { 'lsp_status' },
        }
      },
      inactive_sections = {
        lualine_c = {
          { 'filename', path = 1 }
        }
      }
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "yavorski/lualine-macro-recording.nvim",
    }
  },
  {
    "nvim-tree/nvim-web-devicons",
    branch = "master",
    enabled = vim.g.vscode ~= 1,
  },
  {
    "nvim-mini/mini.icons",
    opts = {
      style = 'glyph'
    }
  },
}
