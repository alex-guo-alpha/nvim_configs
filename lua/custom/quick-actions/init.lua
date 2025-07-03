local M = {}

-- Quick file operations
M.duplicate_line = function()
  local line = vim.api.nvim_get_current_line()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, {line})
end

M.delete_blank_lines = function()
  local save = vim.fn.winsaveview()
  vim.cmd([[silent! %s/^\s*$//g]])
  vim.cmd([[silent! %s/\n\+/\r/g]])
  vim.fn.winrestview(save)
  vim.notify("Removed blank lines", vim.log.levels.INFO)
end

M.strip_trailing_whitespace = function()
  local save = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.winrestview(save)
  vim.notify("Stripped trailing whitespace", vim.log.levels.INFO)
end

-- Quick navigation
M.goto_last_change = function()
  local pos = vim.fn.getpos("'.")
  if pos[2] > 0 then
    vim.cmd("normal! `.")
  end
end

-- Buffer operations
M.close_other_buffers = function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, {force = false})
    end
  end
  vim.notify("Closed other buffers", vim.log.levels.INFO)
end

-- Smart rename (renames word/symbol project-wide)
M.smart_rename = function()
  -- Check if LSP is available
  local clients = vim.lsp.get_active_clients({bufnr = 0})
  if #clients > 0 then
    vim.lsp.buf.rename()
  else
    -- Fallback to basic rename
    local old_name = vim.fn.expand('<cword>')
    vim.ui.input({
      prompt = 'Rename "' .. old_name .. '" to: ',
      default = old_name,
    }, function(new_name)
      if new_name and new_name ~= old_name then
        vim.cmd(':%s/\\<' .. vim.fn.escape(old_name, '/\\') .. '\\>/' .. vim.fn.escape(new_name, '/\\') .. '/gc')
      end
    end)
  end
end

-- Quick terminal commands
M.run_current_file = function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand('%')
  local cmd = nil
  
  local runners = {
    python = 'python3',
    javascript = 'node',
    typescript = 'tsx',
    lua = 'lua',
    sh = 'bash',
    go = 'go run',
    rust = 'cargo run',
  }
  
  if runners[ft] then
    cmd = runners[ft] .. ' ' .. file
    vim.cmd('TermExec cmd="' .. cmd .. '"')
  else
    vim.notify("No runner configured for " .. ft, vim.log.levels.WARN)
  end
end

-- Copy file path/name
M.copy_file_path = function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path, vim.log.levels.INFO)
end

M.copy_file_name = function()
  local name = vim.fn.expand('%:t')
  vim.fn.setreg('+', name)
  vim.notify('Copied: ' .. name, vim.log.levels.INFO)
end

-- Quick fix/quickfix navigation
M.toggle_quickfix = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end

function M.setup()
  -- File operations
  vim.keymap.set('n', '<leader>qd', M.duplicate_line, { desc = '[Q]uick [D]uplicate line' })
  vim.keymap.set('n', '<leader>qb', M.delete_blank_lines, { desc = '[Q]uick delete [B]lank lines' })
  vim.keymap.set('n', '<leader>qw', M.strip_trailing_whitespace, { desc = '[Q]uick strip [W]hitespace' })
  
  -- Navigation
  vim.keymap.set('n', '<leader>ql', M.goto_last_change, { desc = '[Q]uick goto [L]ast change' })
  
  -- Buffer operations
  vim.keymap.set('n', '<leader>qo', M.close_other_buffers, { desc = '[Q]uick close [O]ther buffers' })
  
  -- Smart operations
  vim.keymap.set('n', '<leader>qr', M.smart_rename, { desc = '[Q]uick [R]ename (LSP)' })
  vim.keymap.set('n', '<leader>qx', M.run_current_file, { desc = '[Q]uick e[X]ecute file' })
  
  -- Copy operations
  vim.keymap.set('n', '<leader>qp', M.copy_file_path, { desc = '[Q]uick copy [P]ath' })
  vim.keymap.set('n', '<leader>qn', M.copy_file_name, { desc = '[Q]uick copy file[N]ame' })
  
  -- Quickfix
  vim.keymap.set('n', '<leader>qq', M.toggle_quickfix, { desc = '[Q]uick toggle [Q]uickfix' })
end

return M