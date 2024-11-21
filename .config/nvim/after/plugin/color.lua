vim.opt.background = "light"
vim.cmd.colorscheme('flexoki')

require('nvim-highlight-colors').setup {
    render = 'virtual',
    virtual_symbol = '■',
    enable_named_colors = true,
    enable_tailwind = true,
}

-- ibl
-- local scope = "focus"
-- local indent = "passive"
--
-- local hooks = require("ibl.hooks")
--
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--     vim.api.nvim_set_hl(0, "focus", { fg = "#adadad" })
--     vim.api.nvim_set_hl(0, "passive", { fg = "#adadad" })
-- end)
--
-- require("ibl").setup({
--     scope = { highlight = scope },
--     indent = { highlight = indent }
-- })
