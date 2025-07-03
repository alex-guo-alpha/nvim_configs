local M = {}

M.session_dir = vim.fn.stdpath('data') .. '/sessions/'

local function get_session_name()
  local cwd = vim.fn.getcwd()
  return cwd:gsub('/', '_'):gsub(':', '_')
end

M.save_session = function(name)
  vim.fn.mkdir(M.session_dir, 'p')
  local session_name = name or get_session_name()
  local session_file = M.session_dir .. session_name .. '.vim'
  
  vim.cmd('mksession! ' .. session_file)
  vim.notify('Session saved: ' .. session_name, vim.log.levels.INFO)
end

M.load_session = function(name)
  local session_name = name or get_session_name()
  local session_file = M.session_dir .. session_name .. '.vim'
  
  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd('%bdelete!')
    vim.cmd('source ' .. session_file)
    vim.notify('Session loaded: ' .. session_name, vim.log.levels.INFO)
  else
    vim.notify('No session found for: ' .. session_name, vim.log.levels.WARN)
  end
end

M.list_sessions = function()
  local sessions = vim.fn.glob(M.session_dir .. '*.vim', false, true)
  local session_names = {}
  
  for _, session in ipairs(sessions) do
    local name = vim.fn.fnamemodify(session, ':t:r')
    table.insert(session_names, name)
  end
  
  if #session_names == 0 then
    vim.notify('No saved sessions', vim.log.levels.INFO)
    return
  end
  
  vim.ui.select(session_names, {
    prompt = 'Select session:',
  }, function(choice)
    if choice then
      M.load_session(choice)
    end
  end)
end

M.delete_session = function()
  local sessions = vim.fn.glob(M.session_dir .. '*.vim', false, true)
  local session_names = {}
  
  for _, session in ipairs(sessions) do
    local name = vim.fn.fnamemodify(session, ':t:r')
    table.insert(session_names, name)
  end
  
  if #session_names == 0 then
    vim.notify('No saved sessions', vim.log.levels.INFO)
    return
  end
  
  vim.ui.select(session_names, {
    prompt = 'Delete session:',
  }, function(choice)
    if choice then
      vim.fn.delete(M.session_dir .. choice .. '.vim')
      vim.notify('Session deleted: ' .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Auto-save session on exit
M.auto_save_enabled = false

M.toggle_auto_save = function()
  M.auto_save_enabled = not M.auto_save_enabled
  vim.notify('Session auto-save: ' .. (M.auto_save_enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

function M.setup()
  -- Session commands
  vim.api.nvim_create_user_command('SessionSave', function(opts)
    M.save_session(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?' })
  
  vim.api.nvim_create_user_command('SessionLoad', function(opts)
    M.load_session(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?' })
  
  vim.api.nvim_create_user_command('SessionList', M.list_sessions, {})
  vim.api.nvim_create_user_command('SessionDelete', M.delete_session, {})
  
  -- Keymaps
  vim.keymap.set('n', '<leader>Ss', function() M.save_session() end, { desc = '[S]ession [s]ave' })
  vim.keymap.set('n', '<leader>Sl', M.list_sessions, { desc = '[S]ession [l]ist' })
  vim.keymap.set('n', '<leader>Sa', M.toggle_auto_save, { desc = '[S]ession [a]uto-save toggle' })
  
  -- Auto-save on exit if enabled
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      if M.auto_save_enabled then
        M.save_session()
      end
    end,
  })
end

return M