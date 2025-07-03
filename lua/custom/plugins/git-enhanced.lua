return {
  {
    'git-enhanced',
    dir = vim.fn.stdpath('config') .. '/lua/custom/git-enhanced',
    config = function()
      require('custom.git-enhanced').setup()
    end,
  },
}