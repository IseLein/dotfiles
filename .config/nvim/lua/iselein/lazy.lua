local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-tree/nvim-web-devicons' },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
            ensure_installed = { 'lua' },
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = { enable = true },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim', opts = {} },
        },
    },
    -- {
    --     'stevearc/conform.nvim',
    --     opts = {
    --         notify_on_error = false,
    --         format_on_save = function(bufnr)
    --             local disable_filetypes = { c = true, cpp = true }
    --             return {
    --                 timeout_ms = 500,
    --                 lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    --             }
    --         end,
    --         formatters_by_ft = {
    --             lua = { 'stylua' },
    --         },
    --     },
    -- },
    {
        'hrsh7th/nvim-cmp',
        -- event = 'InsertEnter',
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    {
                        'rafamadriz/friendly-snippets',
                        config = function()
                            require('luasnip.loaders.from_vscode').lazy_load()
                        end,
                    },
                },
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'onsails/lspkind.nvim',
        },
    },
    -- qol
    { 'tpope/vim-sleuth' },
    { 'lewis6991/gitsigns.nvim', opts = {} },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
        opts = {},
    },
    -- { "lukas-reineke/indent-blankline.nvim",
    --     main = "ibl"
    -- },

    -- latex
    { "xuhdev/vim-latex-live-preview" },
    { "lervag/vimtex" },

    -- { "github/copilot.vim" },
    {
        "supermaven-inc/supermaven-nvim",
        config = function ()
            require("supermaven-nvim").setup({})
        end,
    },

    { "ThePrimeagen/vim-be-good" },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            graph_style = "ascii",
        }
    },

    { "brenoprata10/nvim-highlight-colors" },

    { "slugbyte/lackluster.nvim" },
    { "kdheepak/monochrome.nvim" },
    {
        "ellisonleao/gruvbox.nvim",
        opts = {
            overrides = {
                SignColumn = { bg = "bg" }
            },
            italic = {
                strings = false,
                emphasis = false,
                comments = false,
                operators = false,
            },
        }
    },
    { "p00f/alabaster.nvim" },
    {
        "nuvic/flexoki-nvim",
        name = "flexoki",
        opts = {
            styles = {
                bold = false,
            },
        },
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                component_separators = { left = '|', right = '|'},
                section_separators = { left = '', right = ''}
            }
        }
    },
    { "nvim-treesitter/nvim-treesitter-context", opts = {} },
    {
        "llm.nvim",
        dir = vim.fn.stdpath("config") .. "/lua/llm",
        config = function()
            require("llm").setup()
        end,
    },

})
