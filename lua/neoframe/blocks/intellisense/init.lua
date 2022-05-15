local M = {}

M.spec = {
  "neovim/nvim-lspconfig",

  requires = {
    { "williamboman/nvim-lsp-installer" },
    { "nvim-treesitter/nvim-treesitter" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
  },
}

M.config = function()
  require("neoframe.blocks.intellisense.completion").setup()
  require("neoframe.blocks.intellisense.lsp").setup()
  require("neoframe.blocks.intellisense.treesitter").setup()
  require("neoframe.blocks.intellisense.mappings").setup()
  require("neoframe.blocks.intellisense.snippets").setup()
end

return M
