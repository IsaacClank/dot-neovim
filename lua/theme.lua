local deps = require('mini.deps')
local M = {}

M.setup = function()
  require('mini.indentscope').setup({
    draw = {
      animation = require("mini.indentscope").gen_animation.linear({ duration = 5 })
    }
  })
  require('mini.icons').setup({})
  require('mini.icons').mock_nvim_web_devicons()

  local palettes = {
    ayu_dark = {
      base00 = "#0F1419",
      base01 = "#131721",
      base02 = "#272D38",
      base03 = "#3E4B59",
      base04 = "#BFBDB6",
      base05 = "#E6E1CF",
      base06 = "#E6E1CF",
      base07 = "#F3F4F5",
      base08 = "#F07178",
      base09 = "#FF8F40",
      base0A = "#FFB454",
      base0B = "#B8CC52",
      base0C = "#95E6CB",
      base0D = "#59C2FF",
      base0E = "#D2A6FF",
      base0F = "#E6B673",
    },
    classic_dark = {
      base00 = "#151515",
      base01 = "#202020",
      base02 = "#303030",
      base03 = "#505050",
      base04 = "#B0B0B0",
      base05 = "#D0D0D0",
      base06 = "#E0E0E0",
      base07 = "#F5F5F5",
      base08 = "#AC4142",
      base09 = "#D28445",
      base0A = "#F4BF75",
      base0B = "#90A959",
      base0C = "#75B5AA",
      base0D = "#6A9FB5",
      base0E = "#AA759F",
      base0F = "#8F5536",
    },
    github = {
      base00 = "#ffffff",
      base01 = "#f5f5f5",
      base02 = "#c8c8fa",
      base03 = "#969896",
      base04 = "#e8e8e8",
      base05 = "#333333",
      base06 = "#ffffff",
      base07 = "#ffffff",
      base08 = "#ed6a43",
      base09 = "#0086b3",
      base0A = "#795da3",
      base0B = "#183691",
      base0C = "#183691",
      base0D = "#795da3",
      base0E = "#a71d5d",
      base0F = "#333333",
    },
    material_darker = {
      base00 = "#212121",
      base01 = "#303030",
      base02 = "#353535",
      base03 = "#4A4A4A",
      base04 = "#B2CCD6",
      base05 = "#EEFFFF",
      base06 = "#EEFFFF",
      base07 = "#FFFFFF",
      base08 = "#F07178",
      base09 = "#F78C6C",
      base0A = "#FFCB6B",
      base0B = "#C3E88D",
      base0C = "#89DDFF",
      base0D = "#82AAFF",
      base0E = "#C792EA",
      base0F = "#FF5370",
    },
    material_vivid = {
      base00 = "#202124",
      base01 = "#27292c",
      base02 = "#323639",
      base03 = "#44464d",
      base04 = "#676c71",
      base05 = "#80868b",
      base06 = "#9e9e9e",
      base07 = "#ffffff",
      base08 = "#f44336",
      base09 = "#ff9800",
      base0A = "#ffeb3b",
      base0B = "#00e676",
      base0C = "#00bcd4",
      base0D = "#2196f3",
      base0E = "#673ab7",
      base0F = "#8d6e63",
    },
    monokai = {
      base00 = "#272822",
      base01 = "#383830",
      base02 = "#49483e",
      base03 = "#75715e",
      base04 = "#a59f85",
      base05 = "#f8f8f2",
      base06 = "#f5f4f1",
      base07 = "#f9f8f5",
      base08 = "#f92672",
      base09 = "#fd971f",
      base0A = "#f4bf75",
      base0B = "#a6e22e",
      base0C = "#a1efe4",
      base0D = "#66d9ef",
      base0E = "#ae81ff",
      base0F = "#cc6633",
    },
    onedark = {
      base00 = "#282c34",
      base01 = "#353b45",
      base02 = "#3e4451",
      base03 = "#545862",
      base04 = "#565c64",
      base05 = "#abb2bf",
      base06 = "#b6bdca",
      base07 = "#c8ccd4",
      base08 = "#e06c75",
      base09 = "#d19a66",
      base0A = "#e5c07b",
      base0B = "#98c379",
      base0C = "#56b6c2",
      base0D = "#61afef",
      base0E = "#c678dd",
      base0F = "#be5046",
    },
    tomorrow_night = {
      base00 = "#1d1f21",
      base01 = "#282a2e",
      base02 = "#373b41",
      base03 = "#969896",
      base04 = "#b4b7b4",
      base05 = "#c5c8c6",
      base06 = "#e0e0e0",
      base07 = "#ffffff",
      base08 = "#cc6666",
      base09 = "#de935f",
      base0A = "#f0c674",
      base0B = "#b5bd68",
      base0C = "#8abeb7",
      base0D = "#81a2be",
      base0E = "#b294bb",
      base0F = "#a3685a",
    },
    twilight = {
      base00 = "#1e1e1e",
      base01 = "#323537",
      base02 = "#464b50",
      base03 = "#5f5a60",
      base04 = "#838184",
      base05 = "#a7a7a7",
      base06 = "#c3c3c3",
      base07 = "#ffffff",
      base08 = "#cf6a4c",
      base09 = "#cda869",
      base0A = "#f9ee98",
      base0B = "#8f9d6a",
      base0C = "#afc4db",
      base0D = "#7587a6",
      base0E = "#9b859d",
      base0F = "#9b703f",
    }
  }

  require('mini.base16').setup({
    palette = palettes.onedark
  })

  -- vim.cmd [[highlight Normal guibg=None]]

  -- vim.cmd [[highlight PmenuSel gui=None guibg=NvimDarkGrey4]]
  -- vim.cmd [[highlight PmenuSel gui=None guibg=LightGray blend=100]]
  -- vim.cmd [[highlight PmenuMatch gui=None guifg=NvimLightGrey4]]

  -- vim.api.nvim_set_hl(0, "PmenuSel", { bg = 'Gray' })
  -- vim.api.nvim_set_hl(0, "PmenuMatch", { bold = true })
end
return M
