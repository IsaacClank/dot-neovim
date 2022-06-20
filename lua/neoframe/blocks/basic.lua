local mod = {}

mod.spec = {
  { "folke/tokyonight.nvim" },

  { "kyazdani42/nvim-web-devicons" },

  { "numToStr/Comment.nvim" },

  { "tpope/vim-eunuch" },

  { "tpope/vim-sensible" },

  { "tpope/vim-sleuth" },

  { "tpope/vim-surround" },

  { "windwp/nvim-autopairs" },

  { "nvim-lualine/lualine.nvim" },

  { "jghauser/mkdir.nvim" },
}

mod.config = function()
  local opt = vim.opt

  opt.expandtab = true
  opt.pumheight = 10
  opt.completeopt = "menu,noinsert"

  opt.shiftwidth = 2
  opt.tabstop = 2

  opt.ignorecase = true
  opt.smartcase = true

  if vim.fn["exists"]("g:vscode") == 0 then
    opt.number = true

    vim.cmd [[colo tokyonight]]

    require("Comment").setup({})

    require("nvim-autopairs").setup()

    require("lualine").setup({
      options = {
        theme = "tokyonight"
      }
    })
  end
end

return mod
