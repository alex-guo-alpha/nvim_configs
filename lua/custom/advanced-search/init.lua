local M = {}

-- Search history
M.search_history = {}

-- Visual star search (search for visual selection)
M.visual_star_search = function()
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' then return end
  
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
  
  if #lines == 0 then return end
  
  local selection = lines[1]
  if #lines == 1 then
    selection = selection:sub(start_pos[3], end_pos[3])
  end
  
  -- Escape special characters
  selection = vim.fn.escape(selection, '\\/.*$^~[]')
  selection = selection:gsub('\n', '\\n')
  
  vim.fn.setreg('/', '\\V' .. selection)
  vim.cmd('normal! n')
end

-- Interactive search and replace with preview
M.search_replace_preview = function()
  local search_term = vim.fn.input('Search: ', vim.fn.getreg('/'))
  if search_term == '' then return end
  
  local replace_term = vim.fn.input('Replace with: ')
  if replace_term == nil then return end
  
  -- Save current position
  local save_pos = vim.fn.getpos('.')
  
  -- Highlight all matches
  vim.fn.setreg('/', search_term)
  vim.cmd('set hlsearch')
  
  -- Show preview
  vim.cmd('redraw')
  local confirm = vim.fn.input('Replace all? (y/n/p[review each]): ')
  
  if confirm == 'y' then
    vim.cmd('%s/' .. search_term .. '/' .. replace_term .. '/g')
  elseif confirm == 'p' then
    vim.cmd('%s/' .. search_term .. '/' .. replace_term .. '/gc')
  else
    vim.fn.setpos('.', save_pos)
    vim.notify('Replace cancelled', vim.log.levels.INFO)
  end
  
  -- Add to history
  table.insert(M.search_history, {
    search = search_term,
    replace = replace_term,
    time = os.time()
  })
end

-- Search in project (using ripgrep)
M.project_search_replace = function()
  local search_term = vim.fn.input('Project search: ')
  if search_term == '' then return end
  
  -- Use telescope to show results
  require('telescope.builtin').grep_string({
    search = search_term,
    prompt_title = 'Project Search: ' .. search_term,
  })
end

-- Incremental selection expand
M.expand_selection = function()
  if vim.fn.mode() ~= 'v' then
    vim.cmd('normal! viw')
  else
    vim.cmd('normal! ')
    vim.cmd('normal! va{')
  end
end

-- Search for word under cursor in all buffers
M.search_all_buffers = function()
  local word = vim.fn.expand('<cword>')
  local results = {}
  
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local filename = vim.api.nvim_buf_get_name(buf)
      
      for lnum, line in ipairs(lines) do
        if line:find(word, 1, true) then
          table.insert(results, {
            filename = filename,
            lnum = lnum,
            text = line,
          })
        end
      end
    end
  end
  
  if #results > 0 then
    vim.fn.setqflist(results)
    vim.cmd('copen')
  else
    vim.notify('No results found for: ' .. word, vim.log.levels.INFO)
  end
end

-- Recent searches menu
M.show_search_history = function()
  if #M.search_history == 0 then
    vim.notify('No search history', vim.log.levels.INFO)
    return
  end
  
  local items = {}
  for i = #M.search_history, math.max(1, #M.search_history - 10), -1 do
    local entry = M.search_history[i]
    table.insert(items, string.format('%s → %s', entry.search, entry.replace))
  end
  
  vim.ui.select(items, {
    prompt = 'Recent searches:',
  }, function(choice, idx)
    if choice then
      local entry = M.search_history[#M.search_history - idx + 1]
      vim.fn.setreg('/', entry.search)
      vim.cmd('set hlsearch')
    end
  end)
end

function M.setup()
  -- Visual mode search
  vim.keymap.set('v', '*', M.visual_star_search, { desc = 'Search for visual selection' })
  
  -- Advanced search/replace
  vim.keymap.set('n', '<leader>sR', M.search_replace_preview, { desc = '[S]earch [R]eplace with preview' })
  vim.keymap.set('n', '<leader>sP', M.project_search_replace, { desc = '[S]earch [P]roject replace' })
  vim.keymap.set('n', '<leader>sb', M.search_all_buffers, { desc = '[S]earch all [B]uffers' })
  vim.keymap.set('n', '<leader>sH', M.show_search_history, { desc = '[S]earch [H]istory' })
  
  -- Selection expansion
  vim.keymap.set({'n', 'v'}, '<C-Space>', M.expand_selection, { desc = 'Expand selection' })
  
  -- Better search experience
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.inccommand = 'split'  -- Show substitution preview
end

return M