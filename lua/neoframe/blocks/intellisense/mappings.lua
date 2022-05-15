local M = {}

M.setup = function()
  local mapping = require("neoframe.lib.mapping")
  mapping.nmap("<space>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
  mapping.nmap("<space>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
  mapping.nmap("<space>fa", [[<cmd>lua vim.lsp.buf.format({sync = true})<CR>]])
  mapping.nmap("<space>k", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
  mapping.nmap("g[", [[<cmd>lua vim.diagnostic.goto_prev()<CR>]])
  mapping.nmap("g]", [[<cmd>lua vim.diagnostic.goto_next()<CR>]])
end

return M
