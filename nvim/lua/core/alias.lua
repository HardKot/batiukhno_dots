local EXPORTS = {}

EXPORTS.nm = function (key, command)
	vim.keymap.set('n', key, command, { noremap = true })
end

EXPORTS.im = function (key, command)
	if not vim.g.vscode then
		vim.keymap.set('i', key, command, { noremap = true })
	end
end

EXPORTS.vm = function (key, command)
	vim.keymap.set('v', key, command, { noremap = true })
end

EXPORTS.tm = function (key, command)
	vim.keymap.set('t', key, command, { noremap = true })
end


local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.default_capabilities()
EXPORTS.lspLoad = function (name, pattern, lsp_list)
  local is_loaded = false

  vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter" }, {
    pattern = pattern,
    callback = function()
      if (is_loaded) then return end

      for _, lsp in pairs(lsp_list) do
        local lsp_name   = lsp
        local lsp_config = { capabilities = capabilities }

        lspconfig[lsp_name].setup(lsp_config)
      end

      is_loaded = true
      print(name.." is success loaded")
    end
  })
end

return EXPORTS

