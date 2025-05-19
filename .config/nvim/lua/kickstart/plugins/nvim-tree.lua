return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  },
  config = function()
    require('nvim-tree').setup {}

    vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>tf', '<cmd>NvimTreeFocus<cr>', { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>tc', '<cmd>NvimTreeCollapse<cr>', { silent = true, noremap = true })
  end,
}
