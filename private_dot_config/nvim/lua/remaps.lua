local keymap = vim.keymap.set

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Neo-tree keymap
keymap('n', '\\', ':Neotree reveal<cr>', { noremap = true, silent = true })

-- Stop the search highlight
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

