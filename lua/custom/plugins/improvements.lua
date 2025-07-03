-- Small improvements to add to your Neovim experience
return {
  -- Better notifications
  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 3000,
      render = 'minimal',
    },
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    opts = {
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>' },
    },
  },

  -- Show indent lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = { char = '┊' },
      scope = { enabled = false },
    },
  },

  -- Better quickfix window
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  },

  -- Highlight colors in code
  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
  },
}