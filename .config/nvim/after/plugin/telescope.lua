local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pg", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

require("telescope").setup {
    extensions = {
        mappings = {
            ["i"] = {},
            ["n"] = {},
        },
    },
}

local telescope = require('telescope')
telescope.load_extension('fzf')
telescope.load_extension('ui-select')
