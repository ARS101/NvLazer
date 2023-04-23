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
		"https://github.com/nvim-telescope/telescope.nvim",
		tag = '0.1.1',
		branch = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{"https://github.com/navarasu/onedark.nvim"},
}


require("lazy").setup(plugins)

require('onedark').setup {
    style = 'darker',
    code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },
}

require('onedark').load()
