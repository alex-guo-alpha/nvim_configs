local M = {}

-- Smart window splitting
M.smart_split = function()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)
  
  if width > height * 2.5 then
    vim.cmd('vsplit')
  else
    vim.cmd('split')
  end
end

-- Window zoom toggle
M.zoomed = false
M.zoom_winrestcmd = nil

M.toggle_zoom = function()
  if M.zoomed then
    vim.cmd(M.zoom_winrestcmd)
    M.zoomed = false
  else
    M.zoom_winrestcmd = vim.fn.winrestcmd()
    vim.cmd('resize')
    vim.cmd('vertical resize')
    M.zoomed = true
  end
end

-- Smart window navigation with creation
M.smart_move = function(direction)
  local winnr = vim.fn.winnr()
  vim.cmd('wincmd ' .. direction)
  
  if winnr == vim.fn.winnr() then
    if direction == 'h' then
      vim.cmd('vsplit')
      vim.cmd('wincmd h')
    elseif direction == 'l' then
      vim.cmd('vsplit')
    elseif direction == 'j' then
      vim.cmd('split')
    elseif direction == 'k' then
      vim.cmd('split')
      vim.cmd('wincmd k')
    end
  end
end

-- Window swapping
M.swap_window = function(direction)
  local winnr = vim.fn.winnr()
  vim.cmd('wincmd ' .. direction)
  local target_winnr = vim.fn.winnr()
  
  if winnr ~= target_winnr then
    local buf1 = vim.fn.winbufnr(winnr)
    local buf2 = vim.fn.winbufnr(target_winnr)
    
    vim.cmd(winnr .. 'wincmd w')
    vim.cmd('buffer ' .. buf2)
    
    vim.cmd(target_winnr .. 'wincmd w')
    vim.cmd('buffer ' .. buf1)
  end
end

-- Auto-resize windows
M.auto_resize = function()
  local windows = vim.fn.winnr('$')
  if windows > 1 then
    vim.cmd('wincmd =')
  end
end

function M.setup()
  -- Smart splits
  vim.keymap.set('n', '<leader>ws', M.smart_split, { desc = '[W]indow [S]mart split' })
  vim.keymap.set('n', '<leader>wz', M.toggle_zoom, { desc = '[W]indow [Z]oom toggle' })
  
  -- Smart navigation (creates window if doesn't exist)
  vim.keymap.set('n', '<C-A-h>', function() M.smart_move('h') end, { desc = 'Smart move left' })
  vim.keymap.set('n', '<C-A-j>', function() M.smart_move('j') end, { desc = 'Smart move down' })
  vim.keymap.set('n', '<C-A-k>', function() M.smart_move('k') end, { desc = 'Smart move up' })
  vim.keymap.set('n', '<C-A-l>', function() M.smart_move('l') end, { desc = 'Smart move right' })
  
  -- Window swapping
  vim.keymap.set('n', '<leader>wh', function() M.swap_window('h') end, { desc = '[W]indow swap left' })
  vim.keymap.set('n', '<leader>wj', function() M.swap_window('j') end, { desc = '[W]indow swap down' })
  vim.keymap.set('n', '<leader>wk', function() M.swap_window('k') end, { desc = '[W]indow swap up' })
  vim.keymap.set('n', '<leader>wl', function() M.swap_window('l') end, { desc = '[W]indow swap right' })
  
  -- Auto-resize on window change
  vim.api.nvim_create_autocmd('VimResized', {
    callback = M.auto_resize,
  })
end

return M