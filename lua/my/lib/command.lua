local M = {}

--- @param commands table A list of keymap definition tables.
---   Format: `{name, handler, opts}` where:
---   - `name`    (string)
---   - `handler` (string|function)
---   - `opts`    (table, optional)
---     Options table for `vim.keymap.nvim_create_user_command`.
---     If nil, an empty table `{}` is used.
M.create_multiple = function(commands)
	for _, cmd in ipairs(commands) do
		vim.api.nvim_create_user_command(cmd[1], cmd[2], cmd[3] or {})
	end
end

return M
