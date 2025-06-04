return {
  {
    "kdheepak/lazygit.nvim",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    tag = "v0.9.0",
    enabled = vim.g.vscode ~= 1,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { delay = 300 },
    },
    lazy = false,
    keys = {
      { "<leader>g",   group = "Git" },
      { "<leader>gn",  "<cmd>Gitsigns next_hunk<cr>",          desc = "Next hunk" },
      { "<leader>gp",  "<cmd>Gitsigns prev_hunk<cr>",          desc = "Previous hunk" },
      { "<leader>gsa", "<cmd>Gitsigns stage_buffer<cr>",       desc = "Stage file" },
      { "<leader>gss", "<cmd>Gitsigns stage_hunk<cr>",         desc = "Stage hunk",   mode = { "n", "v" } },
      { "<leader>gua", "<cmd>Gitsigns reset_buffer_index<cr>", desc = "Unstage file" },
      { "<leader>gus", "<cmd>Gitsigns undo_stage_hunk<cr>",    desc = "Unstage hunk", mode = { "n", "v" } },
      { "<leader>gra", "<cmd>Gitsigns reset_buffer<cr>",       desc = "Reset file" },
      { "<leader>grs", "<cmd>Gitsigns reset_hunk<cr>",         desc = "Reset hunk",   mode = { "n", "v" } },
    },
  },
  {
    "sindrets/diffview.nvim",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    keys = {
      { "<leader>gdd", "<cmd>DiffviewOpen<cr>",        desc = "All" },
      { "<leader>gdf", "<cmd>DiffviewFileHistory<cr>", desc = "File" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>",       desc = "Close" },
    },
  },
}
