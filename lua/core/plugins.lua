local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = function () 
			vim.cmd("TSUpdate")
		end
	},
	{
		"williamboman/mason.nvim",
    		dependencies = {
			"williamboman/mason-lspconfig.nvim",
    		},
	},
	{ "neovim/nvim-lspconfig" },
	{
		"nvim-neo-tree/neo-tree.nvim",
		 dependencies = {
      			"nvim-lua/plenary.nvim",
      			"nvim-tree/nvim-web-devicons",
			"3rd/image.nvim",
			"MunifTanjim/nui.nvim",
   		}
	},
	{ "gnikdroy/projections.nvim" },
	{ "NvChad/nvim-colorizer.lua" },
	{ "onsails/lspkind.nvim" },
	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	},
	{
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
		module = false
	},
	{ 'shaunsingh/nord.nvim' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/cmp-cmdline' },
	{ 'hrsh7th/nvim-cmp' },
	{
		'nvim-telescope/telescope.nvim', 
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	}
})
