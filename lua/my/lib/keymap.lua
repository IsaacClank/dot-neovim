local M = {}

M.set_multiple = function(mappings)
	for _, mapping in ipairs(mappings) do
		vim.keymap.set(mapping[1], mapping[2], mapping[3], mapping[4] or {})
	end
end

return M
