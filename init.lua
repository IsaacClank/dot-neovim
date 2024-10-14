-- COMMON
vim.g.mapleader = " " -- Set leader to <Space>. Should already be set by mini.nvim.basics.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.expandtab = true -- In insert mode, expand tabs into spaces.
vim.opt.scrolloff = 10   -- Minimum lines offset on top and bottom. Used to add padding.
vim.opt.shiftwidth = 2   -- Number of spaces used for auto-indent.
vim.opt.tabstop = 2      -- Number of spaces to render tabs in a file. This does **not** modify the file.
-- COMMON

-- FILE_ASSOCIATION
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*compose.yml",
  command = "set filetype=yaml.docker-compose",
})
-- FILE_ASSOCIATION

-- PLUGIN
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- PLUGIN__ESSENTIALS
  {
    "folke/which-key.nvim",
    tag = "v3.13.3",
    event = "VeryLazy",
    enabled = vim.g.vscode ~= 1,
    config = function()
      local wk = require("which-key")

      wk.setup({
        icons = {
          mappings = false
        },
        preset = "helix",
      })

      wk.add({
        { "<leader>g",  group = "Git" },
        { "<leader>gd", group = "Diff" },
        { "<leader>gr", group = "Reset" },
        { "<leader>gs", group = "Stage" },
        { "<leader>gu", group = "Unstage" },
        { "<leader>l",  group = "Intellisense" },
        { "<leader>s",  group = "Navigation" },

        { "<M-Up>",     "<cmd>resize +5<cr>",          desc = "Increase height" },
        { "<M-Down>",   "<cmd>resize -5<cr>",          desc = "Decrease height" },
        { "<M-Right>",  "<cmd>vertical resize +5<cr>", desc = "Increase width" },
        { "<M-Left>",   "<cmd>vertical resize -5<cr>", desc = "Decrease width" },
      })
    end
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
    tag = "v1.7.1",
    enabled = vim.g.vscode ~= 1,
    opts = {
      sync_root_with_cwd = true,
      view = { width = "15%", },
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
  },
  -- PLUGIN__ESSENTIALS

  -- PLUGINS__THEME
  {
    "echasnovski/mini.indentscope",
    branch = "main",
    enabled = vim.g.vscode ~= 1,
    config = function()
      local indentscope = require("mini.indentscope")
      indentscope.setup({
        draw = {
          animation = require("mini.indentscope").gen_animation.linear({ duration = 5 })
        }
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    branch = "master",
    enabled = vim.g.vscode ~= 1,
    opts = {},
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    }
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim"
    }
  },
  {
    "nvim-tree/nvim-web-devicons",
    branch = "master",
    enabled = vim.g.vscode ~= 1,
  },
  {
    "xiyaowong/transparent.nvim",
    enabled = vim.g.vscode ~= 1,
    init = function()
      vim.g.transparent_groups = vim.list_extend(
        vim.g.transparent_groups or {},
        { "Normal" })
    end,
  },
  -- PLUGINS__THEME

  -- PLUGINS__GIT
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
  -- PLUGINS__GIT

  -- PLUGINS__NAVIGATION
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
      { "<leader>sF", "<cmd>Telescope find_files hidden=true<cr>", desc = "File browser" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",              desc = "Text" },
    },
  },
  -- PLUGINS__NAVIGATION

  -- PLUGINS__INTELLISENSE
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    enabled = vim.g.vscode ~= 1,
    config = function()
      require("nvim-treesitter.configs").setup {
        auto_install = true,
        ensure_installed = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline" },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>la", function() vim.lsp.buf.code_action() end,           desc = "Code Action", },
      { "<leader>ld", function() vim.lsp.buf.definition() end,            desc = "Definition", },
      { "<leader>li", function() vim.lsp.buf.implementation() end,        desc = "Implementation", },
      { "<leader>lk", function() vim.lsp.buf.hover() end,                 desc = "Hover", },
      { "<leader>lK", function() vim.diagnostic.open_float() end,         desc = "Hover diagnostic", },
      { "<leader>ln", function() vim.lsp.buf.rename() end,                desc = "Rename", },
      { "<leader>lr", "<cmd>Telescope lsp_references<cr>",                desc = "References" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
    },
    enabled = vim.g.vscode ~= 1,
    config = function()
      local lspconfig = require("lspconfig")
      local completion_capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.dockerls.setup({
        capabilities = completion_capabilities,
        filetypes = { "dockerfile" },
      })

      lspconfig.docker_compose_language_service.setup({
        capabilities = completion_capabilities,
        filetypes = { "yaml.docker-compose" },
        single_file_support = true,
        root_dir = lspconfig.util.root_pattern(
          "docker-compose.yaml",
          "docker-compose.yml",
          "compose.yaml",
          "compose.yml"
        ),
      })

      lspconfig.jsonls.setup({
        capabilities = completion_capabilities,
      })

      lspconfig.lua_ls.setup({
        on_init = function(client)
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      lspconfig.omnisharp.setup({
        cmd = { "/home/isaac/.local/share/nvim/mason/packages/omnisharp/omnisharp" },
        capabilities = completion_capabilities,
        root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "function.json"),
        filetypes = { "cs" },
        settings = {
          msbuild = {
            enabled = true,
          },
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          RoslynExtensionsOptions = {
            EnableImportCompletion = true,
          },
        },
      })

      lspconfig.prismals.setup({
        capabilities = completion_capabilities,
      })

      lspconfig.ts_ls.setup({
        capabilities = completion_capabilities,
      })
    end,

    dependencies = {
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          -- "hrsh7th/cmp-nvim-lsp-signature-help",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/cmp-vsnip",
          "hrsh7th/vim-vsnip",
          "lukas-reineke/cmp-under-comparator",
        },
        config = function()
          local cmp = require("cmp")

          cmp.setup({
            snippet = {
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
              { name = "vsnip" },
              -- { name = "nvim_lsp_signature_help" },
              { name = "nvim_lsp" },
              { { name = "buffer" } },
            }),
            sorting = {
              comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                require "cmp-under-comparator".under,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
              }
            }
          })
        end
      },
      {
        "stevearc/conform.nvim",
        keys = {
          { "<leader>lf", function() require("conform").format() end, desc = "Format" },
        },
        opts = {
          formatters_by_ft = {
            typescript = { "prettier" },
            prisma = { "prisma" },
            ["_"] = { lsp_format = "fallback" },
          },
          formatters = {
            prisma = {
              command = "npx",
              args = { "prisma", "format", "--schema", "$FILENAME" },
              cwd = function()
                return vim.fs.root(0, { "package.json" })
              end,
              stdin = false,
              tmpfile_format = "$FILENAME.conform.tmp",
            },
          },
        }
      },
    },
  },
  {
    "williamboman/mason.nvim",
    enabled = vim.g.vscode ~= 1,
    build = ":MasonUpdate",
    opts = {},
    dependencies = {
      { "williamboman/mason-lspconfig.nvim", opts = {} },
    },
  },
  -- PLUGINS__INTELLISENSE
})
-- PLUGIN
