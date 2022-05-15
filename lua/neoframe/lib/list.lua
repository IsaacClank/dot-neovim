local list = {}

function list.includes(table, item)
  for _, element in pairs(table) do
    if element == item then
      return true
    end
  end

  return false
end

return list
