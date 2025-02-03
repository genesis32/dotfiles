-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.g.mapleader = " "

-- Set various options
vim.opt.autoread = true
vim.opt.compatible = false
vim.opt.autoindent = true
vim.opt.backspace = { 'indent', 'eol', 'start' }

-- Search options
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indentation and tabs
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.tabstop = 2

-- UI and interface options
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.foldenable = false
vim.opt.colorcolumn = '120'
vim.opt.belloff = 'all'
vim.opt.cursorline = true

-- Clipboard
vim.opt.clipboard:append('unnamedplus')

-- Key mappings
vim.keymap.set('n', '<F3>', ':set invrelativenumber<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Wildignore
vim.opt.wildignore:append({ 'node_modules/**', '*.pyc' })

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Statusline
vim.opt.laststatus = 2
vim.opt.statusline = table.concat({
    '%<',                    -- Cut at start
    '%2*[%n%H%M%R%W]%*',     -- Flags and buffer number
    '%-40f ',                -- Path
    '%=',                    -- Align right
    '%1*%y%*%* ',            -- File type
    '%10((%l,%c)%) ',        -- Line and column
    '%P'                     -- Percentage of file
})


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
  { "blazkowolf/gruber-darker.nvim", priority = 1000 , config = true },
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
  },
  { 'hrsh7th/nvim-cmp', dependencies = {
          -- Snippet Engine
          'L3MON4D3/LuaSnip',

          -- Completion Sources
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'saadparwaiz1/cmp_luasnip',

          -- Go-specific sources
          'rafamadriz/friendly-snippets'
      },
      config = function()
          local cmp = require('cmp')
          local luasnip = require('luasnip')

          -- Load friendly-snippets
          require('luasnip.loaders.from_vscode').lazy_load()

          cmp.setup({
              snippet = {
                  expand = function(args)
                      luasnip.lsp_expand(args.body)
                  end,
              },
              window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
--                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--                ['<C-f>'] = cmp.mapping.scroll_docs(4),
--                ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
              }),
              sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'buffer' },
                  { name = 'path' }
              })
          })
      end
  },
  { "github/copilot.vim",
      -- Optional: Configure Copilot
      config = function()
          -- Optional configuration settings
          vim.g.copilot_no_tab_map = true

          -- Optional: Custom keymappings
          vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
              expr = true,
              replace_keycodes = false
          })
      end,

      -- Optional: Only load in certain conditions
      cond = function()
          -- For example, only load if certain conditions are met
          return vim.fn.executable('node') == 1
      end
  },
})

vim.opt.syntax = 'on'
vim.cmd('TSEnable highlight') 

require("gruber-darker").setup {}
vim.cmd([[colorscheme gruber-darker]])
-- vim.cmd([[colorscheme gruvbox]])
-- vim.cmd[[colorscheme tokyonight-night]]

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
     additional_vim_regex_highlighting = { 'markdown' },
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
    "markdown",
    "markdown_inline",
    "terraform",
  },
}


require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "gopls", "html", "bashls" },
}

require('gitlinker').setup()
require('lspconfig').gopls.setup{}
require('lspconfig').html.setup{}

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

vim.keymap.set("n", "<C-L>", "gt", { noremap = true, silent = true })
vim.keymap.set("n", "<C-H>", "gT", { noremap = true, silent = true })

vim.keymap.set('n', '<LEADER>jd', '<cmd>lua require"telescope.builtin".lsp_definitions({})<CR>', {noremap=true, silent=true})
vim.keymap.set('n', '<LEADER>js', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<CR>', {noremap=true, silent=true})
vim.keymap.set('n', '<LEADER>jv', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>', {noremap=true, silent=true})

-- golang
vim.keymap.set("n", "<leader>gb", ":GoBuild<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gr", ":GoReferrers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gc", ":GoCallers<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>tb", ":Git blame<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>td", ":Git diff<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tt", ":terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tg", ":Neogit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tp", ":Git push<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>lua require"gitlinker".get_buf_range_url(mode, user_opts)<CR>', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>tl', '<cmd>lua require"gitlinker".get_buf_range_url(mode, user_opts)<CR>', {})

vim.keymap.set("n", '<Leader>qc', ":cclose<CR>", { desc = "Close Quickfix Window" })
vim.keymap.set("n", '<Leader>lc', ":lclose<CR>", { desc = "Close Location List Window" })

vim.keymap.set("n", "<leader>rr", ":LspRestart<CR>", { noremap = true, silent = false })

vim.keymap.set("n", "<leader>wq", ":wq!<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>qa", ":qa!<CR>", { noremap = true, silent = false })

vim.keymap.set('n', '<Leader>wt', [[:%s/\s\+$//e<cr>]])

if vim.g.neovide then
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00
    vim.o.guifont = "Fira Code:h16"
end

