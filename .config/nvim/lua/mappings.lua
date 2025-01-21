require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local unmap = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fb", ":Telescope buffers initial_mode=normal<CR>")
map("n", "<leader>fw", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Telescope live grep args" })
map("n", "<leader>fg", ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>", { desc = "Telescope grep word under cursor" })
map("n", "<leader>gt", ":Telescope git_status initial_mode=normal<CR>", { desc = "Telescope Git status" })
map("n", "<leader>gc", ":CopilotChat<CR>", { desc = "GitHub Copilot chat" })
map("n", "<leader>yp", ":let @+=expand('%:~:.')<CR>", { desc = "Copy relative path to clipboard" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Enter terminal nomal mode" })
map("n", "<C-p>", ":lua require('nvchad.tabufline').move_buf(1)<CR>", { desc = "Move buffer right" })
map("n", "<C-q>", ":lua require('nvchad.tabufline').move_buf(-1)<CR>", { desc = "Move buffer left" })
unmap("i", "<C-h>")
map("n", "<leader>rs", function()
  require("nvchad.term").runner {
    id = "rspec",
    pos = "vsp",
    size = 0.5,
    cmd = function()
      local file = vim.fn.expand "%"
      local line = vim.fn.line(".")
      local cmd_prefix
      if vim.fn.filereadable(vim.fn.getcwd() .. "/dip.yml") == 1 then
        cmd_prefix = "dip rspec "
      else
        cmd_prefix = "bundle exec rspec "
      end
      return cmd_prefix .. file .. ":" .. line
    end,
  }
end, { desc = "Rspec current line" })
