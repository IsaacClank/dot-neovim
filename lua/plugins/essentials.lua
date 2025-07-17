return {
  {
    "folke/which-key.nvim",
    tag = "v3.17.0",
    event = "VeryLazy",
    enabled = vim.g.vscode ~= 1,
    opts = {
      preset = 'helix',
      icons = { mappings = false },
      spec = {
        { "<leader>e",  group = "Explorer" },
        { "<leader>g",  group = "Git" },
        { "<leader>gd", group = "Git Diff" },
        { "<leader>gr", group = "Git Reset" },
        { "<leader>gs", group = "Git Stage" },
        { "<leader>gu", group = "Git Unstage" },
        { "<leader>l",  group = "Intellisense" },
        { "<leader>s",  group = "Navigation" },
        { "<M-Up>",     "<cmd>resize +5<cr>",          desc = "Increase height" },
        { "<M-Down>",   "<cmd>resize -5<cr>",          desc = "Decrease height" },
        { "<M-Right>",  "<cmd>vertical resize +5<cr>", desc = "Increase width" },
        { "<M-Left>",   "<cmd>vertical resize -5<cr>", desc = "Decrease width" },
      },
    },
  },
  { "echasnovski/mini.basics", branch = "main", opts = {} },
  { "echasnovski/mini.pairs",  branch = "main", opts = {} },
  {
    "echasnovski/mini.surround",
    branch = "main",
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
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
    opts = {},
    keys = {
      { "s", "<Plug>(leap-forward)",  mode = { "n", "x", "o" } },
      { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" } },
    }
  },
  {
    "nvim-tree/nvim-tree.lua",
    tag = "v1.12.0",
    cond = vim.g.vscode ~= 1,
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
