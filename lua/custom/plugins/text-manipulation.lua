return {
  {
    'text-manipulation',
    dir = vim.fn.stdpath('config') .. '/lua/custom/text-manipulation',
    config = function()
      require('custom.text-manipulation').setup()
    end,
  },
}