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
set ffs=dos,unix
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
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'neovim/nvim-lspconfig', tag = 'v0.1.7', dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' } },
  { 'github/copilot.vim', tag = 'v1.13.0' }, 
  { 'fatih/vim-go', tag = 'v1.28' },
  { 'nvim-tree/nvim-tree.lua', tag='v0.99', }
})

vim.cmd.colorscheme "catppuccin-mocha"

require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "gopls", "bufls", "html", "tsserver", "bashls" },
}

require('lspconfig').gopls.setup{}
require('lspconfig').bufls.setup{}
require('lspconfig').html.setup{}
require('lspconfig').tsserver.setup{}

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
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.g.nvim_tree_respect_buf_cwd = 1
require("nvim-tree").setup({
  renderer = { icons = { show = { git = false, folder = false, file = false, folder_arrow = false } } },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
})
vim.keymap.set("n", "<leader>fo", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- golang
vim.keymap.set("n", "<leader>gb", ":GoBuild<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gr", ":GoReferrers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":GoCallers<CR>", { noremap = true, silent = true })