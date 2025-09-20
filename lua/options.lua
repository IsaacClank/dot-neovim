local M = {}

M.setup = function()
  vim.o.scrolloff = 10       -- Minimum lines offset on top and bottom. Used to add padding.

  vim.o.expandtab = true     -- In insert mode, expand tabs into spaces.
  vim.o.shiftwidth = 2       -- Number of spaces used for auto-indent.
  vim.o.tabstop = 2          -- Number of spaces to render tabs in a file. This does **not** modify the file.

  vim.o.termguicolors = true -- Enable 24-bit RGB colors

  vim.g.loaded_node_provider = 0;
  vim.g.loaded_perl_provider = 0;
  vim.g.loaded_python3_provider = 0;

  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  if vim.g.vscode == 1 then
    vim.g.clipboard = vim.g.vscode_clipboarg
  end
end

return M
