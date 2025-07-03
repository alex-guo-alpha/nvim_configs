return {
  {
    'refactoring',
    dir = vim.fn.stdpath('config') .. '/lua/custom/refactoring',
    config = function()
      require('custom.refactoring').setup()
    end,
  },
}