local alias = require'core.alias'


local function escape(str)
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end
  
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]

vim.opt.langmap = vim.fn.join({
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')

vim.g.mapleader = " " 

alias.im('jj', '<Esc>')
alias.nm('<Tab>', ':BufferLineCycleNext<CR>')
alias.nm('<S-Tab>', ':BufferLineCyclePrev<CR>')

