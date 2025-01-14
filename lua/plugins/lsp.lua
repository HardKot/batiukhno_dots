require'mason'.setup {

}

require'mason-lspconfig'.setup {
	ensure_installed = {
		'lua_ls',
		'bashls',

    'ast_grep',
		'tsserver',
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

local capabilities = require'cmp_nvim_lsp'.default_capabilities()

local lspconfig = require'lspconfig'

lspconfig.bashls.setup { capabilities = capabilities }
lspconfig.dockerls.setup { capabilities = capabilities }
lspconfig.jsonls.setup { capabilities = capabilities }
lspconfig.ltex.setup { capabilities = capabilities }


lspconfig.ast_grep.setup { filetypes = { "typescript" } }


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter" }, {
  pattern = { "*.lua" },
  callback = function() 
    print("Load Lua LSP")
    lspconfig.lua_ls.setup { capabilities = capabilities }
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter" }, {
  pattern = { "*.java" },
  callback = function() 
    print("Load Java LSP")
    lspconfig.jdtls.setup { capabilities = capabilities }
    lspconfig.gradle_ls.setup { capabilities = capabilities }
  end
})


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter" }, {
  pattern = { "*.html", "*.css" },
  callback = function() 
    print("Load CSS LSP")
    lspconfig.cssls.setup { capabilities = capabilities }
    lspconfig.tailwindcss.setup { capabilities = capabilities }
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter" }, {
  pattern = { "*.html" },
  callback = function() 
    print("Load CSS LSP")
    lspconfig.html.setup { capabilities = capabilities }
  end
})


vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter" }, {
  pattern = { "*.js", "*.mjs", "*.jsx", "*.ts", "*.tsx" },
  callback = function() 
    print("Load JS LSP")
    lspconfig.tsserver.setup { capabilities = capabilities }
  end
})
