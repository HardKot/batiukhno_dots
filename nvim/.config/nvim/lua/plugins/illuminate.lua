-- vim-illuminate
return {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
  opts = {
    providers = { "lsp" },
    delay = 200,
    filetypes_denylist = {
      "NvimTree",
      "toggleterm",
      "lazy",
    },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}