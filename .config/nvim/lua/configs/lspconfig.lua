require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "eslint",
}

vim.lsp.config("ruby_lsp", {
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop" },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
})

-- Start ruby_lsp only when bundle is installed
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function(ev)
    local root = vim.fs.root(ev.buf, { "Gemfile" })
    if not root then
      return
    end
    vim.system({ "bundle", "check" }, { cwd = root }, function(obj)
      if obj.code == 0 then
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(ev.buf) then
            return
          end
          vim.lsp.start({
            name = "ruby_lsp",
            cmd = { "ruby-lsp" },
            root_dir = root,
          })
        end)
      end
    end)
  end,
})

vim.lsp.enable(servers)
