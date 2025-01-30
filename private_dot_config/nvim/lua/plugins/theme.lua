  return {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd [[colorscheme tokyonight-night]]
      vim.cmd.hi 'Comment gui=none'
    end
  }
