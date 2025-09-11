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

  vim.o.termguicolors = true;

  vim.g.loaded_node_provider = 0;
  vim.g.loaded_perl_provider = 0;
  vim.g.loaded_python3_provider = 0;

  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"
  vim.g.markdown_fenced_languages = { "ts=typescript" }

  if vim.g.vscode == 1 then
    vim.g.clipboard = vim.g.vscode_clipboarg
  end

  vim.cmd [[highlight Normal guibg=None]]
  vim.cmd [[highlight PmenuSel gui=None guibg=NvimDarkGrey4]]
  vim.cmd [[highlight PmenuMatch gui=None guifg=NvimLightGrey4]]
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
