-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

--- My navigation bindings
-- local keyset = vim.api.nvim_set_keymap
local smap = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = 'Glob: ' .. desc, silent = true })
end

local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = 'Glob: ' .. desc, silent = false })
end

-- Move line up/down
smap('<M-j>', ':m +1<CR>', 'Swap line with the next')
smap('<M-k>', ':m -2<CR>', 'Swap line with the previous')

-- Tabs
map('<M-t>', ':tabnew ', 'Open new tab')

smap('<M-PageUp>', ':tabprevious<CR>', 'Goto previous tab')
smap('<M-h>', ':tabprevious<CR>', 'Goto previous tab')
smap('<M-PageDown>', ':tabnext<CR>', 'Goto next tab')
smap('<M-l>', ':tabnext<CR>', 'Goto next tab')
smap('<M-H>', ':-tabmove<CR>', 'Move tab right')
smap('<M-L>', ':+tabmove<CR>', 'Move tab left')
smap('<C-w>t', ':tab split<CR>', 'Move curent window to new tab')

-- External Tools
smap('<M-a>', ":!align -clmn 1 ''<Left>", 'Align selected lines by identifyer', 'v')
smap('<M-d>', ':lua _G.VimDML("")<CR>', 'Open VimDML')
-- keyset('n', '<M-CR>', ':call VimDML("make")<CR>', opts)
-- keyset('n', '<C-M-CR>', ':set makeprg=', opt_ns) -- This could be better

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Placehoders
vim.keymap.set('n', '<C-n>', function()
  if vim.fn.search('⟪.*⟫', 'c') > 0 then vim.cmd 'normal! vf⟫"_c' end
end)

vim.keymap.set('n', '<C-p>', function()
  if vim.fn.search('⟪.\\{-}⟫', 'cb') > 0 then vim.cmd 'normal! vf⟫"_c' end
end)

map('<leader>n', '<C-n>', '')

map('{}', '{}⟪⟫<ESC>2hi', '', 'i')
map('()', '()⟪⟫<ESC>2hi', '', 'i')
map('[]', '[]⟪⟫<ESC>2hi', '', 'i')
map('<>', '<>⟪⟫<ESC>2hi', '', 'i')
map('""', '""⟪⟫<ESC>2hi', '', 'i')
map("''", "''⟪⟫<ESC>2hi", '', 'i')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
