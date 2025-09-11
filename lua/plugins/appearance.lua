return {
  {
    "echasnovski/mini.indentscope",
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
    "folke/noice.nvim",
    enabled = vim.g.vscode ~= 1,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      messages = {
        enabled = true,              -- enables the Noice messages UI
        view = "mini",
        view_error = "mini",         -- view for errors
        view_warn = "mini",          -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
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
