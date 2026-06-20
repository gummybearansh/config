return {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
      opts = {
        -- Make headings look like huge, bold text
        heading = {
          sign = false, -- Hides the '#' sign in the gutter
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- Adds cool icons
        },
        -- Make code blocks look like "bubbles" with background color
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
      },
      ft = { "markdown", "norg", "rmd", "org" },
      config = function(_, opts)
        require("render-markdown").setup(opts)
      end,
    },
}

