return {
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "background", -- Options: 'background', 'foreground', 'virtual'
        virtual_symbol = "■",
        enable_tailwind = true, -- <--- Critical for Tailwind
      })
    end,
  }
}
