return {
  {
    "folke/which-key.nvim",
    tag = "v3.17.0",
    event = "VeryLazy",
    opts = {
      preset = 'helix',
      icons = { mappings = false },
      spec = {
        { "<leader>e",  group = "Explorer" },
        { "<leader>g",  group = "Git" },
        { "<leader>gr", group = "Git Reset" },
        { "<leader>gs", group = "Git Stage" },
        { "<leader>gv", group = "Git View Options" },
        { "<leader>l",  group = "Intellisense" },
        { "<leader>s",  group = "Navigation" },
        { "<M-Up>",     "<cmd>resize +5<cr>",          desc = "Increase height" },
        { "<M-Down>",   "<cmd>resize -5<cr>",          desc = "Decrease height" },
        { "<M-Right>",  "<cmd>vertical resize +5<cr>", desc = "Increase width" },
        { "<M-Left>",   "<cmd>vertical resize -5<cr>", desc = "Decrease width" },
      },
    },
  },
  {
    "echasnovski/mini.basics",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    lazy = false,
    opts = {
      options = { extra_ui = true },
      mappings = { move_with_alt = true },
    }
  },
  {
    "echasnovski/mini.pairs",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    lazy = false,
    priority = 100,
    opts = {}
  },
  {
    "echasnovski/mini.surround",
    branch = "main",
    lazy = false,
    opts = {
      n_lines = 500,
      search_method = 'cover_or_next'
    }
  },
  {
    "windwp/nvim-ts-autotag",
    enabled = vim.g.vscode ~= 1,
    opts = {}
  },
  {
    "ggandor/leap.nvim",
    branch = "main",
    lazy = false,
    opts = {},
    keys = {
      { "<leader>s/", "<Plug>(leap-forward)",  mode = { "n", "x", "o" } },
      { "<leader>s?", "<Plug>(leap-backward)", mode = { "n", "x", "o" } },
    }
  },
  {
    "nvim-tree/nvim-tree.lua",
    tag = "v1.12.0",
    enabled = vim.g.vscode ~= 1,
    lazy = false,
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      view = {
        width = {},
        float = {
          enable = true
        }
      },
    },
    keys = {
      { "<leader>ee", "<cmd>NvimTreeToggle<cr>",         desc = "Open" },
      { "<leader>ef", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Open at focused file" },
    },
  },
}
