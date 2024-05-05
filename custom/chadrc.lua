---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "decay",
  theme_toggle = { "decay", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    overriden_modules = function(modules)
      -- 現在開いてるファイルのフルパスを取得
      local current_file = vim.api.nvim_buf_get_name(0)
      -- ルートディレクトリから見たカレントファイルまでの相対パスを取得
      local relative_path_to_current_file = vim.fn.fnamemodify(current_file, ':~:.')
      -- 一階層上までの相対パスを取得
      local parent_dir_relative_to_root = vim.fn.fnamemodify(relative_path_to_current_file, ':h')
      -- modules[9] = parent_dir_relative_to_root
      modules[10] = parent_dir_relative_to_root
    end
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
