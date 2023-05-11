require("rose-pine").setup({
    variant = "auto",
    dark_variant = "main",
    bold_vert_split = true,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = true,

    groups = {
        background = "base",
        background_nc = "_experimental_nc",
        panel = "surface",
        panel_nc = "base",
        border = "_experimental_nc",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        }
    },

    highlight_groups = {
        NvimTreeNormal = { bg = "_experimental_nc" },

        MasonHeader = { fg = "base", bg = "gold" },
        MasonHighlight = { fg = "foam" },
        MasonHighlightBlock = { fg = "base", bg = "pine" },
        MasonHighlightBlockBold = { fg = "base", bg = "foam" },
        MasonMuted = { fg = "muted" },
        MasonMutedBlock = { fg = "base", bg = "muted" },
        MasonMutedBlockBold = { fg = "base", bg = "muted" },

        IndentBlanklineChar = { fg = "muted" },
        IndentBlanklineSpaceChar = { fg = "muted" },
        IndentBlanklineContextChar = { fg = "rose" },

        CursorLine = { bg = "base" },
    }
})

vim.cmd.colorscheme("rose-pine")
