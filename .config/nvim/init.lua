vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

_G.open_pr_with_current_line_git_log = function()
  local line_number = vim.fn.line('.')
  local file_path = vim.fn.expand('%')
  local handle = io.popen('git log -L ' .. line_number .. ',' .. line_number .. ':' .. file_path)
  if not handle then
    print("Failed to execute git log command.")
    return
  end
  local result = handle:read("*a")
  handle:close()
  local commit_hash = result:match("commit (%w+)")
  if commit_hash then
    vim.fn.jobstart('git openpr ' .. commit_hash, {detach = true})
  else
    print("No commit hash found for the current line.")
  end
end

vim.cmd('command! Openpr lua open_pr_with_current_line_git_log()')

vim.cmd('language en_US')
