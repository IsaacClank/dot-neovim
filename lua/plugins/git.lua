return {
  {
    "kdheepak/lazygit.nvim",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    lazy = false,
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    version = "1.x",
    enabled = vim.g.vscode ~= 1,
    lazy = false,
    opts = {
      numhl = true,
      current_line_blame = true,
      current_line_blame_opts = { delay = 300 },
      diff_opts = {
        algorithm = 'histogram',
        vertical = true,
        ignore_whitespace = true,
      }
    },
    keys = {
      { "<leader>g",  group = "Git" },
      { "<leader>gn", "<cmd>Gitsigns nav_hunk 'next' preview=true<cr>", desc = "Next hunk" },
      { "<leader>gp", "<cmd>Gitsigns nav_hunk 'prev' preview=true<cr>", desc = "Previous hunk" },
      { "<leader>gs", "<cmd>'<,'>Gitsigns stage_hunk<cr>",              desc = "Stage/Unstage hunk", mode = { "v" } },
      { "<leader>gr", "<cmd>'<,'>Gitsigns reset_hunk<cr>",              desc = "Reset hunk",         mode = { "v" } },
      {
        "<leader>gvd",
        function()
          vim.cmd([[tabnew %]])
          require('gitsigns').diffthis(nil, { split = 'leftabove' })
        end,
        desc = "Diff",
        mode = { "n" }
      },
      {
        "<leader>gvp",
        "<cmd>Gitsigns preview_hunk<cr>",
        desc = "Preview hunk",
        mode = { "n" }
      },
    },
  },
}
