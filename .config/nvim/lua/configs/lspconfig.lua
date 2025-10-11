require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "eslint",
  "ruby_lsp",
}

vim.lsp.config("ruby_lsp", {
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop" },
  },
})

vim.lsp.enable(servers)
