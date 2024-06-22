require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fb", ":Telescope file_browser path=%:p:h previewer=false select_buffer=true<CR>", { desc = "file browser" })
map("n", "<leader>fw", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "live grep args" })
map("n", "<leader>gc", ":CopilotChat<CR>", { desc = "GitHub Copilot chat" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
