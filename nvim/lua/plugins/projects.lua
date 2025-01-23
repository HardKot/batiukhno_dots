require('telescope').load_extension('projections')

require'projections'.setup {
	workspaces = {
		"~/Projects"
	},
	store_hooks = {
		pre = function()
			if pcall(require, "neo-tree") then 
				vim.cmd('Neotree action=close') 
			end
		end
	}
}


