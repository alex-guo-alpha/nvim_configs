return {
  {
    'sessions',
    dir = vim.fn.stdpath('config') .. '/lua/custom/sessions',
    config = function()
      require('custom.sessions').setup()
    end,
  },
}