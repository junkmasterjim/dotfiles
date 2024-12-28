local opt = vim.opt
local keymap = vim.keymap.set

-- Basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Options
opt.shortmess = "I"
opt.number = true
opt.relativenumber = false
opt.mouse = 'a'
opt.textwidth = 80
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = {tab = '··', trail = '·', lead = '.' }
opt.inccommand = 'split'
opt.cursorline = true
opt.scrolloff = 10
opt.hlsearch = true

opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.autoindent = true

-- Keymaps

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

-- Use h,j,k,l to navigate
keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Window navigation
keymap('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

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

  {'catppuccin/nvim'},

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
