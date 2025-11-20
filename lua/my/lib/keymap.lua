local M = {}

--- @param mappings table A list of keymap definition tables.
---   Format: `{mode, lhs, rhs, opts}` where:
---   - `mode` (string): The mode(s) the map applies to (e.g., 'n', 'i', 'v', 't', or a combination like 'nv').
---   - `lhs` (string): The left-hand side (the key sequence to press).
---   - `rhs` (string or function): The right-hand side (the command or function to execute).
---   - `opts` (table, optional): Options table for `vim.keymap.set`. If nil, an empty table `{}` is used.
M.set_multiple = function(mappings)
	for _, mapping in ipairs(mappings) do
		vim.keymap.set(mapping[1], mapping[2], mapping[3], mapping[4] or {})
	end
end

return M
