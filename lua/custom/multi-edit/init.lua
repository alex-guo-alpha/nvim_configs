local M = {}

local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

local function perform_operation_on_matches(pattern, operation, word_only)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local matches = {}
  
  -- Add word boundaries if word_only is true and pattern doesn't already have them
  local search_pattern = pattern
  if word_only and not pattern:match('^\\<') and not pattern:match('>$') then
    search_pattern = '\\<' .. pattern .. '\\>'
  end
  
  for line_num, line in ipairs(lines) do
    local start_pos = 1
    while true do
      local match_start, match_end = string.find(line, search_pattern, start_pos)
      if not match_start then break end
      
      table.insert(matches, {
        line = line_num,
        col_start = match_start,
        col_end = match_end,
        text = string.sub(line, match_start, match_end)
      })
      
      start_pos = match_end + 1
    end
  end
  
  if #matches == 0 then
    vim.notify("No matches found for pattern: " .. pattern, vim.log.levels.WARN)
    return
  end
  
  vim.notify("Found " .. #matches .. " matches", vim.log.levels.INFO)
  
  if operation == "delete" then
    for i = #matches, 1, -1 do
      local match = matches[i]
      local line = lines[match.line]
      lines[match.line] = string.sub(line, 1, match.col_start - 1) .. string.sub(line, match.col_end + 1)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify("Deleted all matches", vim.log.levels.INFO)
    
  elseif operation == "replace" then
    local replacement = vim.fn.input("Replace with: ")
    if replacement == "" then return end
    
    for i = #matches, 1, -1 do
      local match = matches[i]
      local line = lines[match.line]
      lines[match.line] = string.sub(line, 1, match.col_start - 1) .. replacement .. string.sub(line, match.col_end + 1)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify("Replaced all matches", vim.log.levels.INFO)
    
  elseif operation == "highlight" then
    local ns_id = vim.api.nvim_create_namespace('multi_edit_highlights')
    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
    
    for _, match in ipairs(matches) do
      vim.api.nvim_buf_add_highlight(buf, ns_id, 'Search', match.line - 1, match.col_start - 1, match.col_end)
    end
    
    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
    end, 3000)
  end
end

function M.delete_all_matches()
  local pattern = vim.fn.input("Pattern to delete (Lua pattern): ")
  if pattern ~= "" then
    local word_only = vim.fn.input("Word boundaries only? (y/n): "):lower() == 'y'
    perform_operation_on_matches(pattern, "delete", word_only)
  end
end

function M.replace_all_matches()
  local pattern = vim.fn.input("Pattern to replace (Lua pattern): ")
  if pattern ~= "" then
    local word_only = vim.fn.input("Word boundaries only? (y/n): "):lower() == 'y'
    perform_operation_on_matches(pattern, "replace", word_only)
  end
end

function M.highlight_all_matches()
  local pattern = vim.fn.input("Pattern to highlight (Lua pattern): ")
  if pattern ~= "" then
    local word_only = vim.fn.input("Word boundaries only? (y/n): "):lower() == 'y'
    perform_operation_on_matches(pattern, "highlight", word_only)
  end
end

function M.operate_on_visual_selection(operation)
  local selection = get_visual_selection()
  local pattern = vim.fn.escape(selection, '.-+*?[](){}^$%')
  local word_only = vim.fn.input("Word boundaries only? (y/n): "):lower() == 'y'
  perform_operation_on_matches(pattern, operation, word_only)
end

function M.setup()
  vim.api.nvim_create_user_command('MultiEditDelete', M.delete_all_matches, {})
  vim.api.nvim_create_user_command('MultiEditReplace', M.replace_all_matches, {})
  vim.api.nvim_create_user_command('MultiEditHighlight', M.highlight_all_matches, {})
  
  vim.keymap.set('n', '<leader>md', M.delete_all_matches, { desc = '[M]ulti-edit [D]elete all matches' })
  vim.keymap.set('n', '<leader>mr', M.replace_all_matches, { desc = '[M]ulti-edit [R]eplace all matches' })
  vim.keymap.set('n', '<leader>mh', M.highlight_all_matches, { desc = '[M]ulti-edit [H]ighlight all matches' })
  
  -- Quick word-only versions
  vim.keymap.set('n', '<leader>mwd', function() 
    local pattern = vim.fn.input("Pattern to delete (words only): ")
    if pattern ~= "" then
      perform_operation_on_matches(pattern, "delete", true)
    end
  end, { desc = '[M]ulti-edit [W]ord [D]elete' })
  
  vim.keymap.set('n', '<leader>mwr', function() 
    local pattern = vim.fn.input("Pattern to replace (words only): ")
    if pattern ~= "" then
      perform_operation_on_matches(pattern, "replace", true)
    end
  end, { desc = '[M]ulti-edit [W]ord [R]eplace' })
  
  vim.keymap.set('x', '<leader>md', function() M.operate_on_visual_selection('delete') end, { desc = '[M]ulti-edit [D]elete selection matches' })
  vim.keymap.set('x', '<leader>mr', function() M.operate_on_visual_selection('replace') end, { desc = '[M]ulti-edit [R]eplace selection matches' })
  vim.keymap.set('x', '<leader>mh', function() M.operate_on_visual_selection('highlight') end, { desc = '[M]ulti-edit [H]ighlight selection matches' })
end

return M