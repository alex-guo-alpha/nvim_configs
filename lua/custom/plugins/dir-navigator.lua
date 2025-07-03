return {
  "dir-navigator",
  dir = vim.fn.stdpath("config") .. "/lua/custom/dir-navigator",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Optional, for picker functionality
  },
  config = function()
    local nav = require("custom.dir-navigator")
    
    -- Setup with options
    nav.setup({
      max_history = 100, -- Maximum directories to remember
    })
    
    -- Keybindings
    local keymap = vim.keymap.set
    
    -- Basic navigation
    keymap("n", "<leader>cd", function() 
      vim.ui.input({ prompt = "Change directory to: ", completion = "dir" }, function(input)
        if input then nav.cd(input) end
      end)
    end, { desc = "[C]hange [D]irectory" })
    
    keymap("n", "<leader>c-", function() nav.cd("-") end, { desc = "[C]d to previous directory" })
    keymap("n", "<leader>ch", function() nav.cd("~") end, { desc = "[C]d [H]ome" })
    keymap("n", "<leader>cr", function() nav.root() end, { desc = "[C]d to [R]oot (git)" })
    
    -- History navigation
    keymap("n", "<leader>cb", function() nav.back() end, { desc = "[C]d [B]ack" })
    keymap("n", "<leader>cf", function() nav.forward() end, { desc = "[C]d [F]orward" })
    keymap("n", "<leader>cu", function() nav.up() end, { desc = "[C]d [U]p" })
    keymap("n", "<leader>cuu", function() nav.up(2) end, { desc = "[C]d [U]p 2 levels" })
    
    -- Quick navigation shortcuts
    keymap("n", "<M-Left>", function() nav.back() end, { desc = "Directory back" })
    keymap("n", "<M-Right>", function() nav.forward() end, { desc = "Directory forward" })
    keymap("n", "<M-Up>", function() nav.up() end, { desc = "Directory up" })
    
    -- History and pickers
    keymap("n", "<leader>cH", function() nav.show_history() end, { desc = "[C]d [H]istory" })
    keymap("n", "<leader>cp", function() nav.telescope_dirs() end, { desc = "[C]d [P]icker (history)" })
    keymap("n", "<leader>cB", function() nav.telescope_browse() end, { desc = "[C]d [B]rowse" })
    
    -- Quick jumps to common directories
    keymap("n", "<leader>c.", function() nav.cd(".") end, { desc = "[C]d current directory" })
    keymap("n", "<leader>cc", function() nav.cd(vim.fn.stdpath("config")) end, { desc = "[C]d [C]onfig" })
    keymap("n", "<leader>cd", function() nav.cd(vim.fn.expand("~/Downloads")) end, { desc = "[C]d [D]ownloads" })
    keymap("n", "<leader>cD", function() nav.cd(vim.fn.expand("~/Documents")) end, { desc = "[C]d [D]ocuments" })
    keymap("n", "<leader>cP", function() nav.cd(vim.fn.expand("~/projects")) end, { desc = "[C]d [P]rojects" })
    
    -- Additional useful directory shortcuts
    keymap("n", "<leader>ct", function() nav.cd("/tmp") end, { desc = "[C]d [T]mp" })
    keymap("n", "<leader>cn", function() nav.cd(vim.fn.expand("~/notes")) end, { desc = "[C]d [N]otes" })
    
    -- Show current directory in command line
    keymap("n", "<leader>pwd", function() 
      vim.notify("Current: " .. vim.fn.getcwd(), vim.log.levels.INFO) 
    end, { desc = "Print working directory" })
    
    -- Optional: Add to statusline
    -- You can add this to your statusline configuration:
    -- %{luaeval("require('custom.dir-navigator').statusline()")}
  end,
}