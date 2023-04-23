local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate"
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = '0.1.1',
		branch = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	{"navarasu/onedark.nvim"},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
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
		ensure_installed = { "lua", "python" },
		auto_install = true,
		highlight = { enable = true },
	}
)

require("mason").setup()
require("mason-lspconfig").setup(
	{
		automatic_installation = true,
		ensure_installed = { "lua_ls", "pylsp" },
	}
)

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({ settings = { Lua = { } } })
lspconfig.pylsp.setup({ setting = { pylsp = { } } })
