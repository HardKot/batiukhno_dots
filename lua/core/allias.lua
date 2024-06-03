local EXPORTS = {}

EXPORTS.nm = function (key, command)
	vim.keymap.set('n', key, command, { noremap = true })
end

EXPORTS.im = function (key, command)
	vim.keymap.set('i', key, command..'<CR>', { noremap = true })
end

EXPORTS.vm = function (key, command)
	vim.keymap.set('v', key, command..'<CR>', { noremap = true })
end

EXPORTS.tm = function (key, command)
	vim.keymap.set('t', key, command..'<CR>', { noremap = true })
end

return EXPORTS

