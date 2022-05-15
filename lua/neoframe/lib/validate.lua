local list = require("neoframe.lib.list")
local throw = require("neoframe.lib.throw")

local validate = {}

---Validate that a value has the expected type
function validate.is_type(val, assertion)
  local actual = type(val)
  local as_expected = false

  if type(assertion) == "table" then
    as_expected = list.includes(assertion, actual)
  else
    as_expected = actual == assertion
  end

  return as_expected
end

---Validate that a value is in a range of value
function validate.is_in_range(val, range)
  if not validate.is_type(range, "table") then
    throw.unexpected_type("table", type(range))
  end

  return list.includes(range, val)
end

return validate
