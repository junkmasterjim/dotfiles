-- Basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Options
vim.opt.shortmess = "I"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = 'a'
vim.opt.textwidth = 80
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = {tab = '··', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true

vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

-- Keymaps
local keymap = vim.keymap.set

keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- Toggle transparency
keymap('n', '<leader>tt', ':TransparentToggle<CR>', { noremap = true, silent = true })

-- Toggle HTML Live Server
keymap('n', '<leader>ll', ':LiveServerStart<CR>', { desc = '[L]iveServer start', noremap = true, silent = true })
keymap('n', '<leader>ls', ':LiveServerStop<CR>', { desc = '[L]iveServer [s]top', noremap = true, silent = true })

-- Diagnostic keymaps
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Window navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require('lazy').setup({
  -- Quality of life plugins
  'tpope/vim-sleuth',
  'neoclide/coc.nvim',
  'numToStr/Comment.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'windwp/nvim-autopairs',
      'hrsh7th/cmp-nvim-lsp',


  -- Git symbols
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Todo Comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Theme
  {
   "xiyaowong/transparent.nvim",

    opts = {
      exclude_groups = {'StatusLine', 'StatusLineNC',}
    },
  },

  {
    'slugbyte/lackluster.nvim',
    name = "lackluster",
    priority = 1000,
    config = function()
      vim.o.background = 'dark'

      vim.cmd [[colorscheme lackluster-night]]
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Mini.nvim 
  {
      'echasnovski/mini.nvim',
      config = function()
        -- Better Around/Inside textobjects
        require('mini.ai').setup { n_lines = 500 }

        -- Simple and easy statusline.
        local statusline = require 'mini.statusline'
        statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end
      end,
    },

  -- Modular configuration
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠 ',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝 ',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
