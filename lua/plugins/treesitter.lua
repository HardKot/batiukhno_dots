require'nvim-treesitter.configs'.setup {
	ensure_installed = { 
		"typescript",
		"lua",
		"javascript",
		"java",
		"python",
		"tsx",
		"sql",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true
	},
}
