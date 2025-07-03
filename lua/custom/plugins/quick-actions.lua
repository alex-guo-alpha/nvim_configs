return {
  {
    'quick-actions',
    dir = vim.fn.stdpath('config') .. '/lua/custom/quick-actions',
    config = function()
      require('custom.quick-actions').setup()
    end,
  },
}