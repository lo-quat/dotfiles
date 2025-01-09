return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettier"
  		},
  	},
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
  	},
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      local nodenv_node = vim.fn.expand("$HOME") .. "/.nodenv/versions/22.11.0/bin/node"
      local asdf_node = "/opt/asdf-data/installs/nodejs/22.11.0/bin/node"
      local node_command = vim.fn.filereadable(nodenv_node) == 1 and nodenv_node or asdf_node

      require("copilot").setup({
        panel = {
          auto_refresh = true,
        },
        suggestion = {
          auto_trigger = true,
        },
        filetypes = {
          gitcommit = true,
        },
        copilot_node_command = node_command
      })
    end,
    lazy = true,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    cmd = { "CopilotChat", "CopilotChatExplain" },
    config = function()
      require("CopilotChat").setup({
        show_help = false,
        prompts = {
          Explain = {
              prompt = "/COPILOT_EXPLAIN 選択範囲のコード処理を日本語で解説してください"
          },
        },
        mappings = {
          complete = {
            insert ='',
          }
        }
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },

    require("telescope").setup({
      theme = "decay",
      defaults = {
        layout_config = {
          horizontal = {
            prompt_position = "top",
          },
        },
        border = {},
      },
    })
  },

  {
    "slim-template/vim-slim",
    ft = "slim"
  },
}
