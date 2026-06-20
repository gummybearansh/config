return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- 1. FIX THE COMPLETION BOX COLORS (Darker background)
			vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#181825", fg = "#cdd6f4" }) -- Darker box background
			vim.api.nvim_set_hl(0, "CmpPmenuSel", { bg = "#313244", fg = "#cdd6f4", bold = true }) -- Selected item
			vim.api.nvim_set_hl(0, "CmpPmenuBorder", { bg = "#181825", fg = "#45475a" }) -- Optional darker border

			-- 2. LOCK THE GUTTER COLUMN (Stops screen from jumping/shifting layout)
			vim.opt.signcolumn = "yes"
      -- Replaces the annoying '~' markers on empty lines with invisible empty spaces
      vim.opt.fillchars = { eob = " " }
        -- 1. FORCE THE COMPLETION POPUPS TO USE THE PURE DARK BACKGROUND
      local cmp = require("cmp")
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered({
            -- Tells neovim to strip bright default float windows and make them dark charcoal
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
          }),
        },
      })


			mason_lspconfig.setup({
				-- THE WEB DEV + CPP STACK
				ensure_installed = {
					"lua_ls", -- Lua
					"clangd", -- C++
					"ts_ls", -- JavaScript / TypeScript
					"pyright", -- Python
					"html", -- HTML
					"cssls", -- CSS
					"tailwindcss", -- Tailwind CSS
				},

				-- HANDLERS (The Fixes)
				handlers = {
					-- Default handler (applies to things like html, css, etc.)
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,

					-- Fix for C++ (Offset Encoding)
					["clangd"] = function()
						lspconfig.clangd.setup({
							capabilities = capabilities,
							cmd = { "clangd", "--offset-encoding=utf-16" },
						})
					end,

					-- Fix for Lua (Undefined global 'vim')
					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									diagnostics = {
										globals = { "vim" },
									},
								},
							},
						})
					end,

					-- FIX FOR PYRIGHT
					["pyright"] = function()
						lspconfig.pyright.setup({
							capabilities = capabilities,
							settings = {
								python = {
									analysis = {
										autoSearchPaths = true,
										useLibraryCodeForTypes = true,
										diagnosticMode = "openFilesOnly",
									},
								},
							},
						})
					end,
				},
			})

			-- Diagnostic settings
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
	-- Separate block for keymaps to keep it clean
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set({ "n", "v" }, "<leader>ga", vim.lsp.buf.code_action, {})

			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
		end,
	},
}
