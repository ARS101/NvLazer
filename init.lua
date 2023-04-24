-- Setting lazy package installation path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Checking if lazy is installed in lazypath
if not vim.loop.fs_stat(lazypath) then
	print("Installing lazy for the first time.")
	vim.fn.system({"git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable",
	lazypath,})
	print("Installation complete.")
end

-- Adding lazypath to runtimepath (rtp)
vim.opt.rtp:prepend(lazypath)

-- Setting leader key
vim.g.mapleader = " "

-- List of plugins to be installed
local plugins = {

	-- Treesitter provides basic functionalities such as highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},

	-- Telescope is a powerful fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	-- Onedark theme
	{"navarasu/onedark.nvim"},

	{
		-- Bridges mason.nvim with the lspconfig plugins
		-- making it easier to use both plugins together. 
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			-- Configurations for the Nvim LSP client
			-- Used to pass configuration to lsp servers
			"neovim/nvim-lspconfig",

			-- Package manager used to install
			-- LSP servers, DAP servers, linters, and formatters. 
			"williamboman/mason.nvim",
		}
	},

	{
		-- Nvim completion engine
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Critical for nvim completion functionalities
			"hrsh7th/cmp-nvim-lsp",
		}
	},

	{ "folke/neodev.nvim" },

	{
		"nvim-lualine/lualine.nvim",
		opts = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		opts = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup {}
		end,
	},

	{
		's1n7ax/nvim-terminal',
		config = function()
        		vim.o.hidden = true
			require('nvim-terminal').setup()
		end,
	},
}


require("lazy").setup(plugins)

require("onedark").setup {
    style = 'darker',
}

require("onedark").load()

require("nvim-treesitter.configs").setup(
	{
		-- Put your languages here to to enable syntax highlighting for it
		-- Check here: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
		ensure_installed = { "lua", "python" },

		auto_install = true,
		highlight = { enable = true },
	}
)

local cmp = require("cmp")

cmp.setup({
	window = {
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({select = true}),
	}),
	sources = cmp.config.sources({
		-- Critical for nvim completion functionalities
		{ name = "nvim_lsp" },
	})
})

require("mason").setup()
require("mason-lspconfig").setup(
	{
		automatic_installation = true,

		-- LSPs to install
		-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
		ensure_installed = { "lua_ls", "pylsp" },
	}
)

require("neodev").setup({})

local lspconfig = require("lspconfig")

-- Lua LSP configurations
lspconfig.lua_ls.setup({ settings = { Lua = { completion = { callSnippet = "Replace" } } } })

-- Python LSP configurations
lspconfig.pylsp.setup({ setting = { pylsp = { } } })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('lualine').setup()
