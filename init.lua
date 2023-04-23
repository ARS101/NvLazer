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
plugins = {

	-- Treesitter provides basic functionalities such as highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},

	-- Telescope is a powerful fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = '0.1.1',
		branch = '0.1.1',
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
			{
				"L3MON4D3/LuaSnip",
				version = "1.*",
			},
			"hrsh7th/cmp-nvim-lsp",
		}
	}
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
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
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
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
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

local lspconfig = require("lspconfig")

-- Lua LSP configurations
lspconfig.lua_ls.setup({ settings = { Lua = { } } })

-- Python LSP configurations
lspconfig.pylsp.setup({ setting = { pylsp = { } } })
