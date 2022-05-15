local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

local M = {}

M.setup = function()
  ls.add_snippets("cs", {
    s("ns", {
      t({ "namespace " }), i(1), t({ "", "" }),
      t({ "{" }), i(2), t({ "}" })
    }),

    s("class", {
      t({ "/// <summary>", "" }),
      t({ '/// ' }), i(3, "Description"), t({ ".", "" }),
      t({ "/// </summary>", "" }),

      i(1, "public"), t(" class "), i(2, "ClassName"), t({ "", "" }),
      t({ "{" }), i(4), t({ "}" }),
    }),

    s("func", {
      t({ "/// <summary>", "" }),
      t({ '/// ' }), i(5, "Description"), t({ ".", "" }),
      t({ "/// </summary>", "" }),

      i(1, "public"), t(" "), i(2, "void"), t(" "), i(3, "FunctionName"), t(" "), t("("), i(4, " ... "), t({ ")", "" }),
      t({ "{", "}" })
    })
  })
end

return M
