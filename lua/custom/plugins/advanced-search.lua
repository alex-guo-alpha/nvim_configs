return {
  {
    'advanced-search',
    dir = vim.fn.stdpath('config') .. '/lua/custom/advanced-search',
    config = function()
      require('custom.advanced-search').setup()
    end,
  },
}