local M = {}

-- Extract variable from selection
M.extract_variable = function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  
  if #lines == 0 then return end
  
  local selection = lines[1]
  if #lines == 1 then
    selection = selection:sub(start_pos[3], end_pos[3])
  end
  
  local var_name = vim.fn.input('Variable name: ')
  if var_name == '' then return end
  
  -- Determine language and syntax
  local ft = vim.bo.filetype
  local declaration
  
  if ft == 'javascript' or ft == 'typescript' then
    declaration = 'const ' .. var_name .. ' = ' .. selection .. ';\n'
  elseif ft == 'python' then
    declaration = var_name .. ' = ' .. selection .. '\n'
  elseif ft == 'lua' then
    declaration = 'local ' .. var_name .. ' = ' .. selection .. '\n'
  elseif ft == 'go' then
    declaration = var_name .. ' := ' .. selection .. '\n'
  else
    declaration = var_name .. ' = ' .. selection .. '\n'
  end
  
  -- Insert variable declaration above current line
  local current_line = start_pos[2]
  local indent = lines[1]:match('^%s*')
  vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, {indent .. declaration:gsub('\n', '')})
  
  -- Replace selection with variable name
  if #lines == 1 then
    lines[1] = lines[1]:sub(1, start_pos[3] - 1) .. var_name .. lines[1]:sub(end_pos[3] + 1)
    vim.api.nvim_buf_set_lines(0, current_line, current_line + 1, false, lines)
  end
  
  vim.notify('Extracted to variable: ' .. var_name, vim.log.levels.INFO)
end

-- Extract function from selection
M.extract_function = function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  
  if #lines == 0 then return end
  
  local func_name = vim.fn.input('Function name: ')
  if func_name == '' then return end
  
  local params = vim.fn.input('Parameters (comma-separated): ')
  
  -- Determine language and syntax
  local ft = vim.bo.filetype
  local func_start, func_end, call
  
  if ft == 'javascript' or ft == 'typescript' then
    func_start = 'function ' .. func_name .. '(' .. params .. ') {\n'
    func_end = '\n}'
    call = func_name .. '(' .. params .. ')'
  elseif ft == 'python' then
    func_start = 'def ' .. func_name .. '(' .. params .. '):\n'
    func_end = ''
    call = func_name .. '(' .. params .. ')'
  elseif ft == 'lua' then
    func_start = 'local function ' .. func_name .. '(' .. params .. ')\n'
    func_end = '\nend'
    call = func_name .. '(' .. params .. ')'
  elseif ft == 'go' then
    func_start = 'func ' .. func_name .. '(' .. params .. ') {\n'
    func_end = '\n}'
    call = func_name .. '(' .. params .. ')'
  else
    func_start = func_name .. '(' .. params .. ') {\n'
    func_end = '\n}'
    call = func_name .. '(' .. params .. ')'
  end
  
  -- Get the code to extract
  local code = table.concat(lines, '\n')
  
  -- Create function
  local indent = lines[1]:match('^%s*') or ''
  local func_lines = {indent .. func_start:gsub('\n', '')}
  for _, line in ipairs(lines) do
    table.insert(func_lines, indent .. '  ' .. line)
  end
  table.insert(func_lines, indent .. func_end:gsub('\n', ''))
  
  -- Insert function above current location
  vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, start_pos[2] - 1, false, func_lines)
  vim.api.nvim_buf_set_lines(0, #func_lines + start_pos[2] - 1, '', false, {''})
  
  -- Replace selection with function call
  vim.api.nvim_buf_set_lines(0, #func_lines + start_pos[2], #func_lines + end_pos[2], false, {indent .. call})
  
  vim.notify('Extracted to function: ' .. func_name, vim.log.levels.INFO)
end

-- Inline variable
M.inline_variable = function()
  local word = vim.fn.expand('<cword>')
  local line_num = vim.fn.line('.')
  
  -- Search backwards for variable declaration
  for i = line_num - 1, math.max(1, line_num - 20), -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    
    -- Simple pattern matching for common declarations
    local patterns = {
      'const%s+' .. word .. '%s*=%s*(.+);?$',
      'let%s+' .. word .. '%s*=%s*(.+);?$',
      'var%s+' .. word .. '%s*=%s*(.+);?$',
      'local%s+' .. word .. '%s*=%s*(.+)$',
      word .. '%s*=%s*(.+)$',
      word .. '%s*:=%s*(.+)$',
    }
    
    for _, pattern in ipairs(patterns) do
      local value = line:match(pattern)
      if value then
        -- Remove the declaration line
        vim.api.nvim_buf_set_lines(0, i - 1, i, false, {})
        
        -- Replace all occurrences of the variable
        local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for j, buf_line in ipairs(buf_lines) do
          buf_lines[j] = buf_line:gsub('%f[%w_]' .. word .. '%f[^%w_]', '(' .. value:gsub('%;$', '') .. ')')
        end
        vim.api.nvim_buf_set_lines(0, 0, -1, false, buf_lines)
        
        vim.notify('Inlined variable: ' .. word, vim.log.levels.INFO)
        return
      end
    end
  end
  
  vim.notify('Could not find declaration for: ' .. word, vim.log.levels.WARN)
end

-- Convert between function styles
M.toggle_function_style = function()
  local line = vim.api.nvim_get_current_line()
  local line_num = vim.fn.line('.')
  
  -- Arrow function to regular function
  local arrow_pattern = 'const%s+(%w+)%s*=%s*%((.*)%)%s*=>%s*{'
  local name, params = line:match(arrow_pattern)
  if name and params then
    local new_line = line:gsub(arrow_pattern, 'function %1(%2) {')
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, {new_line})
    vim.notify('Converted to function declaration', vim.log.levels.INFO)
    return
  end
  
  -- Regular function to arrow function
  local func_pattern = 'function%s+(%w+)%s*%((.*)%)%s*{'
  name, params = line:match(func_pattern)
  if name and params then
    local new_line = line:gsub(func_pattern, 'const %1 = (%2) => {')
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, {new_line})
    vim.notify('Converted to arrow function', vim.log.levels.INFO)
    return
  end
  
  vim.notify('No function found on current line', vim.log.levels.WARN)
end

function M.setup()
  -- Refactoring operations
  vim.keymap.set('v', '<leader>rv', M.extract_variable, { desc = '[R]efactor extract [V]ariable' })
  vim.keymap.set('v', '<leader>rf', M.extract_function, { desc = '[R]efactor extract [F]unction' })
  vim.keymap.set('n', '<leader>ri', M.inline_variable, { desc = '[R]efactor [I]nline variable' })
  vim.keymap.set('n', '<leader>rt', M.toggle_function_style, { desc = '[R]efactor [T]oggle function style' })
end

return M