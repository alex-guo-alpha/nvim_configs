local M = {}

-- Enhanced markdown workflow configurations
function M.setup()
  -- Markdown-specific settings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      -- Better wrapping for prose
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.breakindent = true
      vim.opt_local.showbreak = "↪ "
      
      -- Better text width for writing
      vim.opt_local.textwidth = 0  -- Disable automatic line breaking
      -- vim.opt_local.colorcolumn = "80"  -- Commented out to remove vertical line
      
      -- Enable spell checking
      vim.opt_local.spell = true
      vim.opt_local.spelllang = { "en_us" }
      
      -- Conceal for better readability
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = "nc"
      
      -- Better indentation for lists
      vim.opt_local.autoindent = true
      vim.opt_local.smartindent = true
      
      -- Disable auto-commenting
      vim.opt_local.formatoptions:remove("c")
      vim.opt_local.formatoptions:remove("r")
      vim.opt_local.formatoptions:remove("o")
      
      -- Fix undo behavior
      vim.opt_local.undofile = true
      vim.opt_local.undolevels = 1000
    end,
  })
  
  -- Enhanced markdown keymaps
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local opts = { buffer = true }
      
      -- Text formatting
      vim.keymap.set('v', '<leader>mb', 'c**<C-r>"**<Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [B]old' }))
      vim.keymap.set('v', '<leader>mi', 'c*<C-r>"*<Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [I]talic' }))
      vim.keymap.set('v', '<leader>mc', 'c`<C-r>"`<Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [C]ode' }))
      vim.keymap.set('v', '<leader>ms', 'c~~<C-r>"~~<Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [S]trikethrough' }))
      
      -- Links and references
      vim.keymap.set('v', '<leader>ml', 'c[](<C-r>")<Esc>F[a', vim.tbl_extend('force', opts, { desc = '[M]arkdown [L]ink' }))
      vim.keymap.set('v', '<leader>mw', 'c[[<C-r>"]]<Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [W]iki link' }))
      
      -- Checkboxes
      vim.keymap.set('n', '<leader>mx', function()
        local line = vim.api.nvim_get_current_line()
        local new_line
        if line:match('^%s*- %[ %]') then
          new_line = line:gsub('^(%s*- )%[ %]', '%1[x]')
        elseif line:match('^%s*- %[x%]') then
          new_line = line:gsub('^(%s*- )%[x%]', '%1[ ]')
        else
          -- Add checkbox if not present
          new_line = line:gsub('^(%s*- )', '%1[ ] ')
          if new_line == line then
            -- No list item, add one
            new_line = '- [ ] ' .. line:gsub('^%s*', '')
          end
        end
        vim.api.nvim_set_current_line(new_line)
      end, vim.tbl_extend('force', opts, { desc = '[M]arkdown toggle checkbo[X]' }))
      
      -- Headers
      vim.keymap.set('n', '<leader>m1', 'I# <Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown H[1]' }))
      vim.keymap.set('n', '<leader>m2', 'I## <Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown H[2]' }))
      vim.keymap.set('n', '<leader>m3', 'I### <Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown H[3]' }))
      vim.keymap.set('n', '<leader>m4', 'I#### <Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown H[4]' }))
      
      -- Code blocks
      vim.keymap.set('n', '<leader>mcc', 'o```<CR>```<Esc>ka', vim.tbl_extend('force', opts, { desc = '[M]arkdown [C]ode [C]lock' }))
      
      -- Horizontal rule
      vim.keymap.set('n', '<leader>mhr', 'o---<Esc>', vim.tbl_extend('force', opts, { desc = '[M]arkdown [H]orizontal [R]ule' }))
      
      -- Better bullet point handling
      vim.keymap.set('i', '<Tab>', function()
        local line = vim.api.nvim_get_current_line()
        if line:match('^%s*[%-*+] ') then
          -- Indent the list item
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-t>', true, false, true), 'n', false)
        else
          -- Normal tab
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Smart tab in lists' }))
      
      vim.keymap.set('i', '<S-Tab>', function()
        local line = vim.api.nvim_get_current_line()
        if line:match('^%s*[%-*+] ') then
          -- Dedent the list item
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-d>', true, false, true), 'n', false)
        else
          -- Normal shift-tab
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true), 'n', false)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Smart shift-tab in lists' }))
      
      -- Quick bullet toggle
      vim.keymap.set('n', '<leader>m-', function()
        local line = vim.api.nvim_get_current_line()
        if line:match('^%s*- ') then
          -- Already a bullet, do nothing
        else
          -- Add bullet at beginning of line
          vim.api.nvim_set_current_line('- ' .. line:gsub('^%s*', ''))
        end
      end, vim.tbl_extend('force', opts, { desc = '[M]arkdown add [-] bullet' }))
      
      -- Smart enter in lists
      vim.keymap.set('i', '<CR>', function()
        local line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        
        -- Check if we're in a list item
        if line:match('^%s*[%-*+] ') or line:match('^%s*%d+%. ') or line:match('^%s*- %[.%] ') then
          local indent = line:match('^%s*')
          local marker
          
          if line:match('^%s*- %[ %] ') then
            marker = '- [ ] '
          elseif line:match('^%s*- %[x%] ') then
            marker = '- [ ] '
          elseif line:match('^%s*[%-*+] ') then
            marker = line:match('^%s*([%-*+] )')
          elseif line:match('^%s*%d+%. ') then
            local num = tonumber(line:match('^%s*(%d+)%.')) + 1
            marker = num .. '. '
          end
          
          -- If line is empty except for marker, remove it
          if line:match('^%s*[%-*+]%s*$') or line:match('^%s*%d+%.%s*$') or line:match('^%s*- %[.%]%s*$') then
            vim.api.nvim_set_current_line('')
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>' .. indent .. marker, true, false, true), 'n', false)
          end
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
        end
      end, vim.tbl_extend('force', opts, { desc = 'Smart enter in lists' }))
    end,
  })
  
  -- Auto-save for markdown files (with debounce to preserve undo)
  local timer = nil
  vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    pattern = "*.md",
    callback = function()
      if timer then
        vim.fn.timer_stop(timer)
      end
      timer = vim.fn.timer_start(1000, function()
        if vim.bo.modified then
          vim.cmd("silent! write")
        end
      end)
    end,
  })
  
  -- Markdown folding
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt_local.foldenable = false -- Start with all folds open
      vim.opt_local.foldlevel = 99
    end,
  })
  
  -- Quick note creation
  vim.keymap.set('n', '<leader>nq', function()
    local title = vim.fn.input('Quick note title: ')
    if title ~= '' then
      vim.cmd('ObsidianNew ' .. title)
      vim.cmd('ObsidianTemplate quick-note')
    end
  end, { desc = '[N]ew [Q]uick note' })
  
  -- Daily note shortcut
  vim.keymap.set('n', '<leader>nd', function()
    vim.cmd('ObsidianToday')
    -- Check if template should be applied
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines == 1 and lines[1] == '' then
      vim.cmd('ObsidianTemplate daily')
    end
  end, { desc = '[N]ew [D]aily note' })
  
  -- Meeting note shortcut
  vim.keymap.set('n', '<leader>nm', function()
    local title = vim.fn.input('Meeting title: ')
    if title ~= '' then
      vim.cmd('ObsidianNew Meeting-' .. title:gsub(' ', '-'))
      vim.cmd('ObsidianTemplate meeting')
    end
  end, { desc = '[N]ew [M]eeting note' })
  
  -- Project note shortcut
  vim.keymap.set('n', '<leader>np', function()
    local title = vim.fn.input('Project title: ')
    if title ~= '' then
      vim.cmd('ObsidianNew Project-' .. title:gsub(' ', '-'))
      vim.cmd('ObsidianTemplate project')
    end
  end, { desc = '[N]ew [P]roject note' })
  
  -- Word count function for markdown
  vim.api.nvim_create_user_command('WordCount', function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local text = table.concat(lines, ' ')
    -- Remove markdown syntax for accurate count
    text = text:gsub('%[.-%]%(.-%)','') -- links
    text = text:gsub('%*%*(.-)%*%*','%1') -- bold
    text = text:gsub('%*(.-)%*','%1') -- italic
    text = text:gsub('`.-`','') -- code
    text = text:gsub('#+ ','') -- headers
    
    local word_count = 0
    for word in text:gmatch('%S+') do
      word_count = word_count + 1
    end
    
    local char_count = #text:gsub('%s','')
    vim.notify(string.format('Words: %d, Characters: %d', word_count, char_count), vim.log.levels.INFO)
  end, { desc = 'Count words and characters' })
  
  vim.keymap.set('n', '<leader>mw', '<cmd>WordCount<cr>', { desc = '[M]arkdown [W]ord count' })
  
  vim.notify("Enhanced markdown workflow configured!", vim.log.levels.INFO)
end

return M