vim.opt.list = true
vim.opt.listchars:append "eol:↴"

require("ibl").setup({
    -- show_end_of_line = true,
    -- show_current_context = true
    whitespace = { remove_blankline_trail = false, },
})
