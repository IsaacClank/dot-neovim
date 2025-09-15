return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    enabled = vim.g.vscode ~= 1,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", },
    opts = {
      defaults = {
        layout_strategy = 'vertical'
      },
    },
    keys = {
      { "<leader>sp",     "<cmd>Telescope builtin<cr>",                desc = "Telescope" },
      { "<leader>sb",     "<cmd>Telescope buffers<cr>",                desc = "Buffers" },
      { "<leader>so",     "<cmd>Telescope find_files<cr>",             desc = "Open file" },
      { "<leader>sO",     "<cmd>Telescope find_files hidden=true<cr>", desc = "Open file - Include hidden files" },
      { "<leader>s<A-o>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Open file - Only (git) tracked files" },
      { "<leader>sf",     "<cmd>Telescope live_grep<cr>",              desc = "Find by text" },
    },
  },
}
