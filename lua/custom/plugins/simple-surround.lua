-- Simple and reliable text wrapping/surrounding
return {
  {
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
        },
      })
      
      -- Defer custom keymaps to ensure nvim-surround is fully loaded
      vim.defer_fn(function()
        -- Add custom keymaps for quick access
        vim.keymap.set("v", "<M-e>", "S", { desc = "Surround selection (press character)" })
        -- vim.keymap.set("n", "<leader>ws", "ysiw", { desc = "Surround word" })
        -- vim.keymap.set("n", "<leader>wl", "yss", { desc = "Surround line" })
        
        -- Quick surround shortcuts
        vim.keymap.set("v", "<leader>w(", function()
          -- Get current selection and apply surround
          local keys = vim.api.nvim_replace_termcodes("S)", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround with ()" })
        
        vim.keymap.set("v", "<leader>w[", function()
          local keys = vim.api.nvim_replace_termcodes("S]", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround with []" })
        
        vim.keymap.set("v", "<leader>w{", function()
          local keys = vim.api.nvim_replace_termcodes("S}", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround with {}" })
        
        vim.keymap.set("v", '<leader>w"', function()
          local keys = vim.api.nvim_replace_termcodes('S"', true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = 'Surround with ""' })
        
        vim.keymap.set("v", "<leader>w'", function()
          local keys = vim.api.nvim_replace_termcodes("S'", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround with ''" })
        
        vim.keymap.set("v", "<leader>w`", function()
          local keys = vim.api.nvim_replace_termcodes("S`", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround with ``" })
        
        -- Add <leader>s* keymaps for surrounding words with special characters
        vim.keymap.set("n", "<leader>s*", function()
          local keys = vim.api.nvim_replace_termcodes("ysiw*", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround word with *" })
        
        vim.keymap.set("n", '<leader>s"', function()
          local keys = vim.api.nvim_replace_termcodes('ysiw"', true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = 'Surround word with ""' })
        
        vim.keymap.set("n", "<leader>s'", function()
          local keys = vim.api.nvim_replace_termcodes("ysiw'", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround word with ''" })
        
        vim.keymap.set("n", "<leader>s`", function()
          local keys = vim.api.nvim_replace_termcodes("ysiw`", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround word with ``" })
        
        vim.keymap.set("n", "<leader>s(", function()
          local keys = vim.api.nvim_replace_termcodes("ysiw)", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround word with ()" })
        
        vim.keymap.set("n", "<leader>s[", function()
          local keys = vim.api.nvim_replace_termcodes("ysiw]", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround word with []" })
        
        vim.keymap.set("n", "<leader>s{", function()
          local keys = vim.api.nvim_replace_termcodes("ysiw}", true, false, true)
          vim.api.nvim_feedkeys(keys, "m", false)
        end, { desc = "Surround word with {}" })
        
        vim.notify("Custom surround shortcuts loaded! Try <leader>s* for word surround", vim.log.levels.INFO)
      end, 100) -- 100ms delay
    end,
  }
}