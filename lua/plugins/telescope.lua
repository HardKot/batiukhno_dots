local builtin = require'telescope.builtin'

local allias = require'core.allias'
allias.nm('<leader>ff', builtin.find_files)
allias.nm('<leader>fg', builtin.live_grep)
allias.nm('<leader>fb', builtin.buffers)
allias.nm('<leader>fh', builtin.help_tags)
