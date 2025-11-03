local M = {}

M.buf_list_wins = function(buf_id)
	if buf_id == 0 then
		buf_id = vim.api.nvim_get_current_buf()
	end

	local wins = {}
	for _, win_id in ipairs(vim.api.nvim_list_wins()) do
		if buf_id == vim.api.nvim_win_get_buf(win_id) then
			table.insert(wins, win_id)
		end
	end
	return wins
end

M.buf_is_modified = function(buf_id)
	if buf_id == 0 then
		buf_id = vim.api.nvim_get_current_buf()
	end
	return vim.api.nvim_get_option_value("modified", { buf = buf_id })
end

M.buf_win_count = function(buf_id)
	return #M.buf_list_wins(buf_id)
end

return M
