
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
  { "blazkowolf/gruber-darker.nvim", priority = 1000 , config = true, opts = {} },
  { 'kevinhwang91/nvim-bqf', tag= 'v1.1.1' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'neovim/nvim-lspconfig', tag = 'v2.0.0', dependencies = { 
    'williamboman/mason.nvim', 
    'williamboman/mason-lspconfig.nvim' 
    } 
  },
  { 'nvim-tree/nvim-tree.lua', tag='v1.14.0', },
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
          -- Completion Sources
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
      },
      config = function()
          local cmp = require('cmp')

          cmp.setup({
              enabled = function()
                local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
                local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
                if buftype == "prompt" then
                  return false
                end
                return filetype ~= "text"
              end,
              window = {
                  completion = cmp.config.window.bordered(),
                  documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert({
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
              }),
              sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
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

require("gruber-darker").setup {}
vim.cmd([[colorscheme gruber-darker]])

vim.opt.syntax = 'on'
vim.cmd('TSEnable highlight') 

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
    "python",
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
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      }
    },
  },
}

require("mason").setup()
require("mason-lspconfig").setup{
  ensure_installed = { "gopls", "html", "bashls", "eslint", "pyright" },
}

require('gitlinker').setup()

require'lspconfig'.gopls.setup{}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local offset_encoding = client and client.offset_encoding or 'utf-16'
    local params = vim.lsp.util.make_range_params(0, offset_encoding)
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

require'lspconfig'.html.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.pyright.setup{}

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
  view = { adaptive_size = true },
})

vim.diagnostic.config({
  virtual_text = true,  -- Show diagnostics as virtual text
  signs = true,         -- Show signs in the sign column
  underline = true,     -- Underline the text with an error
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    -- 2
    vim.api.nvim_create_autocmd("BufWritePre", {
      -- 3
      buffer = args.buf,
      callback = function()
        -- 4 + 5
        vim.lsp.buf.format {async = false, id = args.data.client_id }
      end,
    })
  end
})

require("neogit").setup()

vim.keymap.set("n", "<leader>fo", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-L>", "gt", { noremap = true, silent = true })
vim.keymap.set("n", "<C-H>", "gT", { noremap = true, silent = true })

vim.keymap.set('n', 'gsd', '<cmd>sp<CR><cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})
vim.keymap.set('n', 'gvd', '<cmd>vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})

vim.keymap.set('n', '<leader>gr', '<cmd>Telescope lsp_references<CR>', {noremap=true, silent=true})
vim.keymap.set('n', '<leader>gd', '<cmd>Telescope lsp_definitions<CR>', {noremap=true, silent=true})

vim.keymap.set("n", "<leader>tb", ":Git blame<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>td", ":Git diff<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tt", ":terminal<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ng", ":Neogit<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>tl', '<cmd>lua require"gitlinker".get_buf_range_url(mode, user_opts)<CR>', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>tl', '<cmd>lua require"gitlinker".get_buf_range_url(mode, user_opts)<CR>', {})

vim.keymap.set("n", '<Leader>qc', ":cclose<CR>", { desc = "Close Quickfix Window" })
vim.keymap.set("n", '<Leader>lc', ":lclose<CR>", { desc = "Close Location List Window" })

vim.keymap.set("n", "<leader>rr", ":LspRestart<CR>", { noremap = true, silent = false })

vim.keymap.set("n", "<leader>wq", ":wq!<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>qa", ":qa!<CR>", { noremap = true, silent = false })

vim.keymap.set('n', '<Leader>wt', [[:%s/\s\+$//e<cr>]])

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

if vim.g.neovide then
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00
    vim.o.guifont = "JetBrains Mono:h16"
end

