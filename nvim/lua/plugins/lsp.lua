require'mason'.setup {

}

require'mason-lspconfig'.setup {
	ensure_installed = {
		'lua_ls',
		'bashls',

    'ast_grep',
		'ts_ls',
    'html',
    'tailwindcss',
    'cssls',

    'jdtls',
    'gradle_ls',

    'dockerls',
    'jsonls',
    'ltex'
	}
}

require'colorizer'.setup {

}

require'trouble'.setup {

}

local alias = require'core.alias'
local lspconfig = require'lspconfig'

lspconfig.dockerls.setup { capabilities = capabilities }
lspconfig.jsonls.setup { capabilities = capabilities }
lspconfig.ltex.setup { capabilities = capabilities }
lspconfig.ast_grep.setup { capabilities = capabilities }

alias.lspLoad("Bash", { "*.sh" }, { "bashls" })
alias.lspLoad("Lua", { "*.lua" }, { "lua_ls" })
alias.lspLoad("Java", { "*.java" }, { "jdtls" })
alias.lspLoad("Gradle", { "*.gradle" }, { "gradle_ls" })
alias.lspLoad("CSS", { "*.css" }, { "cssls" })
alias.lspLoad("HTML", { "*.html" }, { "tailwindcss", "html" })
alias.lspLoad("JavaScript", { "*.js", "*.mjs", "*.jsx", "*.ts", "*.tsx" }, { "tsserver" })

