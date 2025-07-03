-- Additional plugins that enhance the Obsidian-Neovim experience
return {
  -- 1. Headlines.nvim - Better markdown heading visualization
  -- DISABLED: Conflicts with render-markdown.nvim
  -- {
  --   "lukas-reineke/headlines.nvim",
  --   dependencies = "nvim-treesitter/nvim-treesitter",
  --   ft = { "markdown", "norg", "rmd", "org" },
  --   config = function()
  --     require("headlines").setup({
  --       markdown = {
  --         headline_highlights = {
  --           "Headline1",
  --           "Headline2",
  --           "Headline3",
  --           "Headline4",
  --           "Headline5",
  --           "Headline6",
  --         },
  --         codeblock_highlight = "CodeBlock",
  --         dash_highlight = "Dash",
  --         quote_highlight = "Quote",
  --       },
  --     })
  --     
  --     -- Define custom highlight groups
  --     vim.cmd [[
  --       highlight Headline1 guibg=#1e2718
  --       highlight Headline2 guibg=#21262d
  --       highlight Headline3 guibg=#30323e
  --       highlight Headline4 guibg=#3b3d4f
  --       highlight Headline5 guibg=#484a5f
  --       highlight Headline6 guibg=#54566f
  --       highlight CodeBlock guibg=#1c1c1c
  --       highlight Dash guibg=#D19A66 gui=bold
  --       highlight Quote guifg=#9ca0b0 gui=italic
  --     ]]
  --   end,
  -- },

  -- 2. Markdown-specific text objects
  {
    "preservim/vim-textobj-sentence",
    dependencies = "kana/vim-textobj-user",
    ft = { "markdown", "text" },
    config = function()
      vim.g.textobj_sentence_no_default_key_mappings = true
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text" },
        callback = function()
          vim.keymap.set({ "x", "o" }, "as", "<Plug>(textobj-sentence-a)", { buffer = true })
          vim.keymap.set({ "x", "o" }, "is", "<Plug>(textobj-sentence-i)", { buffer = true })
        end,
      })
    end,
  },

  -- 3. Better link concealing and following
  {
    "jghauser/follow-md-links.nvim",
    ft = "markdown",
  },

  -- 4. Calendar integration for daily notes
  {
    "mattn/calendar-vim",
    cmd = "Calendar",
    init = function()
      vim.g.calendar_no_mappings = 1
      vim.keymap.set("n", "<leader>ocal", ":Calendar<CR>", { desc = "[O]bsidian [Cal]endar" })
    end,
  },

  -- 5. Better markdown link completion (disabled due to conflicts)
  -- {
  --   "SidOfc/mkdx",
  --   ft = "markdown",
  --   config = function()
  --     vim.g.mkdx_settings = {
  --       highlight = { enable = 1 },
  --       enter = { shift = 1 },
  --       links = { external = { enable = 1 } },
  --       toc = { text = "Table of Contents", update_on_write = 1 },
  --       fold = { enable = 0 },
  --       checkbox = { toggles = { " ", "x", "-", "~" } },
  --       tokens = { strike = "~~", bold = "**", italic = "*", code = "`" },
  --     }
  --   end,
  -- },

  -- 6. Better folds for markdown
  -- DISABLED: Conflicts with preservim/vim-markdown folding
  -- {
  --   "masukomi/vim-markdown-folding",
  --   ft = "markdown",
  --   config = function()
  --     vim.g.markdown_fold_style = "nested"
  --     vim.g.markdown_fold_override_foldtext = 0
  --   end,
  -- },

  -- 7. Render markdown in Neovim (similar to Obsidian's preview)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "Avante" },
    opts = {
      heading = {
        enabled = true,
        sign = false,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },
      code = {
        enabled = true,
        sign = false,
        style = "normal",
        position = "left",
        language_pad = 0,
        min_width = 0,
        border = "thin",
        above = "▄",
        below = "▀",
        left = "│",
        right = "│",
        language = {
          enabled = true,
          sign = true,
        },
      },
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
        },
        checked = {
          icon = "󰱒 ",
        },
      },
      quote = {
        enabled = true,
        icon = "▍",
      },
      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰇮 ",
        hyperlink = "󰌹 ",
        custom = {
          web = { pattern = "^http[s]?://", icon = "󰖟 " },
        },
      },
      sign = {
        enabled = false,
      },
      latex = {
        enabled = false,
      },
    },
  },
}