--!strict
local MOD = {}

function MOD.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    local repoCloningResult = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })

    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo(
        {
          { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
          { repoCloningResult,              "WarningMsg" },
          { "\nPress any key to exit..." },
        },
        true,
        {}
      )
      vim.fn.getchar()
      os.exit(1)
    end
  end

  vim.opt.rtp:prepend(lazypath)

  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
end

function MOD.init()
  require("lazy").setup({
    defaults = {
      lazy = false,
      version = nil,
    },
    spec = {
      { import = "plugins" },
    },
  })
end

return MOD
