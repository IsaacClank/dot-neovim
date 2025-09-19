local deps = require('mini.deps')

local M = {}

M.setup = function()
  deps.add({
    source = 'nvim-telescope/telescope.nvim',
    checkout = '0.1.8',
    depends = {
      "nvim-lua/plenary.nvim",
    }
  })
  deps.add({
    source = 'ggandor/leap.nvim',
    checkout = 'main',
  })

  deps.now(function()
    require('telescope').setup({
      defaults = {
        sorting_strategy = 'ascending',
        layout_strategy = 'center',
        layout_config = {
          prompt_position = "top"
        }
      },
      pickers = {
        colorscheme = {
          enable_preview = true
        },
      }
    })

    vim.keymap.set('n', '<Leader>sp', '<Cmd>Telescope commands<CR>', { desc = 'Commands' })
    vim.keymap.set('n', '<Leader>s<A-p>', '<Cmd>Telescope builtin<CR>', { desc = 'Telescope' })
    vim.keymap.set('n', "<leader>sb", "<Cmd>Telescope buffers<CR>", { desc = "Buffers" })
    vim.keymap.set('n', "<leader>so", "<Cmd>Telescope find_files<CR>", { desc = "Open file" })
    vim.keymap.set('n', "<leader>sf", "<Cmd>Telescope live_grep<CR>", { desc = "Find" })

    vim.keymap.set('n', "<Leader>sr", "<Cmd>Telescope lsp_references<CR>", { desc = "References" })
    vim.keymap.set('n', "<Leader>ss", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
    vim.keymap.set('n', "<Leader>sS", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Workspace symbols" })

    vim.keymap.set('n', "<Leader>sd", "<Cmd>Telescope lsp_defintions<CR>", { desc = "Definitions" })
    vim.keymap.set('n', "<Leader>si", "<Cmd>Telescope lsp_implementations<CR>", { desc = "Implementations" })

    require('leap').setup({})
    vim.keymap.set('n', '<Leader>s/', '<Plug>(leap-forward)', { desc = 'Leap forward' })
    vim.keymap.set('n', '<Leader>s?', '<Plug>(leap-forward)', { desc = 'Leap backward' })
  end)
end

return M
