local M = {}

M.setup = function()
  local starter = require('mini.starter')
  starter.setup({
    evaluate_single = true,
    header = '',
    items = {
      starter.sections.builtin_actions(),
      starter.sections.recent_files(5, true),
    },
    footer = '',
    content_hooks = {
      starter.gen_hook.adding_bullet("* "),
      starter.gen_hook.indexing('all', { 'Builtin actions' }),
      starter.gen_hook.aligning('left', 'center'),
      starter.gen_hook.padding(3, 0)
    },
  })
end

return M
