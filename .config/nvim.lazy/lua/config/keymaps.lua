-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--

-- esc to exit insert mode in terminal mode.
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- Open definitions in splits.
vim.keymap.set("n", "gsd", "<cmd>sp<CR><cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gvd", "<cmd>vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- quickfix.
vim.keymap.set("n", "<Leader>qc", ":cclose<CR>", { desc = "Close Quickfix Window" })
vim.keymap.set("n", "<Leader>lc", ":lclose<CR>", { desc = "Close Location List Window" })

-- Other ways to quit.
vim.keymap.set("n", "<leader>wq", ":wq!<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>qa", ":qa!<CR>", { noremap = true, silent = false })
