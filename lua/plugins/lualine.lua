return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = "rose-pine",
      component_separators = "|",
      section_separators = "",
    },
  },
}
