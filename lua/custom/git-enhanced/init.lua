local M = {}

-- Git blame for current line
M.git_blame_line = function()
  local line = vim.fn.line('.')
  local file = vim.fn.expand('%')
  
  local result = vim.fn.system('git blame -L ' .. line .. ',' .. line .. ' --porcelain ' .. file)
  
  if vim.v.shell_error ~= 0 then
    vim.notify('Git blame failed', vim.log.levels.ERROR)
    return
  end
  
  local commit = result:match('^(%x+)')
  local author = result:match('author (.-)%s*\n')
  local time = result:match('author%-time (%d+)')
  
  if time then
    time = os.date('%Y-%m-%d', tonumber(time))
  end
  
  local message = string.format('%s - %s (%s)', commit:sub(1, 8), author or 'Unknown', time or 'Unknown')
  vim.notify(message, vim.log.levels.INFO)
end

-- Interactive git add (stage hunks)
M.stage_hunk = function()
  local gs = package.loaded.gitsigns
  if gs then
    gs.stage_hunk()
    vim.notify('Hunk staged', vim.log.levels.INFO)
  else
    vim.notify('Gitsigns not loaded', vim.log.levels.ERROR)
  end
end

-- Git time machine (view file history)
M.time_machine = function()
  local file = vim.fn.expand('%:p')
  local commits = vim.fn.systemlist('git log --pretty=format:"%h|%ad|%s|%an" --date=short ' .. file)
  
  if vim.v.shell_error ~= 0 then
    vim.notify('No git history for this file', vim.log.levels.WARN)
    return
  end
  
  local items = {}
  for _, commit in ipairs(commits) do
    local parts = vim.split(commit, '|')
    if #parts >= 4 then
      table.insert(items, string.format('[%s] %s - %s (%s)', parts[1], parts[2], parts[3], parts[4]))
    end
  end
  
  vim.ui.select(items, {
    prompt = 'Select commit to view:',
  }, function(choice, idx)
    if choice then
      local commit = commits[idx]:match('^(%x+)')
      vim.cmd('Gitsigns diffthis ' .. commit)
    end
  end)
end

-- Quick commit with conventional commits
M.quick_commit = function()
  local commit_types = {
    'feat: ',
    'fix: ',
    'docs: ',
    'style: ',
    'refactor: ',
    'perf: ',
    'test: ',
    'chore: ',
    'build: ',
    'ci: ',
  }
  
  vim.ui.select(commit_types, {
    prompt = 'Commit type:',
  }, function(type_choice)
    if not type_choice then return end
    
    vim.ui.input({
      prompt = 'Commit message: ' .. type_choice,
    }, function(message)
      if message then
        local full_message = type_choice .. message
        vim.fn.system('git add -A && git commit -m "' .. full_message .. '"')
        
        if vim.v.shell_error == 0 then
          vim.notify('Committed: ' .. full_message, vim.log.levels.INFO)
        else
          vim.notify('Commit failed', vim.log.levels.ERROR)
        end
      end
    end)
  end)
end

-- Git stash operations
M.stash_menu = function()
  local stashes = vim.fn.systemlist('git stash list')
  
  if #stashes == 0 then
    local action = vim.fn.confirm('No stashes. Create one?', '&Yes\n&No', 1)
    if action == 1 then
      local message = vim.fn.input('Stash message: ')
      vim.fn.system('git stash push -m "' .. message .. '"')
      vim.notify('Changes stashed', vim.log.levels.INFO)
    end
    return
  end
  
  local actions = {'Apply', 'Pop', 'Drop', 'Show'}
  vim.ui.select(actions, {
    prompt = 'Stash action:',
  }, function(action)
    if not action then return end
    
    vim.ui.select(stashes, {
      prompt = 'Select stash:',
    }, function(stash, idx)
      if not stash then return end
      
      local stash_ref = 'stash@{' .. (idx - 1) .. '}'
      if action == 'Apply' then
        vim.fn.system('git stash apply ' .. stash_ref)
      elseif action == 'Pop' then
        vim.fn.system('git stash pop ' .. stash_ref)
      elseif action == 'Drop' then
        vim.fn.system('git stash drop ' .. stash_ref)
      elseif action == 'Show' then
        vim.cmd('Git stash show -p ' .. stash_ref)
      end
      
      vim.notify(action .. ' stash: ' .. stash_ref, vim.log.levels.INFO)
    end)
  end)
end

-- Cherry-pick helper
M.cherry_pick = function()
  local branch = vim.fn.input('Branch to pick from: ')
  if branch == '' then return end
  
  local commits = vim.fn.systemlist('git log --oneline ' .. branch .. ' --not HEAD')
  
  if #commits == 0 then
    vim.notify('No commits to cherry-pick', vim.log.levels.INFO)
    return
  end
  
  vim.ui.select(commits, {
    prompt = 'Select commit to cherry-pick:',
  }, function(choice)
    if choice then
      local commit = choice:match('^(%x+)')
      vim.fn.system('git cherry-pick ' .. commit)
      
      if vim.v.shell_error == 0 then
        vim.notify('Cherry-picked: ' .. commit, vim.log.levels.INFO)
      else
        vim.notify('Cherry-pick failed', vim.log.levels.ERROR)
      end
    end
  end)
end

function M.setup()
  -- Git operations
  vim.keymap.set('n', '<leader>gb', M.git_blame_line, { desc = '[G]it [B]lame line' })
  vim.keymap.set('n', '<leader>gt', M.time_machine, { desc = '[G]it [T]ime machine' })
  vim.keymap.set('n', '<leader>gc', M.quick_commit, { desc = '[G]it [C]ommit (conventional)' })
  vim.keymap.set('n', '<leader>gS', M.stash_menu, { desc = '[G]it [S]tash menu' })
  vim.keymap.set('n', '<leader>gp', M.cherry_pick, { desc = '[G]it cherry-[P]ick' })
  
  -- Hunk operations (if gitsigns is available)
  vim.keymap.set('n', '<leader>hs', M.stage_hunk, { desc = '[H]unk [S]tage' })
end

return M