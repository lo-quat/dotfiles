-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "ts_ls", "eslint" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.ruby_lsp.setup {
  cmd = { "bundle", "exec", "ruby-lsp" },
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  init_options = {
    formatter = "rubocop",
    linters = { "rubocop" },
  },
}
