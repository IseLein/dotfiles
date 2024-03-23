require("rose-pine").setup({
    variant = "main",
    dark_variant = "main",
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    bold_vert_split = true,

    enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
    },

    styles = {
        italic = false,
        transparency = false,
    },

    groups = {
        background = "base",
        background_nc = "_experimental_nc",
        panel = "surface",
        panel_nc = "base",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",


        border = "base",
    },

    highlight_groups = {
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
        CursorLineNr = { fg = "rose" },

        -- hello
        Comment = { italic = true },
    }
})

-- vim.cmd.colorscheme("rose-pine")
