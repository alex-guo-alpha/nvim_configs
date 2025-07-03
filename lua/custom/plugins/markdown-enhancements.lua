return {
  -- Markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
      -- Configuration
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
      vim.g.mkdp_theme = 'dark'
      
      -- Key mappings
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { desc = '[M]arkdown [P]review' })
      vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = '[M]arkdown preview [S]top' })
      vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<cr>', { desc = '[M]arkdown preview [T]oggle' })
    end,
  },

  -- Table mode for easy table editing
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "org" },
    config = function()
      -- Configuration
      vim.g.table_mode_corner = '|'
      vim.g.table_mode_corner_corner = '+'
      vim.g.table_mode_header_fillchar = '='
      
      -- Key mappings
      vim.keymap.set('n', '<leader>tm', '<cmd>TableModeToggle<cr>', { desc = '[T]able [M]ode toggle' })
      vim.keymap.set('n', '<leader>tt', '<cmd>Tableize<cr>', { desc = '[T]ableize [T]ext' })
      vim.keymap.set('v', '<leader>tt', ':Tableize<cr>', { desc = '[T]ableize [T]ext' })
      
      -- Quick table insertion
      vim.keymap.set('n', '<leader>ti', function()
        local cols = vim.fn.input("Number of columns: ")
        local rows = vim.fn.input("Number of rows: ")
        
        if cols == "" then cols = "3" end
        if rows == "" then rows = "2" end
        
        cols = tonumber(cols) or 3
        rows = tonumber(rows) or 2
        
        local lines = {}
        
        -- Header row
        local header = "|"
        for i = 1, cols do
          header = header .. " Header " .. i .. " |"
        end
        table.insert(lines, header)
        
        -- Separator row
        local separator = "|"
        for i = 1, cols do
          separator = separator .. " --- |"
        end
        table.insert(lines, separator)
        
        -- Data rows
        for r = 1, rows do
          local row = "|"
          for c = 1, cols do
            row = row .. " Cell " .. r .. "," .. c .. " |"
          end
          table.insert(lines, row)
        end
        
        -- Insert at cursor
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        
        -- Position cursor at first header cell
        vim.api.nvim_win_set_cursor(0, {row + 1, 2})
        vim.cmd("startinsert")
      end, { desc = '[T]able [I]nsert' })
      
      -- Auto-enable for markdown files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("TableModeEnable")
        end,
      })
    end,
  },

  -- Zen mode for distraction-free writing
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
          enabled = false,
          font = "+4",
        },
      },
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)
      vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { desc = '[Z]en mode toggle' })
    end,
  },

  -- Twilight for additional focus
  {
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        term_bg = "#000000",
        inactive = false,
      },
      context = 10,
      treesitter = true,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {},
    },
    config = function(_, opts)
      require("twilight").setup(opts)
      vim.keymap.set('n', '<leader>tw', '<cmd>Twilight<cr>', { desc = '[T]wilight toggle' })
    end,
  },

  -- Better markdown syntax highlighting
  -- DISABLED: Conflicts with render-markdown.nvim conceal settings
  -- {
  --   "preservim/vim-markdown",
  --   ft = "markdown",
  --   config = function()
  --     -- Configuration
  --     vim.g.vim_markdown_folding_disabled = 1
  --     vim.g.vim_markdown_conceal = 2
  --     vim.g.vim_markdown_conceal_code_blocks = 0
  --     vim.g.vim_markdown_math = 1
  --     vim.g.vim_markdown_toml_frontmatter = 1
  --     vim.g.vim_markdown_frontmatter = 1
  --     vim.g.vim_markdown_strikethrough = 1
  --     vim.g.vim_markdown_autowrite = 1
  --     vim.g.vim_markdown_edit_url_in = 'tab'
  --     vim.g.vim_markdown_follow_anchor = 1
  --   end,
  -- },

  -- Markdown TOC generation
  {
    "mzlogin/vim-markdown-toc",
    ft = "markdown",
    config = function()
      -- Configuration
      vim.g.vmt_auto_update_on_save = 1
      vim.g.vmt_dont_insert_fence = 1
      
      -- Key mappings
      vim.keymap.set('n', '<leader>mtc', '<cmd>GenTocGFM<cr>', { desc = '[M]arkdown [T]OC [C]reate' })
      vim.keymap.set('n', '<leader>mtu', '<cmd>UpdateToc<cr>', { desc = '[M]arkdown [T]OC [U]pdate' })
      vim.keymap.set('n', '<leader>mtr', '<cmd>RemoveToc<cr>', { desc = '[M]arkdown [T]OC [R]emove' })
    end,
  },

  -- Paste images into markdown
  {
    "img-paste-devs/img-paste.vim",
    ft = "markdown",
    config = function()
      -- Configuration
      vim.g.mdip_imgdir = 'assets/imgs'
      vim.g.mdip_imgname = 'image'
      
      -- Key mapping
      vim.keymap.set('n', '<leader>mi', '<cmd>call mdip#MarkdownClipboardImage()<cr>', { desc = '[M]arkdown paste [I]mage' })
    end,
  },

  -- Better list handling
  {
    "dkarter/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    config = function()
      -- Configuration
      vim.g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
        'scratch'
      }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_mapping_leader = '<SPACE>'
      vim.g.bullets_delete_last_bullet_if_empty = 1
      vim.g.bullets_line_spacing = 1
      vim.g.bullets_pad_right = 1
      vim.g.bullets_max_alpha_characters = 2
      vim.g.bullets_renumber_on_change = 1
      vim.g.bullets_nested_checkboxes = 1
      vim.g.bullets_checkbox_markers = ' .oOX'
      vim.g.bullets_outline_levels = {'ROM', 'ABC', 'num', 'abc', 'rom', 'i)', 'a)', '1)', 'I)', 'A)'}
    end,
  },
}