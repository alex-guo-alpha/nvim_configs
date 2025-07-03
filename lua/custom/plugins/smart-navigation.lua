return {
  {
    'smart-navigation',
    dir = vim.fn.stdpath('config') .. '/lua/custom/smart-navigation',
    config = function()
      require('custom.smart-navigation').setup()
    end,
  },
}