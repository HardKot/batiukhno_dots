require'mason'.setup {

}

require'mason-lspconfig'.setup {
	ensure_installed = {
		'lua_ls',
		'bashls',
		'tsserver'
	}
}


require'colorizer'.setup {

}

require'trouble'.setup {

}

local capabilities = require'cmp_nvim_lsp'.default_capabilities()

local lspconfig = require'lspconfig'
lspconfig.lua_ls.setup { capabilities = capabilities }
lspconfig.bashls.setup { capabilities = capabilities }
lspconfig.tsserver.setup { capabilities = capabilities }
lspconfig.prismals.setup { capabilities = capabilities }
