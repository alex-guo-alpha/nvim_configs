return {
  "epwalsh/obsidian.nvim",
  version = "*", -- Use latest release
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- For autocompletion
    "nvim-telescope/telescope.nvim", -- For searching
    "nvim-treesitter/nvim-treesitter", -- For syntax highlighting
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "~/notes", -- Default notes directory (accessible)
      },
      {
        name = "work",
        path = "~/work-notes", -- Work notes directory (accessible)
      },
    },
    
    -- Logging level
    log_level = vim.log.levels.INFO,
    
    -- Disable daily notes for atomic note-taking
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      template = nil,
    },
    
    -- Completion configuration
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    
    -- Mappings
    mappings = {
      -- "Obsidian follow"
      ["<leader>of"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true, desc = "[O]bsidian [F]ollow link" },
      },
      -- "Obsidian back"
      ["<leader>ob"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true, desc = "[O]bsidian [B]ack/Smart action" },
      },
      -- Toggle checkbox
      ["<leader>oc"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true, desc = "[O]bsidian Toggle [C]heckbox" },
      },
    },
    
    -- Disable conceallevel override to prevent conflicts
    callbacks = {
      post_set_vault = function(client, vault)
        -- Preserve user's conceallevel settings
      end,
      -- Prevent Obsidian from changing buffer settings that might conflict
      enter_note = function(client, note)
        vim.schedule(function()
          -- Ensure render-markdown.nvim settings are preserved
          vim.opt_local.conceallevel = 2
        end)
      end,
    },
    
    -- New note configuration
    new_notes_location = "notes_subdir",
    note_id_func = function(title)
      -- Create note IDs from title if provided, otherwise use timestamp
      local suffix = ""
      if title ~= nil then
        -- Transform title to valid filename
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- Use timestamp if no title
        suffix = tostring(os.time())
      end
      return suffix
    end,
    
    -- Note path configuration
    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md")
    end,
    
    -- Wiki links configuration
    wiki_link_func = function(opts)
      if opts.id == nil then
        return string.format("[[%s]]", opts.label)
      elseif opts.label ~= opts.id then
        return string.format("[[%s|%s]]", opts.id, opts.label)
      else
        return string.format("[[%s]]", opts.id)
      end
    end,
    
    -- Markdown link configuration
    markdown_link_func = function(opts)
      return string.format("[%s](%s)", opts.label, opts.path)
    end,
    
    -- Image paste configuration
    image_name_func = function()
      return string.format("%s-", os.date("%Y%m%d%H%M%S"))
    end,
    
    -- Disable frontmatter by default
    disable_frontmatter = false,
    
    -- Note frontmatter configuration
    note_frontmatter_func = function(note)
      if note.title then
        note:add_alias(note.title)
      end
      
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      
      -- Add creation date
      if note.metadata ~= nil and note.metadata.created ~= nil then
        out.created = note.metadata.created
      else
        out.created = os.date("%Y-%m-%d %H:%M:%S")
      end
      
      -- Add modification date
      out.modified = os.date("%Y-%m-%d %H:%M:%S")
      
      return out
    end,
    
    -- Templates configuration
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {},
    },
    
    -- Picker configuration for telescope
    picker = {
      name = "telescope.nvim",
      mappings = {
        new = "<C-x>",
        insert_link = "<C-l>",
      },
    },
    
    -- Sort by modification time in telescope
    sort_by = "modified",
    sort_reversed = true,
    
    -- Search configuration
    search_max_lines = 1000,
    
    -- Open in new split by default
    open_notes_in = "current",
    
    -- UI configuration
    ui = {
      enable = true,
      update_debounce = 200,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      },
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
    
    -- Attachments configuration
    attachments = {
      img_folder = "assets/imgs",
      confirm_img_paste = true,
    },
  },
  
  config = function(_, opts)
    require("obsidian").setup(opts)
    
    -- Additional keymaps
    vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "[O]bsidian [N]ew note" })
    vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "[O]bsidian [O]pen in app" })
    vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "[O]bsidian [S]earch" })
    vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "[O]bsidian [T]oday's note" })
    vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "[O]bsidian [Y]esterday's note" })
    vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianTomorrow<cr>", { desc = "[O]bsidian [T]omorrow's note" })
    vim.keymap.set("n", "<leader>od", "<cmd>ObsidianDailies<cr>", { desc = "[O]bsidian [D]ailies" })
    vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", { desc = "[O]bsidian [Q]uick switch" })
    vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<cr>", { desc = "[O]bsidian [L]inks" })
    vim.keymap.set("n", "<leader>oL", "<cmd>ObsidianLinkNew<cr>", { desc = "[O]bsidian [L]ink new" })
    vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<cr>", { desc = "[O]bsidian [W]orkspace" })
    vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", { desc = "[O]bsidian [P]aste image" })
    vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>", { desc = "[O]bsidian [R]ename note" })
    vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLinkNew<cr>", { desc = "[O]bsidian [L]ink new from selection" })
    vim.keymap.set("v", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", { desc = "[O]bsidian [E]xtract note" })
    
    -- Template keymaps
    vim.keymap.set("n", "<leader>otp", "<cmd>ObsidianTemplate<cr>", { desc = "[O]bsidian [T]emplate [P]aste" })
    
    -- Tag management
    vim.keymap.set("n", "<leader>otg", "<cmd>ObsidianTags<cr>", { desc = "[O]bsidian [T]a[G]s" })
    
    -- Backlinks
    vim.keymap.set("n", "<leader>obl", "<cmd>ObsidianBacklinks<cr>", { desc = "[O]bsidian [B]ack[L]inks" })
    
    -- Auto-completion setup for Obsidian
    local cmp = require("cmp")
    cmp.setup.filetype("markdown", {
      sources = cmp.config.sources({
        { name = "obsidian" },
        { name = "obsidian_new" },
        { name = "obsidian_tags" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })
    
    -- Create directories if they don't exist
    local function ensure_dir(path)
      if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
      end
    end
    
    -- Ensure workspace directories exist
    ensure_dir(vim.fn.expand("~/notes"))
    ensure_dir(vim.fn.expand("~/work-notes"))
    ensure_dir(vim.fn.expand("~/notes/assets/imgs"))
    
    -- Fix for display glitches in markdown files
    vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI", "BufEnter", "BufWinEnter"}, {
      pattern = "*.md",
      callback = function()
        vim.defer_fn(function()
          vim.cmd("redraw!")
        end, 50)
      end,
      desc = "Fix markdown display glitches"
    })
    
    vim.notify("Obsidian.nvim configured! Use <leader>o* for commands", vim.log.levels.INFO)
  end,
}