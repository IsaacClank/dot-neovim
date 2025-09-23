local deps = require('mini.deps')
local keymap = require('my.lib.keymap')

local M = {}

local setup_telescope = function()
  deps.add({
    source = 'nvim-telescope/telescope.nvim',
    checkout = '0.1.8',
    depends = {
      "nvim-lua/plenary.nvim",
    }
  })
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
  keymap.set_multiple({
    { 'n', '<Leader>sp',     '<Cmd>Telescope commands<CR>',                              { desc = 'Commands' } },
    { 'n', '<Leader>s<A-p>', '<Cmd>Telescope builtin<CR>',                               { desc = 'Telescope' } },
    { 'n', "<leader>sb",     "<Cmd>Telescope buffers<CR>",                               { desc = "Buffers" } },
    { 'n', "<leader>so",     "<Cmd>Telescope find_files<CR>",                            { desc = "Open file" } },
    { 'n', "<leader>sO",     "<Cmd>Telescope find_files hidden=true no_ignore=true<CR>", { desc = "Open all file" } },
    { 'n', "<leader>sf",     "<Cmd>Telescope live_grep<CR>",                             { desc = "Find" } },
    { 'n', "<Leader>sr",     "<Cmd>Telescope lsp_references<CR>",                        { desc = "References" } },
    { 'n', "<Leader>ss",     "<Cmd>Telescope lsp_document_symbols<CR>",                  { desc = "Document symbols" } },
    { 'n', "<Leader>sS",     "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>",         { desc = "Workspace symbols" } },
    { 'n', "<Leader>sd",     "<Cmd>Telescope lsp_definitions<CR>",                       { desc = "Definitions" } },
    { 'n', "<Leader>si",     "<Cmd>Telescope lsp_implementations<CR>",                   { desc = "Implementations" } },
  })
end

M.setup = function()
  setup_telescope()
end

return M
