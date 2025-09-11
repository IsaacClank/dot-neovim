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
      vim.lsp.config('denols', {
        cmd = { vim.fn.stdpath('data') .. '/mason/bin/deno', 'lsp' },
        root_markers = { 'deno.json' },
      });

      vim.lsp.config('jsonls', {
        cmd = { vim.fn.stdpath('data') .. '/mason/bin/vscode-json-language-server', '--stdio' },
        single_file_support = true,
      })

      vim.lsp.config('lua_ls', {
        cmd = { vim.fn.stdpath('data') .. '/mason/bin/lua-language-server' },
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      vim.lsp.config('ts_ls', {
        cmd = { vim.fn.stdpath('data') .. '/mason/bin/typescript-language-server', '--stdio' },
        root_dir = function(bufnr, on_dir)
          local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml' }
          local project_root = vim.fs.root(bufnr, root_markers)
          if project_root then
            on_dir(project_root)
          end
        end,
      })

      vim.lsp.enable({
        'denols',
        'jsonls',
        'lua_ls',
        'ts_ls',
      });
    end,

    dependencies = {
      {
        'saghen/blink.cmp',
        version = '1.*',
        dependencies = {
          "mikavilpas/blink-ripgrep.nvim",
          "nvim-mini/mini.icons",
          "rafamadriz/friendly-snippets",
        },
        init = function()
          vim.cmd [[highlight link BlinkCmpLabelMatch PmenuMatch]]
          vim.cmd [[highlight link BlinkCmpLabelDescription None]]
        end,
        opts = {
          keymap = { preset = 'super-tab' },
          cmdline = {
            enabled = false
          },
          completion = {
            keyword = { range = 'prefix' },
            documentation = { auto_show = true },
            accept = {
              auto_brackets = {
                enabled = false,
              }
            },
            menu = {
              draw = {
                columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
                cursorline_priority = 0,
                components = {
                  kind_icon = {
                    text = function(ctx)
                      local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                      return kind_icon
                    end,
                    highlight = function(ctx)
                      local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                      return hl
                    end,
                  },
                  kind = {
                    highlight = function(ctx)
                      local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                      return hl
                    end,
                  }
                }
              }
            }
          },
          sources = {
            default = { 'lsp', 'path', 'snippets', "ripgrep" },
            providers = {
              lsp = {
                name = 'LSP',
                module = 'blink.cmp.sources.lsp',
                transform_items = function(_, items)
                  return vim.tbl_filter(function(item)
                    return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
                  end, items)
                end,
              },
              ripgrep = {
                module = "blink-ripgrep"
              }
            }
          },
          fuzzy = {
            implementation = "prefer_rust",
            sorts = {
              'score',
            }
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
            typescript = { "deno_fmt", "prettier", stop_after_first = true },
            typescriptreact = { "deno_fmt", "prettier", stop_after_first = true },
            markdown = { "prettier" },
          },
          default_format_opts = {
            lsp_format = "fallback",
          },
          format_on_save = {
            lsp_format = "fallback",
            timeout_ms = 500,
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
