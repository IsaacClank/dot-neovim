return {
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
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      vim.lsp.config('omnisharp', {
        cmd = { "/home/isaac/.local/share/nvim/mason/bin/OmniSharp", "-lsp" },
        filetypes = { 'cs' },
        root_markers = { ".git", ".sln", ".csproj", 'omnisharp.json', 'function.json' },
        settings = {
          MsBuild = {
            Enabled = true,
          },
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
          },
          FileOptions = {
            SystemExcludeSearchPatterns = {
              "**/node_modules/**/*",
              "**/bin/**/*",
              "**/obj/**/*"
            },
            ExcludeSearchPatterns = {}
          }
        },
      })

      -- vim.lsp.enable('cssls');
      -- vim.lsp.enable('docker_compose_language_service');
      -- vim.lsp.enable('dockerls');
      -- vim.lsp.enable('html');
      vim.lsp.enable('jsonls');
      vim.lsp.enable('lua_ls');
      vim.lsp.enable('omnisharp')
      -- vim.lsp.enable('prismals');
      -- vim.lsp.enable('rust_analyzer');
      -- vim.lsp.enable('tailwindcss');
      vim.lsp.enable('ts_ls');
    end,

    dependencies = {
      {
        'saghen/blink.cmp',
        version = '1.*',
        opts = {
          cmdline = {
            enabled = false
          },
          completion = {
            list = {
              selection = {
                preselect = false,
                auto_insert = true,
              }
            },
            documentation = {
              auto_show = true,
              window = {
                border = 'single'
              }
            }
          },
          fuzzy = {
            implementation = "prefer_rust"
          }
        }
      },
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
}
