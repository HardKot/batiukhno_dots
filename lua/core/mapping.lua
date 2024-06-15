local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

map('n', '<Tab>', ':BufferLineCycleNext<CR>', default_opts)
map('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', default_opts)
