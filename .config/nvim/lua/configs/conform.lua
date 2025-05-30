local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    ruby = { "ruby_lsp" },
    css = { "prettierd" },
    html = { "prettierd" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    -- timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
