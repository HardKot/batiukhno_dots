vim.wo.number = true

vim.api.nvim_create_autocmd('ModeChanged', {
	callback = function ()
		local new_mode = vim.v.event.new_mode
		vim.wo.relativenumber = new_mode == 'i'
	end
})

local function escape(str)
  -- Эти символы должны быть экранированы, если встречаются в langmap
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end


local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]

vim.opt.langmap = vim.fn.join({
	escape(ru_shift) .. ';' .. escape(en_shift),
	escape(ru) .. ';' .. escape(en),
}, ',')
