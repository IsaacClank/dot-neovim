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
      vim.lsp.config('azure_pipelines_ls', {
        root_markers = { '.git' },
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                "/azure-pipeline*.y*l",
                "/*.azure*",
                "Azure-Pipelines/**/*.y*l",
                "Pipelines/*.y*l",
                "**/*pipelines/*.y*l",
              },
            }
          }
        }
      })

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
            enableDecompilationSupport = true,
            enableImportCompletion = true,
            enableAnalyzersSupport = true,
          },
          FileOptions = {
            systemExcludeSearchPatterns = {
              "**/node_modules/**/*",
              "**/bin/**/*",
              "**/obj/**/*"
            },
            excludeSearchPatterns = {}
          }
        },
      })

      vim.lsp.enable('azure_pipelines_ls');
      -- vim.lsp.enable('cssls');
      vim.lsp.enable('denols')
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
        dependencies = {
          "mikavilpas/blink-ripgrep.nvim",
          "onsails/lspkind.nvim",
          "nvim-tree/nvim-web-devicons",
          "rafamadriz/friendly-snippets",
        },
        opts = {
          keymap = { preset = 'super-tab' },
          keywrod = { range = 'prefix' },
          cmdline = {
            enabled = false
          },
          completion = {
            documentation = { auto_show = true },
            menu = {
              draw = {
                components = {
                  kind_icon = {
                    text = function(ctx)
                      local icon = ctx.kind_icon
                      if vim.tbl_contains({ "Path" }, ctx.source_name) then
                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                        if dev_icon then
                          icon = dev_icon
                        end
                      else
                        icon = require("lspkind").symbolic(ctx.kind, {
                          mode = "symbol",
                        })
                      end

                      return icon .. ctx.icon_gap
                    end,

                    -- Optionally, use the highlight groups from nvim-web-devicons
                    -- You can also add the same function for `kind.highlight` if you want to
                    -- keep the highlight groups in sync with the icons.
                    highlight = function(ctx)
                      local hl = ctx.kind_hl
                      if vim.tbl_contains({ "Path" }, ctx.source_name) then
                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                        if dev_icon then
                          hl = dev_hl
                        end
                      end
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
            markdown = { "prettier" },
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
