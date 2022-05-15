local M = {}

M.setup = function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = NF_INTELLISENSE.treesitter_modules,
  })
end

return M
