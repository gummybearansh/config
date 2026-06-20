return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", 
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    
    dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: huge library of snippets

    config = function()
      local ls = require("luasnip")

      -- Load snippets from our custom file
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })

      -- Keymaps to jump between snippet placeholders (e.g. jumping from int main() to inside the loop)
      vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
    end,
  }
}
