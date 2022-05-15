local mod = {}

function mod.config()
  local opt = vim.opt

  opt.pumheight = 10
  opt.completeopt = "menu,noinsert"

  opt.expandtab = true
  opt.shiftwidth = 2
  opt.smarttab = true
  opt.tabstop = 2

  opt.ignorecase = true
  opt.smartcase = true

  opt.number = true
end

return mod
