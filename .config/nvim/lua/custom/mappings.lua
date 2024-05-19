---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>ch"] = {
      function()
        require("CopilotChat").open()
      end,
    },
    ["<leader>ccq"] = {
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick chat",
    },
    ["<leader>yp"] = { ":let @+=expand('%')<CR>", "yank copy" },
  },
}
M.disabled = {
  i = {
    -- navigate within insert mode
    ["<C-h>"] = "",
    ["<C-i>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  }
}

M.telescope = {
  n = {
    ["<leader>fw"] = {
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
    },
    ["<leader>fb"] = { ":Telescope file_browser path=%:p:h initial_mode='normal' previewer=false select_buffer=true<CR>", "file_browser", opts = { noremap = true } }
  },
}

-- more keybinds!

return M
