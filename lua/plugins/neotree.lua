require'neo-tree'.setup {
	mappings = {
		
	},
	filesystem = {
		use_libuv_file_watcher = true
	}
}

local allias = require'core.allias'

allias.nm('<c-b>', ':Neotree')
