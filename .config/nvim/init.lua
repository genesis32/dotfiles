-- ==========================================================
-- Neovim init.lua — converted from _vimrc
-- ==========================================================

-- ── Bootstrap lazy.nvim ──────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")

local function definition_split_vertical()
  vim.lsp.buf.definition({
    on_list = function(options)
      if #options.items > 0 then
        local item = options.items[1]
        local cmd = "vsplit +" .. item.lnum .. " " .. item.filename .. " | normal " .. item.col .. "|"
        vim.cmd(cmd)
      end
    end,
  })
end

-- ── Plugins ──────────────────────────────────────────────
require("lazy").setup({
  {
    --"EdenEast/nightfox.nvim",
    "RostislavArts/naysayer.nvim",
    lazy = false,
    priority = 1000,
    config = function()
     vim.cmd.colorscheme("naysayer")
    end,
  },
  {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
  },
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim", opts = {} },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- This function runs every time a language server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable keybindings
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gvd", definition_split_vertical, opts)
        end,
      })

      -- Automatically set up language servers installed via Mason
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "bashls", "gopls", "ts_ls" },
        automatic_installation = true,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },
  {
  "github/copilot.vim",
  config = function()

    -- Only show suggestions when manually triggered
    vim.g.copilot_enabled = false  -- off by default

    -- Manually trigger suggestion
    vim.keymap.set("i", "<C-x>", "<Plug>(copilot-suggest)", { silent = true })

    -- Accept suggestion
    vim.keymap.set("i", "<C-y>", function()
      local suggestion = vim.fn["copilot#Accept"]("")
      if suggestion ~= "" then
        vim.api.nvim_feedkeys(suggestion, "n", true)
      end
    end, { silent = true })

    -- Dismiss suggestion
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { silent = true })

    -- Next / prev suggestion
    vim.keymap.set("i", "<C-j>", "<Plug>(copilot-next)", { silent = true })
    vim.keymap.set("i", "<C-k>", "<Plug>(copilot-previous)", { silent = true })
  end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        ensure_installed = { "go", "bash", "python", "javascript", "typescript", "terraform", "c", "cpp" },
        auto_install = true,
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
		"fatih/vim-go",
		ft = "go",
    build = ":GoInstallBinaries",
		config = function()
			vim.g.go_fmt_autosave = 1
			vim.g.go_fmt_command = "goimports"
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          vim.keymap.set("n", "<leader>dt", ":GoTest<CR>", { buffer = true, silent = true, desc = "Go Test" })
        end,
      })
		end,
  },
	{
		"NeogitOrg/neogit",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"nvim-telescope/telescope.nvim", -- optional
		},
		cmd = "Neogit",
	},
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP source
      "hrsh7th/cmp-buffer",      -- buffer words
      "hrsh7th/cmp-path",        -- file paths
      "L3MON4D3/LuaSnip",        -- snippet engine (required)
      "saadparwaiz1/cmp_luasnip" -- snippet source for cmp
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
            autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]  = cmp.mapping(function()
            if cmp.visible() then cmp.close()
            else cmp.complete() end
          end),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      word_diff = true
    },
  },
})

-- ── General ──────────────────────────────────────────────
vim.opt.autoread      = true
vim.opt.hidden        = true
vim.opt.showcmd       = true
vim.opt.belloff       = "all"
vim.opt.foldenable    = false
vim.opt.fileformats   = { "unix", "dos" }
vim.opt.backspace     = { "indent", "eol", "start" }

-- ── Line numbers ─────────────────────────────────────────
vim.opt.relativenumber = true
-- vim.opt.number         = true          -- show absolute on current line

-- ── Search ───────────────────────────────────────────────
vim.opt.hlsearch   = true
vim.opt.incsearch  = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- ── Indentation ──────────────────────────────────────────
vim.opt.autoindent  = true
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.softtabstop = 2
vim.opt.expandtab   = true

-- ── Appearance ───────────────────────────────────────────
vim.opt.cursorline  = true
vim.opt.laststatus  = 2
vim.opt.ruler       = true
vim.opt.termguicolors = true           -- needed for nightfox to look right

-- ── Splits ───────────────────────────────────────────────
vim.opt.splitbelow = true
vim.opt.splitright = true

-- ── Wildmenu ─────────────────────────────────────────────
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }

-- ── Statusline ───────────────────────────────────────────
vim.opt.statusline = table.concat({
  "%< ",                    -- cut at start
  "%2*[%n%H%M%R%W]%* ",    -- flags and buffer number
  "%-40f ",                 -- path
  "%=%1*%y%*%* ",           -- file type (right-aligned)
  "%10((%l,%c)%) ",         -- line and column
  "%P",                     -- percentage of file
})

-- ── Leader key ───────────────────────────────────────────
vim.g.mapleader = " "

local map = vim.keymap.set
map("n", "<Space>", "<Nop>", { silent = true })

-- Quit all
map("n", "<leader>qa", ":qa<CR>", { desc = "Quit all" })

map("n", "<leader>/", ":noh<CR>", { desc = "Clear search" })

-- Tab management
map("n", "<leader>tn", ":tabnew<CR>",      { desc = "New tab" })
map("n", "<leader>tl", ":tabnext<CR>",     { desc = "Next tab" })
map("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tc", ":tabclose<CR>",    { desc = "Close tab" })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Quickfix list
map("n", "<leader>cn", ":cnext<CR>", { desc = "Next Quickfix Entry" })
map("n", "<leader>cp", ":cprev<CR>", { desc = "Previous Quickfix Entry" })
map("n", "<leader>co", ":copen<CR>", { desc = "Open Quickfix List" })
map("n", "<leader>cc", ":cclose<CR>", { desc = "Close Quickfix List" })

-- git
map("n", "<leader>gg", ":Neogit<CR>", { desc = "Neogit" })
map("n", "<leader>gb", ":Gitsigns blame<CR>", { desc = "Git Blame" })

-- Format JSON with python
map("n", "<F2>", ":%!python3 -m json.tool<CR>", { desc = "Format JSON" })
