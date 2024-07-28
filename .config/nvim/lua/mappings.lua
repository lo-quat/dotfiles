require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fb", ":Telescope buffers initial_mode=normal<CR>")
map("n", "<leader>fw", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Telescope live grep args" })
map("n", "<leader>gt", ":Telescope git_status initial_mode=normal<CR>", { desc = "Telescope file browser" })
map("n", "<leader>gc", ":CopilotChat<CR>", { desc = "GitHub Copilot chat" })
map("n", "<leader>yp", ":let @+=expand('%:~:.')<CR>", { desc = "Copy relative path to clipboard" })
