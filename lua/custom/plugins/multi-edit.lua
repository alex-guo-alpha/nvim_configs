return {
  {
    'multi-edit',
    dir = vim.fn.stdpath('config') .. '/lua/custom/multi-edit',
    config = function()
      require('custom.multi-edit').setup()
    end,
  },
}