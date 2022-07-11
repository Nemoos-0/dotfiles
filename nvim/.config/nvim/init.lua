require('plugins')

-- Tab config
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Cursor
vim.wo.cursorline = true

-- Scroll
vim.opt.scrolloff = 3

-- Conceal
vim.opt.conceallevel = 2
vim.opt.concealcursor = "c"

-- Search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- Line number
vim.wo.number = true
vim.wo.relativenumber = true

-- Mouse
vim.o.mouse = 'a'

-- Wrap line
vim.wo.wrap = false
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Theme / Colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.wo.foldlevel = 1
vim.wo.foldenable = false

vim.g.tex_flavor = "latex"


-- Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Indent blankline
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

require('nvim-autopairs').setup {}
require('Comment').setup {}

-- Plugins settings
require('telescope-rc')
require('treesitter-rc')
require('lsp-rc')
require('snippet-rc')
require('cmp-rc')

