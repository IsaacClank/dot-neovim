local lazy = require('config.lazy')
lazy.bootstrap();

vim.opt.expandtab = true -- In insert mode, expand tabs into spaces.
vim.opt.scrolloff = 10   -- Minimum lines offset on top and bottom. Used to add padding.
vim.opt.shiftwidth = 2   -- Number of spaces used for auto-indent.
vim.opt.tabstop = 2      -- Number of spaces to render tabs in a file. This does **not** modify the file.

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*compose.yml",
  command = "set filetype=yaml.docker-compose",
})

lazy.init();
