vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- terminal esc
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

vim.keymap.set("n", "<leader>wh", [[<C-w>h]], { noremap = true })
vim.keymap.set("n", "<leader>wl", [[<C-w>l]], { noremap = true })
vim.keymap.set("n", "<leader>wj", [[<C-w>j]], { noremap = true })
vim.keymap.set("n", "<leader>wk", [[<C-w>k]], { noremap = true })
vim.keymap.set("n", "<leader>ws", "<cmd>sp<cr>", { noremap = true })
vim.keymap.set("n", "<leader>wv", "<cmd>vs<cr>", { noremap = true })

-- bindings for Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",
    { silent = true, noremap = true }
)

-- bindings for nvim tree
vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tff", "<cmd>NvimTreeFindFile<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tc", "<cmd>NvimTreeCollapse<cr>",
    { silent = true, noremap = true }
)

-- bindings for undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle,
    { silent = true, noremap = true }
)

-- bindings for vim-fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git,
    { silent = true, noremap = true }
)

-- bindings for supermaven
vim.keymap.set("n", "<leader>mm", vim.cmd.SupermavenToggle,
    { silent = true, noremap = true }
)
