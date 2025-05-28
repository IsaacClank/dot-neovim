-- BOOTSTRAP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- /BOOTSTRAP

-- COMMON
vim.g.mapleader = " " -- Set leader to <Space>. Should already be set by mini.nvim.basics.
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.expandtab = true -- In insert mode, expand tabs into spaces.
vim.opt.scrolloff = 10   -- Minimum lines offset on top and bottom. Used to add padding.
vim.opt.shiftwidth = 2   -- Number of spaces used for auto-indent.
vim.opt.tabstop = 2      -- Number of spaces to render tabs in a file. This does **not** modify the file.

-- /COMMON

-- FILE_ASSOCIATION
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*compose.yml",
  command = "set filetype=yaml.docker-compose",
})
-- /FILE_ASSOCIATION

-- PLUGIN
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
    tag = "v1.7.1",
    enabled = vim.g.vscode ~= 1,
    lazy = false,
    opts = {
      view = {
        preserve_window_proportions = true,
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
  -- /PLUGIN__ESSENTIALS

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
    opts = {
      sections = {
        lualine_c = {
          { 'filename',       path = 1 },
          { 'macro_recording' }
        },
      },
      inactive_sections = {
        lualine_c = {
          { 'filename', path = 1 }
        }
      }
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "yavorski/lualine-macro-recording.nvim",
    }
  },
  {
    "folke/noice.nvim",
    enabled = vim.g.vscode ~= 1,
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
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
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
    opts = {
      -- table: default groups
      groups = {
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer',
      },
      -- table: additional groups that should be cleared
      extra_groups = {},
      -- table: groups you don't want to clear
      exclude_groups = {},
      -- function: code to be executed after highlight groups are cleared
      -- Also the user event "TransparentClear" will be triggered
      on_clear = function() end,
    }
  },
  -- /PLUGINS__THEME

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
  -- /PLUGINS__GIT

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
  -- /PLUGINS__NAVIGATION

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
    lazy = false,
    ft = { 'lua', 'typescript' },
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
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = {
                'lua/?.lua',
                'lua/?/init.lua',
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                '${3rd}/luv/library',
                '${3rd}/busted/library',
              }
              -- Or pull in all of 'runtimepath'.
              -- library = {
              --   vim.api.nvim_get_runtime_file('', true),
              -- }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      vim.lsp.config('omnisharp', {
        cmd = { "/home/isaac/.local/share/nvim/mason/packages/omnisharp/omnisharp" },
        root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "function.json"),
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

      vim.lsp.config('ts_ls', {
        settings = {

        }
      })

      -- vim.lsp.enable('cssls');
      -- vim.lsp.enable('docker_compose_language_service');
      -- vim.lsp.enable('dockerls');
      -- vim.lsp.enable('html');
      vim.lsp.enable('jsonls');
      vim.lsp.enable('lua_ls');
      -- vim.lsp.enable('omnisharp')
      -- vim.lsp.enable('prismals');
      -- vim.lsp.enable('rust_analyzer');
      -- vim.lsp.enable('tailwindcss');
      vim.lsp.enable('ts_ls');

      vim.cmd [[set completeopt+=fuzzy,menuone,noselect,popup,preview]]
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          -- if client:supports_method('textDocument/implementation') then
          -- end

          if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {};
            for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

            vim.keymap.set('i', '<c-space>', function()
              vim.lsp.completion.get()
            end)
          end
        end,
      })

      vim.lsp.inlay_hint.enable(not (vim.lsp.inlay_hint.is_enabled()))
    end,

    dependencies = {
      {
        "stevearc/conform.nvim",
        lazy = false,
        keys = {
          { "<leader>lf", function() require("conform").format() end, desc = "Format" },
        },
        opts = {
          formatters_by_ft = {
            css = { "prettier" },
            html = { "prettier" },
            javascript = { "prettier" },
            prisma = { "prisma" },
            rust = { "rustfmt " },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
          },
          default_format_opts = {
            lsp_format = "fallback",
          },
          format_on_save = {
            lsp_format = "fallback",
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
    opts = {},
    dependencies = {},
  },
  -- /PLUGINS__INTELLISENSE
})
-- /PLUGIN
