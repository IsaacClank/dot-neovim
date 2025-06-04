return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    enabled = vim.g.vscode ~= 1,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        layout_strategy = 'vertical'
      },
    },
    keys = {
      { "<leader>sf", "<cmd>Telescope find_files<cr>",             desc = "File browser" },
      { "<leader>sF", "<cmd>Telescope find_files hidden=true<cr>", desc = "File browser - Include hidden files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",              desc = "Text" },
    },
  },
}
