
local opts = { noremap=true, silent=true }
local opts_ns = { noremap=true, silent=false }
local keyset = vim.api.nvim_set_keymap


-- Navigation
keyset('n', '<M-t>', ':tabnew ', opts_ns)

keyset('n', '<C-j>', ':call search("<+.*+>", "c")<CR>vf>"_c', opts)
keyset('n', '<C-k>', ':call search("<+.*+>", "cb")<CR>vf>"_c', opts)


keyset('n', '<C-w>t', ':tab split<CR>', opts)

-- Telescope

keyset('n', '\\ff', '<cmd>Telescope find_files<CR>', opts)
keyset('n', '\\fg', '<cmd>Telescope live_grep<CR>', opts)
keyset('n', '\\fb', '<cmd>Telescope buffers<CR>', opts)
keyset('n', '\\ft', '<cmd>Telescope tags<CR>', opts)


keyset('n', '<M-d>', ':lua VimDML()<CR>', opts_ns)
