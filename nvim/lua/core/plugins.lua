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


	

local plugins = {}

	table.insert(plugins, {
		"nvim-treesitter/nvim-treesitter",
		build = function () 
			vim.cmd("TSUpdate")			
		end
	})
	table.insert(plugins, {
		"williamboman/mason.nvim",
			dependencies = {
			"williamboman/mason-lspconfig.nvim",
			},
	})
	table.insert(plugins, { "neovim/nvim-lspconfig" })
	table.insert(plugins, {
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"3rd/image.nvim",
				"MunifTanjim/nui.nvim",
			}
		})
	table.insert(plugins, { "gnikdroy/projections.nvim" })
	table.insert(plugins, { "NvChad/nvim-colorizer.lua" })
	table.insert(plugins, { "onsails/lspkind.nvim" })
	table.insert(plugins, {
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})
	table.insert(plugins, {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
		module = false
	})
	table.insert(plugins, { 'shaunsingh/nord.nvim' })
	table.insert(plugins, { 'hrsh7th/cmp-nvim-lsp' })
	table.insert(plugins, { 'hrsh7th/cmp-buffer' })
	table.insert(plugins, { 'hrsh7th/cmp-path' })
	table.insert(plugins, { 'hrsh7th/cmp-cmdline' })
	table.insert(plugins, { 'hrsh7th/nvim-cmp' })
	table.insert(plugins, { 'hrsh7th/vim-vsnip' })
	table.insert(plugins, { 'hrsh7th/vim-vsnip-integ' })

	table.insert(plugins, { 'lewis6991/gitsigns.nvim' })
	table.insert(plugins, {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	})
	table.insert(plugins, { 'simrat39/symbols-outline.nvim' })
	table.insert(plugins, { 'b3nj5m1n/kommentary' })
	table.insert(plugins, { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' })
	table.insert(plugins, { 'jose-elias-alvarez/null-ls.nvim' })
	table.insert(plugins, {
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		dependencies = { {'nvim-tree/nvim-web-devicons' } },
	})
	table.insert(plugins, { 'akinsho/toggleterm.nvim', version = "*", config = true })
	table.insert(plugins, { 'HiPhish/rainbow-delimiters.nvim' })

  table.insert(plugins, 'mfussenegger/nvim-dap')
  table.insert(plugins, 'mfussenegger/nvim-jdtls')
require("lazy").setup(plugins)
