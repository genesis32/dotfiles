-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.cmd([[
syntax on
filetype plugin indent on
set autoread
set nocp
set ai
set bs=indent,eol,start
set hls is ic scs
set sw=4 sts=4 et
set ruler
set hidden
set tabstop=2
set shiftwidth=2
set expandtab
set relativenumber
set nocompatible
set showcmd
set nofoldenable
set colorcolumn=120

set belloff=all

set cursorline
set clipboard+=unnamedplus

noremap <F3> :set invrelativenumber<CR>

set wildignore+=node_modules/**,*.pyc

set splitright
set splitbelow

set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
set statusline+=%-40f\                    " path
set statusline+=%=%1*%y%*%*\              " file type
set statusline+=%10((%l,%c)%)\            " line and column
set statusline+=%P                        " percentage of file
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "thimc/gruber-darker.nvim", priority = 1000 , config = true },
--{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true },
--{ 'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {}, },
  { 'kevinhwang91/nvim-bqf', tag= 'v1.1.1' },
  { 'nvim-treesitter/nvim-treesitter', tag= 'v0.9.1', build = ':TSUpdate' },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'neovim/nvim-lspconfig', tag = 'v0.1.7', dependencies = { 
    'williamboman/mason.nvim', 
    'williamboman/mason-lspconfig.nvim' 
    } 
  },
  { 'github/copilot.vim', tag = 'v1.24.0' },
  { 'fatih/vim-go', tag = 'v1.28' },
  { 'nvim-tree/nvim-tree.lua', tag='v0.99', },
  { 'tpope/vim-fugitive', tag='v3.7', },
  { 'ruifm/gitlinker.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { "NeogitOrg/neogit", dependencies = {
    "nvim-lua/plenary.nvim",         
    "sindrets/diffview.nvim",        
    "nvim-telescope/telescope.nvim",
    },
  config = true
  }
})

require("gruber-darker").setup {
  transparent = true,
}
vim.cmd([[colorscheme gruber-darker]])
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd[[colorscheme tokyonight-night]]

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "terraform",
  },
}


require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "gopls", "bufls", "html", "tsserver", "bashls" },
}

-- default is <leader>gy
require('gitlinker').setup()
require('lspconfig').gopls.setup{}
require('lspconfig').bufls.setup{}
require('lspconfig').html.setup{}
require('lspconfig').tsserver.setup{}

require('bqf').setup({
  preview = {
    win_height = 999,
    winblend = 0,
  },
})

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "vendor/",
      ".git/",
      "node_modules/",
    },
  },
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- Install ripgrep.
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


vim.g.nvim_tree_respect_buf_cwd = 1
require("nvim-tree").setup({
  renderer = { icons = { show = { git = false, folder = false, file = false, folder_arrow = false } } },
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
})

require("neogit").setup()

vim.keymap.set("n", "<leader>fo", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- golang
vim.keymap.set("n", "<leader>gb", ":GoBuild<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gr", ":GoReferrers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":GoCallers<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>tb", ":Git blame<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>td", ":Git diff<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tt", ":terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tc", ":Neogit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>lua require"gitlinker".get_buf_range_url(mode, user_opts)<CR>', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>tl', '<cmd>lua require"gitlinker".get_buf_range_url(mode, user_opts)<CR>', {})


vim.keymap.set("n", '<Leader>qc', ":cclose<CR>", { desc = "Close Quickfix Window" })
vim.keymap.set("n", '<Leader>lc', ":lclose<CR>", { desc = "Close Location List Window" })

vim.keymap.set("n", "<leader>rr", ":LspRestart<CR>", { noremap = true, silent = false })

vim.keymap.set("n", "<leader>wq", ":wq!<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>qa", ":qa!<CR>", { noremap = true, silent = false })

vim.keymap.set('n', '<Leader>wt', [[:%s/\s\+$//e<cr>]])

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.0
  vim.g.neovide_scroll_animation_length = 0.0
end

