return {
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("competitest").setup({
        runner_ui = {
          interface = "popup",
          -- This is the Magic Section: Direct Navigation!
          -- Now you can just press C-h, C-j, etc. to jump windows without the 'w' prefix
          mappings = {
            ["n"] = {
              ["<C-h>"] = { command = "wincmd h" },
              ["<C-j>"] = { command = "wincmd j" },
              ["<C-k>"] = { command = "wincmd k" },
              ["<C-l>"] = { command = "wincmd l" },
            }
          }
        },

        popup_ui = {
          total_width = 0.85,
          total_height = 0.80,
          layout = {
            -- Row 1: Test Cases (40% height) - Reduced slightly to give space below
            { 4, "tc" }, 
            -- Row 2: Input / Output (50% height) - The most important part
            { 5, { { 1, "si" }, { 1, "so" } } }, 
            -- Row 3: Stderr / Expected (10% height) - Just a small footer
            { 2, { { 1, "se" }, { 1, "eo" } } }, 
          },
        },
        
        -- Your Compiler Settings (Unchanged)
        testcases_directory = "./.competitest/",
        save_current_file = true,
        save_all_files = false,
        compile_directory = ".",
        compile_command = {
          cpp = { exec = "g++", args = { "-std=c++17", "$(FNAME)", "-o", "$(FNOEXT)" } },
        },
        running_directory = ".",
        run_command = {
          cpp = { exec = "./$(FNOEXT)" },
          -- ==========================================
          -- NEW: Run Python files using PyPy3
          -- ==========================================
          python = { exec = "pypy3", args = { "$(FNAME)" } },
        },
      })
    end,

    -- Your New 'c' Prefix Keymaps
    keys = {
      { "<leader>cr", "<cmd>CompetiTest run<cr>", desc = "Run Test Cases" },
      { "<leader>ca", "<cmd>CompetiTest add_testcase<cr>", desc = "Add Test Case" },
      { "<leader>ce", "<cmd>CompetiTest edit_testcase<cr>", desc = "Edit Test Cases" },
      { "<leader>ci", "<cmd>CompetiTest receive testcases<cr>", desc = "Receive Test Cases" },
    },
  }
}
