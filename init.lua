-- Setting lazy package installation path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Checking if lazy is installed in lazypath
if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy for the first time.")
    vim.fn.system({ "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath, })
    print("Installation complete.")
end

-- Adding lazypath to runtimepath (rtp)
vim.opt.rtp:prepend(lazypath)

-- Setting leader key
vim.g.mapleader = " "

-- Set line number and relative line number
vim.opt.nu = true
vim.opt.relativenumber = true

-- Set to 4 space tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- No line wrapping
vim.opt.wrap = false

vim.opt.scrolloff = 8

-- Update time to save the file
vim.opt.updatetime = 50

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
    { "navarasu/onedark.nvim" },

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
            -- Snippet engine required for completion to work
            { "L3MON4D3/LuaSnip", version = "1.*", },
        }
    },

    -- Signature help, docs and completion for the neovim lua API.
    { "folke/neodev.nvim" },

    -- A blazing fast and easy to configure neovim statusline plugin
    {
        "nvim-lualine/lualine.nvim",
        opts = { "nvim-tree/nvim-web-devicons" },
    },

    -- A file explorer for neovim
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        opts = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup {}
        end,
    },

    -- A togglable terminal plugin for neovim
    {
        's1n7ax/nvim-terminal',
        config = function()
            vim.o.hidden = true
            require('nvim-terminal').setup()
        end,
    },

    -- Editor tab plugin for showing opened files
    {
        'romgrk/barbar.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init = function() vim.g.barbar_auto_setup = false end,
        version = '^1.0.0',
    },

    -- Autoclose and autorename html tag using nvim-treesitter
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter", },
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
        -- Setting up snippet completion
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
        ensure_installed = { "lua_ls", "pylsp", "tsserver", "html", "cssls" },
    }
)

-- require("neodev").setup({})

local lspconfig = require("lspconfig")

-- Lua LSP configurations
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            -- Fix the annoyance of:
            -- Do you need to configure your work environment as `luv`?
            workspace = {
                checkThirdParty = false,
                library = {
                    "~/.luarocks/share/lua/5.4/",
                    "~/.luarocks/lib/lua/5.4/",
                    "/usr/share/nvim/runtime/lua/",
                    "/usr/share/awesome/lib/",
                    "~/.local/share/nvim/lazy",
                }
            },
            diagnostics = {
                globals = {
                    "awesome", "client", "screen", "root"
                }
            }
        }
    }
})

-- Python LSP configurations
lspconfig.pylsp.setup({
    setting = {
        pylsp = {
            plugins = {
                pylsp_mypy = { enabled = true },
                pylsp_black = { enabled = true },
                pylsp_isort = { enabled = true },
                pycodestyle = { enabled = true, maxLineLength = 88 },
            }
        }
    }
})

-- Typescript / Javascript LSP configurations
lspconfig.tsserver.setup({})

-- Enable (broadcasting of) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- HTML LSP configurations
lspconfig.html.setup({
    capabilities = capabilities,
})

-- CSS LSP configurations
lspconfig.cssls.setup({
    capabilities = capabilities,
})

require('nvim-ts-autotag').setup()

-- Telescope keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('lualine').setup({})

-- Formats the current file
vim.keymap.set("n", "<C-f>", function()
    vim.lsp.buf.format({ async = true })
    print("Formatted")
end, { silent = true })

-- Move the selected text up and down (with tab support)
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv")   -- Alt + Up Arrow Key
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv") -- Alt + Down Arrow Key

-- Keeps the selected search regex in the middle
-- when you go to next or previous occurance
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copies the selected line/text to your clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
