
require("config.lazy")
require("config.keybindings")
require("custom")

-- Vim opt settings

vim.opt.number = true
vim.cmd.colorscheme("gruvbox")
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3


-- Keybindings
vim.keymap.set('i', '""', '""<++><ESC>4hi', {})
vim.keymap.set('i', "''", "''<++><ESC>4hi", {})
vim.keymap.set('i', '()', '()<++><ESC>4hi', {})
vim.keymap.set('i', '[]', '[]<++><ESC>4hi', {})
vim.keymap.set('i', '{}', '{}<++><ESC>4hi', {})
vim.keymap.set('i', '<>', '<><++><ESC>4hi', {})



vim.keymap.set('n', '<M-j>', ':move +1<CR>', {silent = true})
vim.keymap.set('n', '<M-k>', 'k:move +1<CR>k', {silent = true})



