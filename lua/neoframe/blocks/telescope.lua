local mod = {}

mod.spec = {
  "nvim-telescope/telescope.nvim",

  requires = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  },
}

mod.config = function()
  local mapping = require("neoframe.lib.mapping")

  mapping.nmap("<space>o", [[<Cmd>Telescope find_files<CR>]])
  mapping.nmap("<space>h", [[<Cmd>Telescope oldfiles<CR>]])
  mapping.nmap("<space>s", [[<Cmd>Telescope live_grep<CR>]])
  mapping.nmap("<space><s-p>", [[<Cmd>Telescope commands<CR>]])
  mapping.nmap("gd", "<cmd>Telescope lsp_definitions<CR>")
  mapping.nmap("gi", "<cmd>Telescope lsp_implementations<CR>")
  mapping.nmap("gr", "<cmd>Telescope lsp_references<CR>")
  mapping.nmap("go", "<cmd>Telescope lsp_document_symbols<cr>")
  mapping.nmap("g<s-o>", "<cmd>Telescope lsp_workspace_symbols<cr>")
end

return mod
