-- ==========================================================
-- Neovim init.lua — converted from _vimrc
-- Theme: nightfox (via lazy.nvim)
-- ==========================================================

-- ── Bootstrap lazy.nvim ──────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──────────────────────────────────────────────
require("lazy").setup({
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
          },
        },
      })
      vim.cmd("colorscheme nightfox")
    end,
  },
})

-- ── General ──────────────────────────────────────────────
vim.opt.autoread      = true
vim.opt.hidden        = true
vim.opt.showcmd       = true
vim.opt.belloff       = "all"
vim.opt.foldenable    = false
vim.opt.fileformats   = { "dos", "unix" }
vim.opt.backspace     = { "indent", "eol", "start" }

-- ── Line numbers ─────────────────────────────────────────
vim.opt.relativenumber = true
vim.opt.number         = true          -- show absolute on current line

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

-- Tab management
map("n", "<leader>tn", ":tabnew<CR>",      { desc = "New tab" })
map("n", "<leader>tl", ":tabnext<CR>",     { desc = "Next tab" })
map("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tc", ":tabclose<CR>",    { desc = "Close tab" })

-- Format JSON with python
map("n", "<F2>", ":%!python3 -m json.tool<CR>", { desc = "Format JSON" })
