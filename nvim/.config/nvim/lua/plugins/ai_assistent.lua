

return {
  Copilot,
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
              accept = "<C-l>",
              dismiss = "<C-h>",
            },
          },
          panel = {
            enabled = false,
          },
          filetypes = {
            sh = true,
            lua = true,
            python = true,
            javascript = true,
            typescript = true,
            ["*"] = false,
          },
        }
      end, 100)
    end,
  },
}
