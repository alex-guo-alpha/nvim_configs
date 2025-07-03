return {
  {
    'smart-splits',
    dir = vim.fn.stdpath('config') .. '/lua/custom/smart-splits',
    config = function()
      require('custom.smart-splits').setup()
    end,
  },
}