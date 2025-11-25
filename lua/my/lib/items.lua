local M = {}

---@generic VType
---@param items table<any, VType>
---@param predicate fun(item: VType): boolean
---@return integer|nil
M.find_index = function(items, predicate)
	local index = nil
	for k, v in ipairs(items) do
		if predicate(v) then
			index = k
			break
		end
	end
	return index
end

---@generic T
---@param items_1 table<any, T>
---@param items_2 table<any, T>
---@return table<any,T>
M.concat = function(items_1, items_2)
	local result = {}
	for _, v in ipairs(items_1) do
		table.insert(result, v)
	end
	for _, v in ipairs(items_2) do
		table.insert(result, v)
	end
	return result
end

---@generic VType
---@param items table<any, VType>
---@param predicate fun(v: VType): boolean
---@return table<any,VType>
M.remove = function(items, predicate)
	local result = vim.tbl_values(items)
	local index = M.find_index(items, function(e)
		return predicate(e)
	end)

	if index ~= nil then
		table.remove(result, index)
	end

	return result
end

return M
