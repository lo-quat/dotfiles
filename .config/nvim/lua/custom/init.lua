local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.opt.autoread = true
vim.api.nvim_set_var("copilot", { accept_key = '<A-Tab>' })
-- rubocop lsp setting
-- autocmd("FileType", {
--   pattern = "ruby",
--   callback = function()
--     vim.lsp.start {
--       name = "rubocop",
--       cmd = { "dip", "rubocop", "--lsp" },
--     }
--   end,
-- })
-- rubocop auto format
-- autocmd("BufWritePre", {
--   pattern = "ruby",
--   callback = function ()
--     vim.lsp.format()
--   end,
-- })
