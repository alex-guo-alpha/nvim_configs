-- Advanced workflow enhancements based on your current setup
return {
  -- Enhanced fuzzy finding with more sources
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
  
  -- File browser integration
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').load_extension('file_browser')
      vim.keymap.set('n', '<leader>fb', ':Telescope file_browser<CR>', { desc = '[F]ile [B]rowser' })
      vim.keymap.set('n', '<leader>fB', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = '[F]ile [B]rowser (current dir)' })
    end,
  },
  
  -- Enhanced text objects with treesitter
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner", 
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer", 
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>xa"] = "@parameter.inner",  -- Changed from Sa to xa to avoid conflicts
              ["<leader>xf"] = "@function.outer",   -- Changed from Sf to xf to avoid conflicts
            },
            swap_previous = {
              ["<leader>xA"] = "@parameter.inner",  -- Changed from SA to xA
              ["<leader>xF"] = "@function.outer",   -- Changed from SF to xF
            },
          },
        },
      })
    end,
  },
  
  -- Auto pairs with smart integration
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      local npairs = require('nvim-autopairs')
      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = {'string'},
          javascript = {'template_string'},
          typescript = {'template_string'},
        },
        fast_wrap = {
          map = '<C-e>', -- Changed from <M-e> to avoid conflicts with surround
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=], -- Fixed pattern
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment'
        },
      })
    end,
  },
  
  -- Better folding with treesitter
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (' 󰁂 %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, {chunkText, hlGroup})
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, {suffix, 'MoreMsg'})
          return newVirtText
        end
      })
      
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open folds except kinds' })
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'Close folds with' })
      
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },
  
  -- Project management with session integration
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        detection_methods = { 'lsp', 'pattern' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'Cargo.toml', 'go.mod' },
        show_hidden = false,
        silent_chdir = false, -- Disable automatic directory changing
        scope_chdir = 'tab',  -- Limit scope to tab instead of global
        respect_buf_cwd = true, -- Don't override manual directory changes
      })
      require('telescope').load_extension('projects')
      vim.keymap.set('n', '<leader>fp', ':Telescope projects<CR>', { desc = '[F]ind [P]rojects' })
    end,
  },
  
  -- Better diagnostics UI
  {  
    'folke/trouble.nvim',
    opts = {
      focus = true,
      warn_no_results = false,
      open_no_results = true,
    },
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },
  
  -- Enhanced word motions
  {
    'chaoren/vim-wordmotion',
    config = function()
      vim.g.wordmotion_prefix = '<Leader>'
      vim.g.wordmotion_mappings = {
        w = '<Leader>w',
        b = '<Leader>b',
        e = '<Leader>e',
        ge = 'g<Leader>e',
        aw = 'a<Leader>w',
        iw = 'i<Leader>w',
      }
    end,
  },
  
  -- Better search and replace
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup()
      vim.keymap.set('n', '<leader>Sr', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle [S]pectre [r]eplace' })
      vim.keymap.set('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = '[S]pectre search current [w]ord' })
      vim.keymap.set('v', '<leader>Sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = '[S]pectre search current [w]ord' })
      vim.keymap.set('n', '<leader>Sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = '[S]pectre search on current file' })
    end,
  },
  
  -- Enhanced marks with descriptions  
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 250,
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        excluded_filetypes = {},
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world",
          annotate = false,
        },
        mappings = {}
      })
    end,
  },
  
  -- Git integration enhancements
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('diffview').setup()
      vim.keymap.set('n', '<leader>gd', ':DiffviewOpen<CR>', { desc = '[G]it [D]iffview' })
      vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory<CR>', { desc = '[G]it [H]istory' })
      vim.keymap.set('n', '<leader>gH', ':DiffviewFileHistory %<CR>', { desc = '[G]it [H]istory (current file)' })
    end,
  },
  
  -- Better terminal integration  
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
        },
      })
      
      -- LazyGit integration (optional - requires lazygit installation)
      vim.keymap.set('n', '<leader>lg', function()
        if vim.fn.executable('lazygit') == 1 then
          local Terminal = require('toggleterm.terminal').Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
              border = "double",
            },
            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
            end,
          })
          lazygit:toggle()
        else
          vim.notify('LazyGit not installed. Install with: brew install lazygit', vim.log.levels.WARN)
          vim.notify('Using Neogit instead...', vim.log.levels.INFO)
          require('neogit').open()
        end
      end, { desc = '[L]azy[g]it (or Neogit fallback)' })
    end,
  },
}