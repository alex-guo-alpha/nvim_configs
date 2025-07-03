local M = {}

-- Directory history management
local history = {
  dirs = {},
  current = 0,
  max_history = 100,
}

-- Initialize plugin
function M.setup(opts)
  opts = opts or {}
  history.max_history = opts.max_history or 100
  
  -- Initialize with current directory
  table.insert(history.dirs, vim.fn.getcwd())
  history.current = 1
  
  -- Set up commands
  M._setup_commands()
  
  -- Set up autocommands
  M._setup_autocmds()
end

-- Helper function to update history
local function add_to_history(dir)
  -- Remove any forward history when navigating to new directory
  while #history.dirs > history.current do
    table.remove(history.dirs)
  end
  
  -- Add new directory
  table.insert(history.dirs, dir)
  history.current = #history.dirs
  
  -- Limit history size
  if #history.dirs > history.max_history then
    table.remove(history.dirs, 1)
    history.current = history.current - 1
  end
end

-- Navigate to directory
function M.cd(path)
  local target_dir
  
  if not path or path == "" then
    target_dir = vim.fn.expand("~")
  elseif path == "-" then
    -- Go to previous directory (like shell cd -)
    if history.current > 1 then
      return M.back()
    else
      vim.notify("No previous directory", vim.log.levels.WARN)
      return
    end
  else
    target_dir = vim.fn.expand(path)
  end
  
  -- Check if directory exists
  if vim.fn.isdirectory(target_dir) == 0 then
    vim.notify("Directory does not exist: " .. target_dir, vim.log.levels.ERROR)
    return
  end
  
  -- Change directory
  local ok, err = pcall(vim.cmd.cd, target_dir)
  if not ok then
    vim.notify("Failed to change directory: " .. err, vim.log.levels.ERROR)
    return
  end
  
  -- Update history
  add_to_history(vim.fn.getcwd())
  
  -- Notify
  vim.notify("Changed to: " .. vim.fn.getcwd(), vim.log.levels.INFO)
end

-- Go back in history
function M.back()
  if history.current > 1 then
    history.current = history.current - 1
    local target = history.dirs[history.current]
    vim.cmd.cd(target)
    vim.notify("Back to: " .. target, vim.log.levels.INFO)
  else
    vim.notify("No previous directory in history", vim.log.levels.WARN)
  end
end

-- Go forward in history
function M.forward()
  if history.current < #history.dirs then
    history.current = history.current + 1
    local target = history.dirs[history.current]
    vim.cmd.cd(target)
    vim.notify("Forward to: " .. target, vim.log.levels.INFO)
  else
    vim.notify("No next directory in history", vim.log.levels.WARN)
  end
end

-- Go up one directory
function M.up(levels)
  levels = levels or 1
  local current = vim.fn.getcwd()
  local parts = vim.split(current, "/", { trimempty = true })
  
  -- Remove specified number of levels
  for _ = 1, math.min(levels, #parts) do
    table.remove(parts)
  end
  
  local target = "/" .. table.concat(parts, "/")
  M.cd(target)
end

-- Go to project root (git root or current)
function M.root()
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error == 0 and git_root ~= "" then
    M.cd(git_root)
  else
    vim.notify("Not in a git repository", vim.log.levels.WARN)
  end
end

-- Show directory history
function M.show_history()
  local lines = {}
  for i, dir in ipairs(history.dirs) do
    local prefix = i == history.current and "> " or "  "
    table.insert(lines, prefix .. i .. ": " .. dir)
  end
  
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Jump to specific history index
function M.jump_to_history(index)
  if index > 0 and index <= #history.dirs then
    history.current = index
    vim.cmd.cd(history.dirs[index])
    vim.notify("Jumped to: " .. history.dirs[index], vim.log.levels.INFO)
  else
    vim.notify("Invalid history index", vim.log.levels.ERROR)
  end
end

-- Telescope integration
function M.telescope_dirs()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope not found", vim.log.levels.ERROR)
    return
  end
  
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  
  pickers.new({}, {
    prompt_title = "Directory History",
    finder = finders.new_table({
      results = history.dirs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          M.cd(selection.value)
        end
      end)
      return true
    end,
  }):find()
end

-- Telescope integration for browsing directories
function M.telescope_browse()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope not found", vim.log.levels.ERROR)
    return
  end
  
  require("telescope.builtin").find_files({
    prompt_title = "Browse Directories",
    find_command = { "find", ".", "-type", "d", "-not", "-path", "*/.*" },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          M.cd(selection.path or selection[1])
        end
      end)
      return true
    end,
  })
end

-- Setup commands
function M._setup_commands()
  -- Basic navigation
  vim.api.nvim_create_user_command("Cd", function(opts)
    M.cd(opts.args)
  end, { nargs = "?", complete = "dir", desc = "Change directory" })
  
  vim.api.nvim_create_user_command("CdBack", function()
    M.back()
  end, { desc = "Go back in directory history" })
  
  vim.api.nvim_create_user_command("CdForward", function()
    M.forward()
  end, { desc = "Go forward in directory history" })
  
  vim.api.nvim_create_user_command("CdUp", function(opts)
    local levels = tonumber(opts.args) or 1
    M.up(levels)
  end, { nargs = "?", desc = "Go up directories" })
  
  vim.api.nvim_create_user_command("CdRoot", function()
    M.root()
  end, { desc = "Go to project root" })
  
  vim.api.nvim_create_user_command("CdHistory", function()
    M.show_history()
  end, { desc = "Show directory history" })
  
  vim.api.nvim_create_user_command("CdJump", function(opts)
    local index = tonumber(opts.args)
    if index then
      M.jump_to_history(index)
    else
      vim.notify("Please provide a history index", vim.log.levels.ERROR)
    end
  end, { nargs = 1, desc = "Jump to history index" })
  
  -- Telescope commands
  vim.api.nvim_create_user_command("CdPicker", function()
    M.telescope_dirs()
  end, { desc = "Pick from directory history" })
  
  vim.api.nvim_create_user_command("CdBrowse", function()
    M.telescope_browse()
  end, { desc = "Browse and change directory" })
end

-- Setup autocommands
function M._setup_autocmds()
  local group = vim.api.nvim_create_augroup("DirNavigator", { clear = true })
  
  -- Update statusline with current directory
  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
      vim.o.statusline = vim.o.statusline
    end,
  })
end

-- Get current directory for statusline
function M.statusline()
  local cwd = vim.fn.getcwd()
  local home = vim.fn.expand("~")
  cwd = cwd:gsub("^" .. home, "~")
  return cwd
end

return M