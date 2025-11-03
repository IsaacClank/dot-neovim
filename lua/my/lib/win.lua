local M = {}

M.win_is_last_focusable = function(win_id)
	if win_id == 0 then
		win_id = vim.api.nvim_get_current_win()
	end

	if not M.win_is_focusable(win_id) then
		return false
	end

	local is_last_focusable = true
	for _, other_win_id in ipairs(vim.api.nvim_list_wins()) do
		if win_id ~= other_win_id then
			if M.win_is_focusable(other_win_id) then
				is_last_focusable = false
			end
		end
	end
	return is_last_focusable
end

M.win_is_focusable = function(win_id)
	return vim.api.nvim_win_get_config(win_id).focusable
end

return M
