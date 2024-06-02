vim.wo.number = true

vim.api.nvim_create_autocmd('ModeChanged', {
	callback = function ()
		local new_mode = vim.v.event.new_mode
		vim.wo.relativenumber = new_mode == 'i'
	end
})


