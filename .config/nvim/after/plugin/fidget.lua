local fidget = require("fidget")

fidget.setup({
    window = {
        blend = 0
    }
})

vim.api.nvim_set_hl(0, "FidgetTitle", { ctermbg = "none", bg = "none" })
vim.api.nvim_set_hl(0, "FidgetTask", { ctermbg = "none", bg = "none" })
