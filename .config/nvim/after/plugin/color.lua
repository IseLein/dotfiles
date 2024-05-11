vim.opt.background = "light"
vim.cmd.colorscheme("sunbather")

require('nvim-highlight-colors').setup {
    render = 'virtual',
    virtual_symbol = '■',
    enable_named_colors = true,
    enable_tailwind = true,
}

vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#f0f0f0' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#f0f0f0' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#f0f0f0' })
