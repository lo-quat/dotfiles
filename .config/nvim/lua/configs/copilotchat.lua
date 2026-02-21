require("CopilotChat").setup {
  model = "claude-opus-4.6",
  show_help = true,
  mappings = {
    complete = {
      insert = "",
    },
  },
}

local function generate_commit_message()
  local chat = require("CopilotChat")
  chat.ask(
    "#gitdiff:staged\n\n"
      .. "Write a concise commit message title for the staged changes. "
      .. "Maximum 50 characters. Do not wrap in quotes. "
      .. "Output only the title, nothing else.",
    {
      headless = true,
      callback = function(response)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "gitcommit" then
            local content = vim.trim(response.content)
            content = content:gsub('^"(.*)"$', "%1")
            content = content:gsub("^'(.*)'$", "%1")
            vim.api.nvim_buf_set_lines(buf, 0, 0, false, { content })
            break
          end
        end
      end,
    }
  )
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function(args)
    if vim.b[args.buf].copilot_commit_done then
      return
    end
    vim.b[args.buf].copilot_commit_done = true
    vim.schedule(generate_commit_message)
  end,
})
