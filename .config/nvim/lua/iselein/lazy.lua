local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable", -- latest stable release
	lazypath,
    })
end vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-file-browser.nvim", dependencies = {
            { "nvim-telescope/telescope.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
    },
    { "theprimeagen/harpoon"},
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    {
        'VonHeikemen/lsp-zero.nvim',
	    branch = 'v2.x',
	    dependencies = {
	        -- LSP Support
	        {'neovim/nvim-lspconfig'},             -- Required
	        {                                      -- Optional
	            'williamboman/mason.nvim',
	    	    build = function()
	    	        pcall(vim.cmd, 'MasonUpdate')
	    	    end,
	        },
	        {'williamboman/mason-lspconfig.nvim'}, -- Optional

	        -- Autocompletion
	        {'hrsh7th/nvim-cmp'},     -- Required
	        {'hrsh7th/cmp-nvim-lsp'}, -- Required
	        {'L3MON4D3/LuaSnip'},     -- Required
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-nvim-lua'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'rafamadriz/friendly-snippets'},
        },
    },
    { "folke/neodev.nvim" },

    -- linter
    { "mfussenegger/nvim-lint" },

    -- treesitter + looks
    {
        "nvim-treesitter/nvim-treesitter",
	    dependencies = {
	        "nvim-treesitter/nvim-treesitter-textobjects",
	    },
	    build = ":TSUpdate",
    },
    { "nvim-treesitter/playground" },
    { "nvim-treesitter/nvim-treesitter-context" },

    -- razor syntax highlighting
    { "jlcrochet/vim-razor" },

    { "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons" } },
    { "numToStr/Comment.nvim", opts = {} },
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "folke/trouble.nvim", dependencies = { "kyazdani42/nvim-web-devicons" }, opts = { icons = true } },
    { "j-hui/fidget.nvim", tag="legacy" },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    { "nvim-tree/nvim-tree.lua", dependencies = { "kyazdani42/nvim-web-devicons" } },

    -- color schemes
    { "rose-pine/neovim", name = "rose-pine" },
    { "folke/tokyonight.nvim" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "decaycs/decay.nvim", name = "decay" },
    { "dasupradyumna/midnight.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
    { "tjdevries/colorbuddy.nvim" },
    { "nikolvs/vim-sunbather" },

    -- vim be good
    { "ThePrimeagen/vim-be-good" },

    -- indenting
    { "tpope/vim-sleuth" },

    -- tex live preview
    { "xuhdev/vim-latex-live-preview" },
    { "lervag/vimtex" },

    -- activity watch
    { "ActivityWatch/aw-watcher-vim" },

    -- copilot
    { "github/copilot.vim" },
})
