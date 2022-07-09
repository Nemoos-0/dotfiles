require('telescope').setup()

vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
