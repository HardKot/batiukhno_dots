require'neo-tree'.setup {
	close_if_last_window = true,
	mappings = {
		
	},
	filesystem = {
		use_libuv_file_watcher = true,
		filtered_items = {
			hide_gitignored = false,
			hide_hidden = false,
			hide_dotfiles = false,
			hide_by_name = {
				'.git',
				'node_modules',
			},
		},
	},
	source_selector = {
		winbar = true,
		statusline = false,
	}
}

local alias = require'core.alias'
alias.nm('<c-b>', ':Neotree<CR>')

vim.cmd(':Neotree')
