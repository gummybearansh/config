return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- which-key automatically picks up the `desc` attribute from your keymaps
    -- Here we can register group names so the popup shows nice labels for prefixes
    spec = {
      { "<leader>c", group = "Code", mode = { "n", "x" } },
      { "<leader>d", group = "Diagnostics", mode = { "n" } },
      { "<leader>g", group = "Git", mode = { "n", "v" } },
      { "<leader>u", group = "Utility/UI", mode = { "n" } },
      { "<leader>w", group = "Windows", mode = { "n" } },
      { "<leader>x", group = "Trouble/Quickfix", mode = { "n" } },
      { "<leader>t", group = "Toggle", mode = { "n" } },
    },
  },
}
