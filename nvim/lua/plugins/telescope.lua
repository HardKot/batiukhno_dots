local builtin = require'telescope.builtin'

local alias = require'core.alias'
alias.nm('<leader>ff', builtin.find_files)
alias.nm('<leader>fg', builtin.live_grep)
alias.nm('<leader>fb', builtin.buffers)
alias.nm('<leader>fh', builtin.help_tags)
