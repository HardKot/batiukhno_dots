-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        keymap = {
          accept = false, -- handled by completion engine
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              -- set the ai_accept function
              ai_accept = function()
                if require("copilot.suggestion").is_visible() then
                  require("copilot.suggestion").accept()
                  return true
                end
              end,
            },
          },
        },
      },
    },
  },

  {
    "tzachar/cmp-ai",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local cmp_ai = require('cmp_ai.config')
      cmp_ai:setup({
        max_lines = 100,
        provider = 'Ollama',
        provider_options = {
          model = 'codellama:7b-instruct-q4_K_M', 
          host = 'localhost',
          port = '11434',
        },
        notify = true,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Добавляем cmp_ai в список источников (к словам, LSP и сниппетам)
      table.insert(opts.sources, 1, { name = "cmp_ai" })
    end,
  }
}
