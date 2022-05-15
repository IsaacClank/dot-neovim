---Module for throwing errors
local throw = {}

setmetatable(throw, {
  __call = function(_, err, msg)
    msg = msg or ""
    error("\n -- " .. err .. " -- " .. msg)
  end,
})

local ERR_UNEXPECTED_TYPE = "NOT IMPLEMENTED"
local ERR_UNEXPECTED_VALUE = "UNEXPECTED VALUE"
local ERR_NIL_ARUGMENT = "NIL ARGUMENT"
local ERR_NOT_IMPLEMENTED = "NOT IMPLEMENTED"

function throw.not_implemented()
  throw(ERR_NOT_IMPLEMENTED)
end

---Unexpected type
function throw.unexpected_type(expected, actual)
  if type(expected) == "table" then
    expected = table.concat(expected, "/")
  end

  throw(ERR_UNEXPECTED_TYPE, "expected " .. expected .. ", got " .. actual)
end

---Nil argument
function throw.nil_arg()
  throw(ERR_NIL_ARUGMENT)
end

---Unexpected value
function throw.unexpected_value(expected, actual)
  throw(
    ERR_UNEXPECTED_VALUE,
    "value must be " .. table.concat(expected, " or ") .. ", got " .. actual
  )
end

return throw
