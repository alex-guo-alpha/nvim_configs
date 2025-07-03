local M = {}

-- Case conversion
M.convert_case = function(case_type)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  
  if #lines == 0 then return end
  
  local text = lines[1]
  if #lines == 1 then
    text = text:sub(start_pos[3], end_pos[3])
  end
  
  local converted
  if case_type == 'snake' then
    converted = text:gsub('([a-z])([A-Z])', '%1_%2'):gsub('-', '_'):lower()
  elseif case_type == 'camel' then
    converted = text:gsub('[-_](.)', function(s) return s:upper() end)
    converted = converted:sub(1,1):lower() .. converted:sub(2)
  elseif case_type == 'pascal' then
    converted = text:gsub('[-_](.)', function(s) return s:upper() end)
    converted = converted:sub(1,1):upper() .. converted:sub(2)
  elseif case_type == 'kebab' then
    converted = text:gsub('([a-z])([A-Z])', '%1-%2'):gsub('_', '-'):lower()
  elseif case_type == 'upper' then
    converted = text:upper()
  elseif case_type == 'lower' then
    converted = text:lower()
  end
  
  -- Replace the text
  if #lines == 1 then
    lines[1] = lines[1]:sub(1, start_pos[3] - 1) .. converted .. lines[1]:sub(end_pos[3] + 1)
  else
    lines[1] = converted
  end
  
  vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, lines)
end

-- Smart line operations
M.join_lines_smart = function()
  local line = vim.fn.line('.')
  local next_line = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
  
  if next_line and next_line:match('^%s*[%*%-]') then
    -- List item - join with space
    vim.cmd('normal! J')
  elseif next_line and next_line:match('^%s*{') then
    -- Opening brace - join without space
    vim.cmd('normal! gJ')
  else
    -- Default join
    vim.cmd('normal! J')
  end
end

-- Sort operations
M.sort_selection = function(reverse)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  table.sort(lines, function(a, b)
    if reverse then
      return a > b
    else
      return a < b
    end
  end)
  
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
  vim.notify('Sorted ' .. #lines .. ' lines', vim.log.levels.INFO)
end

-- Align text
M.align_text = function()
  local char = vim.fn.input('Align by character: ')
  if char == '' then return end
  
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  
  -- Find maximum position of alignment character
  local max_pos = 0
  for _, line in ipairs(lines) do
    local pos = line:find(vim.pesc(char))
    if pos and pos > max_pos then
      max_pos = pos
    end
  end
  
  -- Align lines
  for i, line in ipairs(lines) do
    local pos = line:find(vim.pesc(char))
    if pos then
      local before = line:sub(1, pos - 1)
      local after = line:sub(pos)
      lines[i] = before .. string.rep(' ', max_pos - pos) .. after
    end
  end
  
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

-- Smart quotes and brackets
M.wrap_selection = function(wrapper)
  local wrappers = {
    ['('] = {'(', ')'},
    ['['] = {'[', ']'},
    ['{'] = {'{', '}'},
    ['"'] = {'"', '"'},
    ["'"] = {"'", "'"},
    ['`'] = {'`', '`'},
    ['<'] = {'<', '>'},
  }
  
  local wrap = wrappers[wrapper]
  if not wrap then
    vim.notify('Unknown wrapper: ' .. wrapper, vim.log.levels.ERROR)
    return
  end
  
  -- Get visual selection positions
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]
  
  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  
  if #lines == 0 then return end
  
  -- Handle single line selection
  if #lines == 1 then
    local line = lines[1]
    local before = line:sub(1, start_col - 1)
    local selection = line:sub(start_col, end_col)
    local after = line:sub(end_col + 1)
    local new_line = before .. wrap[1] .. selection .. wrap[2] .. after
    vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, {new_line})
  else
    -- Handle multi-line selection
    -- Add opening wrapper to first line
    lines[1] = lines[1]:sub(1, start_col - 1) .. wrap[1] .. lines[1]:sub(start_col)
    
    -- Add closing wrapper to last line
    lines[#lines] = lines[#lines]:sub(1, end_col + 1) .. wrap[2] .. lines[#lines]:sub(end_col + 2)
    
    vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, lines)
  end
  
  vim.notify('Wrapped with ' .. wrap[1] .. wrap[2], vim.log.levels.INFO)
end

-- Increment/decrement numbers in selection
M.increment_selection = function(amount)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  
  for line_num = start_pos[2], end_pos[2] do
    local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
    local new_line = line:gsub('(%d+)', function(num)
      return tostring(tonumber(num) + amount)
    end)
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, {new_line})
  end
end

function M.setup()
  -- Case conversion
  vim.keymap.set('v', '<leader>cs', function() M.convert_case('snake') end, { desc = '[C]ase [S]nake_case' })
  vim.keymap.set('v', '<leader>cc', function() M.convert_case('camel') end, { desc = '[C]ase [C]amelCase' })
  vim.keymap.set('v', '<leader>cp', function() M.convert_case('pascal') end, { desc = '[C]ase [P]ascalCase' })
  vim.keymap.set('v', '<leader>ck', function() M.convert_case('kebab') end, { desc = '[C]ase [K]ebab-case' })
  vim.keymap.set('v', '<leader>cu', function() M.convert_case('upper') end, { desc = '[C]ase [U]PPER' })
  vim.keymap.set('v', '<leader>cl', function() M.convert_case('lower') end, { desc = '[C]ase [L]ower' })
  
  -- Line operations
  vim.keymap.set('n', 'gJ', M.join_lines_smart, { desc = 'Smart join lines' })
  
  -- Sort
  vim.keymap.set('v', '<leader>tss', function() M.sort_selection(false) end, { desc = '[T]ext [S]ort [S]election' })
  vim.keymap.set('v', '<leader>tsr', function() M.sort_selection(true) end, { desc = '[T]ext [S]ort [R]everse' })
  
  -- Align
  vim.keymap.set('v', '<leader>a', M.align_text, { desc = '[A]lign text' })
  
  -- Wrapping functionality moved to nvim-surround plugin
  -- Use 'S' in visual mode or <leader>w shortcuts from simple-surround.lua
  -- Keeping custom wrap_selection function for backward compatibility but not mapping keys
  
  -- Number operations
  vim.keymap.set('v', '<C-a>', function() M.increment_selection(1) end, { desc = 'Increment numbers' })
  vim.keymap.set('v', '<C-x>', function() M.increment_selection(-1) end, { desc = 'Decrement numbers' })
end

return M