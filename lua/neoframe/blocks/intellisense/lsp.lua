local M = {}

function M.setup()
  local lsp_config = require("lspconfig")
  local lsp_installer = require("nvim-lsp-installer")
  local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  lsp_installer.setup({
    automatic_installation = true,
  })

  for _, server in pairs(NF_INTELLISENSE.lsp_servers) do
    local opts = NF_INTELLISENSE[server] or {}

    opts.capabilities = capabilities

    lsp_config[server].setup(opts)
  end
end

return M
