local validate = require("neoframe.lib.validate")
local throw = require("neoframe.lib.throw")

---Module for working with dynamic value
local Box = {}

Box.__index = Box
setmetatable(Box, {
  __call = function(class, content)
    local self = setmetatable({}, class)
    self._content = content
    self._expectation = { is_a = nil, found_in = nil }
    return self
  end,
})

Box._content = nil
Box._expectation = { is_a = nil, found_in = nil }
Box._default = nil

---Announce the expected primitive type of the content
function Box.is_a(self, primitive_type)
  self._expectation.is_a = primitive_type

  return self
end

---Announce expected values
function Box.found_in(self, values)
  self._expectation.found_in = values

  return self
end

---Retrieve content, throws if not meeting expectation
function Box.open(self)
  if self._expectation == nil then
    return self._content
  end

  local is_expected_type = true
  if self._expectation.is_a then
    is_expected_type = validate.is_type(self._content, self._expectation.is_a)
  end

  local is_expected_value = true
  if self._expectation.found_in then
    is_expected_value = validate.is_in_range(
      self._content,
      self._expectation.found_in
    )
  end

  if is_expected_type and is_expected_value then
    return self._content
  else
    throw("UNEXPECTED_BOX_CONTENT")
  end
end

---Retrieve content, returns default if not meeting expectation
function Box.open_or_default(self, default)
  if pcall(self.open, self) then
    return self._content
  else
    return default
  end
end

return Box
