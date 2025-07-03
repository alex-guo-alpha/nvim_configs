local M = {}

-- Jump list management
M.jump_history = {}
M.jump_index = 0

-- Enhanced marks with descriptions
M.named_marks = {}

M.set_named_mark = function()
  local mark = vim.fn.input('Mark name (a-z): ')
  if not mark:match('^[a-z]$') then
    vim.notify('Invalid mark name', vim.log.levels.ERROR)
    return
  end
  
  local desc = vim.fn.input('Description: ')
  local pos = vim.api.nvim_win_get_cursor(0)
  local file = vim.fn.expand('%:p')
  
  vim.cmd('mark ' .. mark)
  M.named_marks[mark] = {
    file = file,
    line = pos[1],
    col = pos[2],
    description = desc,
    time = os.time()
  }
  
  vim.notify('Mark ' .. mark .. ' set: ' .. desc, vim.log.levels.INFO)
end

M.list_named_marks = function()
  local marks = {}
  for mark, info in pairs(M.named_marks) do
    table.insert(marks, {
      mark = mark,
      text = string.format('[%s] %s - %s:%d', 
        mark, info.description or 'No description', 
        vim.fn.fnamemodify(info.file, ':t'), info.line)
    })
  end
  
  if #marks == 0 then
    vim.notify('No named marks set', vim.log.levels.INFO)
    return
  end
  
  table.sort(marks, function(a, b) return a.mark < b.mark end)
  
  local items = vim.tbl_map(function(m) return m.text end, marks)
  
  vim.ui.select(items, {
    prompt = 'Jump to mark:',
  }, function(choice, idx)
    if choice then
      vim.cmd("normal! '" .. marks[idx].mark)
    end
  end)
end

-- Smart jumps between function/class definitions
M.jump_to_definition = function(direction)
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  
  while node do
    local type = node:type()
    if type == 'function_declaration' or type == 'function_definition' or 
       type == 'method_definition' or type == 'class_definition' then
      break
    end
    node = node:parent()
  end
  
  if not node then
    vim.notify('No function/class found', vim.log.levels.WARN)
    return
  end
  
  local target_node
  if direction == 'next' then
    target_node = ts_utils.get_next_node(node)
  else
    target_node = ts_utils.get_previous_node(node)
  end
  
  if target_node then
    ts_utils.goto_node(target_node)
  end
end

-- File navigation history
M.add_to_jump_history = function()
  local file = vim.fn.expand('%:p')
  local pos = vim.api.nvim_win_get_cursor(0)
  
  -- Don't add duplicate entries
  if M.jump_index > 0 and M.jump_history[M.jump_index] then
    local last = M.jump_history[M.jump_index]
    if last.file == file and last.line == pos[1] then
      return
    end
  end
  
  -- Truncate forward history when adding new jump
  for i = M.jump_index + 1, #M.jump_history do
    M.jump_history[i] = nil
  end
  
  table.insert(M.jump_history, {
    file = file,
    line = pos[1],
    col = pos[2]
  })
  
  M.jump_index = #M.jump_history
  
  -- Limit history size
  if #M.jump_history > 100 then
    table.remove(M.jump_history, 1)
    M.jump_index = M.jump_index - 1
  end
end

M.navigate_jump_history = function(direction)
  if direction == 'back' and M.jump_index > 1 then
    M.jump_index = M.jump_index - 1
  elseif direction == 'forward' and M.jump_index < #M.jump_history then
    M.jump_index = M.jump_index + 1
  else
    return
  end
  
  local jump = M.jump_history[M.jump_index]
  if jump and vim.fn.filereadable(jump.file) == 1 then
    vim.cmd('edit ' .. jump.file)
    vim.api.nvim_win_set_cursor(0, {jump.line, jump.col})
  end
end

-- Smart bracket jumping
M.jump_to_matching_bracket = function()
  local brackets = {
    ['('] = ')', [')'] = '(',
    ['['] = ']', [']'] = '[',
    ['{'] = '}', ['}'] = '{',
    ['<'] = '>', ['>'] = '<',
  }
  
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local char = line:sub(col + 1, col + 1)
  
  if brackets[char] then
    vim.cmd('normal! %')
  else
    -- Find nearest bracket
    for i = col, 0, -1 do
      local c = line:sub(i + 1, i + 1)
      if brackets[c] then
        vim.api.nvim_win_set_cursor(0, {vim.fn.line('.'), i})
        vim.cmd('normal! %')
        return
      end
    end
  end
end

function M.setup()
  -- Named marks
  vim.keymap.set('n', '<leader>nm', M.set_named_mark, { desc = '[N]amed [M]ark set' })
  vim.keymap.set('n', '<leader>nl', M.list_named_marks, { desc = '[N]amed marks [L]ist' })
  
  -- Smart function/class navigation
  vim.keymap.set('n', ']f', function() M.jump_to_definition('next') end, { desc = 'Next function' })
  vim.keymap.set('n', '[f', function() M.jump_to_definition('prev') end, { desc = 'Previous function' })
  
  -- Enhanced jump history
  vim.keymap.set('n', '<M-Left>', function() M.navigate_jump_history('back') end, { desc = 'Jump back' })
  vim.keymap.set('n', '<M-Right>', function() M.navigate_jump_history('forward') end, { desc = 'Jump forward' })
  
  -- Smart bracket jumping
  vim.keymap.set('n', '<leader>%', M.jump_to_matching_bracket, { desc = 'Smart bracket jump' })
  
  -- Auto-add to jump history on significant movements
  vim.api.nvim_create_autocmd({'BufEnter', 'CursorHold'}, {
    callback = M.add_to_jump_history
  })
end

return M