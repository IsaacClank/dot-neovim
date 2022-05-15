local mod = {}

mod.spec = {
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim", tags = "Release" },
}

mod.config = function()
  require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 0,
    },
  })
end

return mod
